import unittest
from unittest.mock import patch, MagicMock
from fastapi.testclient import TestClient
from app.main import app  # Import the FastAPI app
from app.routers.outscraper_reviews import get_reviews  # Import the function
from textblob import TextBlob  # Make sure TextBlob is imported

class TestGetReviews(unittest.TestCase):

    @patch('app.routers.outscraper_reviews.client.google_maps_reviews')
    @patch('app.routers.outscraper_reviews.redis_client')
    def test_get_reviews_endpoint(self, mock_redis_client, mock_google_maps_reviews):
        # Mock the Redis get response
        mock_redis_client.get.return_value = None  # Simulate a cache miss

        # Mock the API response from Outscraper
        mock_google_maps_reviews.return_value = [
            {
                "reviews_data": [
                    {"review_text": "Great place! Loved the tacos."},
                    {"review_text": "Not too bad, but service was slow."},
                    {"review_text": "Terrible experience, never coming back."},
                ]
            }
        ]

        # Mock the Redis setex method to do nothing
        mock_redis_client.setex = MagicMock()

        # Initialize the FastAPI TestClient
        client = TestClient(app)

        # Perform a GET request to the /reviews endpoint with a dummy place_id
        response = client.get("/reviews?place_id=dummy_place_id")

        # Assert the response is OK
        self.assertEqual(response.status_code, 200)

        # Parse the JSON response
        data = response.json()

        # Assert the average sentiment is calculated correctly
        self.assertIn("average_sentiment", data)
        self.assertIn("reviews", data)

        # Check the values
        expected_reviews = [
            {"review_text": "Great place! Loved the tacos."},
            {"review_text": "Not too bad, but service was slow."},
            {"review_text": "Terrible experience, never coming back."},
        ]
        expected_average_sentiment = (
            sum([TextBlob(review['review_text']).sentiment.polarity for review in expected_reviews])
            / len(expected_reviews)
        )

        self.assertEqual(data["reviews"], expected_reviews)
        self.assertAlmostEqual(data["average_sentiment"], expected_average_sentiment, places=5)

class TestRateLimiter(unittest.TestCase):

    @patch('app.routers.outscraper_reviews.client.google_maps_reviews')
    @patch('app.routers.outscraper_reviews.redis_client')
    def test_rate_limiter(self, mock_redis_client, mock_google_maps_reviews):
        # Mock the Redis get response to simulate cache miss
        mock_redis_client.get.return_value = None

        # Mock the API response from Outscraper
        mock_google_maps_reviews.return_value = [
            {
                "reviews_data": [
                    {"review_text": "Great place! Loved the tacos."},
                    {"review_text": "Not too bad, but service was slow."},
                    {"review_text": "Terrible experience, never coming back."},
                ]
            }
        ]

        # Mock the Redis setex method to do nothing
        mock_redis_client.setex = MagicMock()

        # Initialize the FastAPI TestClient
        client = TestClient(app)

        # First request should be allowed
        response = client.get("/reviews?place_id=dummy_place_id")
        self.assertEqual(response.status_code, 200)

        # Simulate rapid repeated requests
        for _ in range(10):
            response = client.get("/reviews?place_id=dummy_place_id")

        # Last request should be denied due to rate limiting
        self.assertEqual(response.status_code, 429)
        self.assertEqual(response.json()["detail"], "Too Many Requests")

if __name__ == "__main__":
    unittest.main()
