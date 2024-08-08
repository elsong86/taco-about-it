from fastapi import APIRouter, HTTPException, Query
from outscraper import ApiClient
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

@router.get("/reviews")
def get_reviews(place_id: str = Query(..., description="The Place ID of the business")):
    logger.info(f"Received request for place_id: {place_id}")
    try:
        logger.debug("Calling Outscraper API")
        results = client.google_maps_reviews(
            place_id, 
            reviews_limit=30, 
            language='en',
            fields="reviews_data.review_text",  
            sort="newest"
        )
        logger.info(f"Fetched reviews data: {results}")
        
        if results and isinstance(results, list) and len(results) > 0:
            reviews = results[0].get('reviews_data', [])
            logger.info(f"Extracted {len(reviews)} reviews")
            
            # Filter out reviews with empty text
            non_empty_reviews = [
                review for review in reviews 
                if review.get('review_text') and review['review_text'].strip()
            ]
            logger.info(f"Filtered to {len(non_empty_reviews)} non-empty reviews")
            
            return {"reviews": non_empty_reviews}
        else:
            logger.warning("No reviews found in the fetched data")
            return {"reviews": []}
    except Exception as e:
        logger.error(f"Error fetching reviews: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))