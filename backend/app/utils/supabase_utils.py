import os
from supabase import create_client, Client
from dotenv import load_dotenv
import logging

def get_supabase_client() -> Client:
    # Load environment variables
    load_dotenv()

    # Retrieve URL and Key from environment variables
    url: str = os.getenv("SUPABASE_URL")
    key: str = os.getenv("SUPABASE_KEY")

    # Check if the URL and Key are loaded correctly
    if not url or not key:
        logging.error("SUPABASE_URL or SUPABASE_KEY not set in environment variables.")
        raise ValueError("SUPABASE_URL and SUPABASE_KEY must be set")

    # Log the retrieved values (be careful with logging sensitive data)
    logging.info(f"SUPABASE_URL: {url}")
    # Avoid logging the key as it's sensitive information

    # Create and return the Supabase client
    supabase: Client = create_client(url, key)
    logging.info("Supabase client created successfully.")
    return supabase
