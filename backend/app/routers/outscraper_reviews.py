from fastapi import APIRouter, HTTPException, Query
from outscraper import ApiClient
from textblob import TextBlob
import os
from dotenv import load_dotenv
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Load environment variables from .env file
load_dotenv()

# Initialize the API client with the API key from environment variable
api_key = os.getenv("OUTSCRAPER_API_KEY")
client = ApiClient(api_key)

# Initialize the FastAPI router
router = APIRouter()

def fetch_reviews(place_id: str):
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
            # Filter out reviews with empty text
            non_empty_reviews = [review for review in reviews if review.get('review_text') and review['review_text'].strip()]
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
def get_reviews(place_id: str = Query(..., description="The Place ID of the business")):
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
