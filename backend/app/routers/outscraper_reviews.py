from fastapi import APIRouter, HTTPException, Query, Depends, Request
from outscraper import ApiClient
import logging
import json
import os
from datetime import datetime, timezone, timedelta
from ..utils.rate_limiter import rate_limiter
from ..utils.redis_utils import redis_client
from ..services.supabase_service import SupabaseService
from ..utils.sentiment_analysis import analyze_sentiments
from lingua import Language, LanguageDetectorBuilder
from pydantic import BaseModel, Field
from typing import Callable

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize Outscraper API client
api_key = os.getenv("OUTSCRAPER_API_KEY")  # Make sure this is set up in your environment variables
client = ApiClient(api_key)

# Instantiate the SupabaseService using the modularized Supabase client
supabase_service = SupabaseService()

# Initialize Lingua language detector with English enabled
detector = LanguageDetectorBuilder.from_languages(Language.ENGLISH, Language.SPANISH).build()

# Define the is_english function
def is_english(text):
    try:
        # Detect language using Lingua
        detected_language = detector.detect_language_of(text)
        return detected_language == Language.ENGLISH
    except Exception as e:
        logger.error(f"Error detecting language: {e}")
        return False

router = APIRouter()

def check_cache(place_id: str):
    cache_key = f"reviews:{place_id}"
    cached_reviews = redis_client.get(cache_key)
    if cached_reviews:
        logger.info(f"Cache hit for place_id: {place_id}")
        return json.loads(cached_reviews)
    return None

def fetch_reviews_from_api(place_id: str):
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
            
            # Filter out non-English reviews using is_english
            english_reviews = [review for review in reviews if is_english(review['review_text'])]

            non_empty_reviews = [review for review in english_reviews if review.get('review_text') and review['review_text'].strip()]

            # Cache the fetched reviews
            cache_key = f"reviews:{place_id}"
            redis_client.setex(cache_key, 3600, json.dumps(non_empty_reviews))  # Cache for 1 hour
            logger.info(f"Cached reviews for place_id: {place_id}")

            return non_empty_reviews
        return []
    except Exception as e:
        logger.error(f"Error fetching reviews from API: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


def store_restaurant(place_id: str, name: str, address: str):
    try:
        # Check if the restaurant already exists
        existing_restaurant = supabase_service.supabase.table("restaurants")\
            .select("*")\
            .eq("place_id", place_id)\
            .execute()

        if not existing_restaurant.data:
            # Insert the new restaurant if it doesn't exist
            data = {
                "place_id": place_id,
                "name": name,
                "address": address,
                "source": "outscraper_api",  # Ensure this field is correctly set
                "created_at": datetime.now(timezone.utc).isoformat()
            }
            logger.info(f"Data to be inserted: {data}")  # Log the data
            response = supabase_service.supabase.table("restaurants").insert(data).execute()
            logging.info(f"Restaurant stored successfully: {name}")
        else:
            logging.info(f"Restaurant already exists: {name}")
    except Exception as e:
        logger.error(f"Failed to store restaurant: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

def get_stored_reviews(place_id: str):
    # Define your freshness criteria (e.g., 1 week)
    freshness_limit = timedelta(weeks=1)
    now = datetime.now(timezone.utc)  # Ensure `now` is timezone-aware

    # Query the Supabase database for reviews related to place_id
    response = supabase_service.supabase.table("reviews")\
        .select("*")\
        .eq("place_id", place_id)\
        .order("created_at", desc=True)\
        .limit(30)\
        .execute()
    reviews = response.data

    if reviews:
        # Convert `created_at` to an offset-aware datetime
        latest_review = max(reviews, key=lambda r: datetime.fromisoformat(r['created_at'].replace('Z', '+00:00')).replace(tzinfo=timezone.utc))
        review_age = now - datetime.fromisoformat(latest_review['created_at'].replace('Z', '+00:00')).replace(tzinfo=timezone.utc)

        if review_age < freshness_limit:
            logger.info(f"Found recent reviews in the database for place_id: {place_id}")

            # Cache the fetched reviews from the database
            cache_key = f"reviews:{place_id}"
            redis_client.setex(cache_key, 3600, json.dumps(reviews))  # Cache for 1 hour
            logger.info(f"Cached reviews from database for place_id: {place_id}")

            return reviews
    
    logger.info(f"No recent reviews found in the database for place_id: {place_id}")
    return None

class ReviewQueryParams(BaseModel):
    place_id: str = Field(..., alias="place_id", pattern=r"^[A-Za-z0-9_\-]+$")
    name: str = Field(..., alias="displayName", min_length=1, max_length=100)
    address: str = Field(..., alias="formattedAddress", min_length=5, max_length=255)

@router.get("/reviews")
def get_reviews(
    query_params: ReviewQueryParams = Depends(),
    limiter: Callable[[Request], None] = Depends(rate_limiter(redis_client, rate=1.0, capacity=10))
):
    place_id = query_params.place_id
    name = query_params.name
    address = query_params.address
    
    logger.info(f"Received place_id: {place_id}")
    logger.info(f"Received displayName: {name}")
    logger.info(f"Received formattedAddress: {address}")
    
    try:
        # Step 1: Check the Redis cache first
        cached_reviews = check_cache(place_id)
        if cached_reviews:
            average_sentiment = analyze_sentiments(cached_reviews)
            return {"average_sentiment": average_sentiment, "reviews": cached_reviews, "source": "cache"}

        # Step 2: If not found in Redis, check the database
        stored_reviews = get_stored_reviews(place_id)
        if stored_reviews:
            average_sentiment = analyze_sentiments(stored_reviews)
            return {"average_sentiment": average_sentiment, "reviews": stored_reviews, "source": "database"}

        # Step 3: If not found in Redis or database, fetch from Outscraper API
        reviews = fetch_reviews_from_api(place_id)
        
        # Store the restaurant details before storing reviews
        store_restaurant(place_id, name, address)

        # Store fetched reviews in the database without sentiment
        for review in reviews:
            supabase_service.store_review(place_id, review['review_text'])

        average_sentiment = analyze_sentiments(reviews)
        return {"average_sentiment": average_sentiment, "reviews": reviews, "source": "api"}
    except HTTPException as e:
        raise e
    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
