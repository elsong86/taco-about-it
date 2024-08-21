from fastapi import APIRouter, HTTPException, Query, Depends, Request
from outscraper import ApiClient
from textblob import TextBlob
import os
from dotenv import load_dotenv
import logging
import json
from ..utils.rate_limiter import rate_limiter
from ..utils.redis_utils import redis_client
from typing import Callable  # Import Callable

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

load_dotenv()

api_key = os.getenv("OUTSCRAPER_API_KEY")
client = ApiClient(api_key)

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

@router.get("/reviews")
def get_reviews(place_id: str = Query(..., description="The Place ID of the business"), 
                limiter: Callable[[Request], None] = Depends(rate_limiter(redis_client, rate=1.0, capacity=10))
):

    logger.info(f"Received request for place_id: {place_id}")
    try:
        reviews = fetch_reviews(place_id)
        logger.info(f"Fetched and filtered reviews: {reviews}")
        average_sentiment = analyze_sentiments(reviews)
        logger.info(f"Calculated average sentiment: {average_sentiment}")
        return {"average_sentiment": average_sentiment, "reviews": reviews}
    except HTTPException as e:
        raise e
    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
