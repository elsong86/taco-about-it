import os
import logging
from supabase import create_client, Client
from supabase.client import ClientOptions
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Retrieve URL and Key from environment variables
url: str = os.getenv("SUPABASE_URL")
key: str = os.getenv("SUPABASE_KEY")

# Set up logging
logging.basicConfig(level=logging.INFO)

class SupabaseService:
    def __init__(self, url, key):
        self.supabase = create_client(
            url, 
            key,
            options=ClientOptions(
                postgrest_client_timeout=10,
                storage_client_timeout=10,
                schema="public"
            )
        )

    def validate_credentials(self, email, password):
        if '@' not in email or len(password) < 8:
            logging.error("Invalid credentials provided.")
            return False
        return True

    def sign_up(self, email, password):
        if not self.validate_credentials(email, password):
            return {"error": "Invalid email or password format"}

        try:
            response = self.supabase.auth.sign_up({"email": email, "password": password})
            logging.info("User signed up successfully: %s", email)
            return response
        except Exception as e:
            logging.error("Signup failed for %s: %s", email, str(e))
            return {"error": str(e)}

    def sign_in(self, email, password):
        if not self.validate_credentials(email, password):
            return {"error": "Invalid email or password format"}

        try:
            response = self.supabase.auth.sign_in_with_password({"email": email, "password": password})
            logging.info("User signed in successfully: %s", email)
            return response
        except Exception as e:
            logging.error("Sign in failed for %s: %s", email, str(e))
            return {"error": str(e)}

    def store_review(self, place_id: str, review_text: str, sentiment: float = None):
        try:
            data = {
                "place_id": place_id,
                "review_text": review_text,
            }
            response = self.supabase.table("reviews").insert(data).execute()
            logging.info("Review stored successfully: %s", review_text)
            return response
        except Exception as e:
            logging.error("Failed to store review: %s", str(e))
            return {"error": str(e)}

