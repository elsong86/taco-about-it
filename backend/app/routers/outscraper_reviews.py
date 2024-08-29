from fastapi import APIRouter, HTTPException, Query, Depends, Request
from outscraper import ApiClient
from textblob import TextBlob
import os
from dotenv import load_dotenv
import logging
import json
from datetime import datetime, timezone, timedelta
from ..utils.rate_limiter import rate_limiter
from ..utils.redis_utils import redis_client
from ..services.supabase_service import SupabaseService
from typing import Callable  # Import Callable

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

load_dotenv()

api_key = os.getenv("OUTSCRAPER_API_KEY")
client = ApiClient(api_key)

# Instantiate the SupabaseService
supabase_service = SupabaseService(url=os.getenv("SUPABASE_URL"), key=os.getenv("SUPABASE_KEY"))

router = APIRouter()

def fetch_reviews(place_id: str):
    cache_key = f"reviews:{place_id}"
    cached_reviews = redis_client.get(cache_key)
    if cached_reviews:
        logger.info(f"Cache hit for place_id: {place_id}")
        return json.loads(cached_reviews)

    try:
        results = client.google_maps_reviews(
            place_id,
            reviews_limit=30,
            language='en',
            fields="reviews_data.review_text",
            sort="newest"
        )
        if results and isinstance(results, list) and len(results) > 0:
            reviews = results[0].get('reviews_data', [])
            non_empty_reviews = [review for review in reviews if review.get('review_text') and review['review_text'].strip()]

            redis_client.setex(cache_key, 3600, json.dumps(non_empty_reviews))
            logger.info(f"Cached reviews for place_id: {place_id}")

            return non_empty_reviews
        return []
    except Exception as e:
        logger.error(f"Error fetching reviews: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

def analyze_sentiments(reviews):
    sentiments = [TextBlob(review['review_text']).sentiment.polarity for review in reviews]
    if sentiments:
        average_sentiment = sum(sentiments) / len(sentiments)
    else:
        average_sentiment = 0.0
    return average_sentiment

def get_stored_reviews(place_id: str):
    # Define your freshness criteria (e.g., 24 hours)
    freshness_limit = timedelta(hours=24)
    now = datetime.now(timezone.utc)

    # Query the Supabase database for reviews related to place_id
    response = supabase_service.supabase.table("reviews").select("*").eq("place_id", place_id).execute()
    reviews = response.data

    if reviews:
        # Check if the reviews are recent enough
        latest_review = max(reviews, key=lambda r: r['created_at'])
        review_age = now - datetime.fromisoformat(latest_review['created_at'].replace('Z', '+00:00'))

        if review_age < freshness_limit:
            logger.info(f"Found recent reviews in the database for place_id: {place_id}")
            return reviews
    
    logger.info(f"No recent reviews found in the database for place_id: {place_id}")
    return None

@router.get("/reviews")
def get_reviews(place_id: str = Query(..., description="The Place ID of the business"), 
                limiter: Callable[[Request], None] = Depends(rate_limiter(redis_client, rate=1.0, capacity=10))):

    logger.info(f"Received request for place_id: {place_id}")

    try:
        # Check the Redis cache first
        cached_reviews = fetch_reviews(place_id)
        if cached_reviews:
            # Calculate the average sentiment for reviews from the cache
            average_sentiment = analyze_sentiments(cached_reviews)
            return {"average_sentiment": average_sentiment, "reviews": cached_reviews, "source": "cache"}

        # If not found in Redis, check the database
        stored_reviews = get_stored_reviews(place_id)
        if stored_reviews:
            # Calculate the average sentiment for reviews from the database
            average_sentiment = analyze_sentiments(stored_reviews)
            return {"average_sentiment": average_sentiment, "reviews": stored_reviews, "source": "database"}

        # If not found in Redis or database, fetch from Outscraper API
        reviews = fetch_reviews(place_id)
        
        # Store fetched reviews in the database without sentiment
        for review in reviews:
            supabase_service.store_review(place_id, review['review_text'], None)  # Sentiment is not stored

        # Calculate the average sentiment
        average_sentiment = analyze_sentiments(reviews)
        
        return {"average_sentiment": average_sentiment, "reviews": reviews, "source": "api"}
    except HTTPException as e:
        raise e
    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
