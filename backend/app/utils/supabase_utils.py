import os
from supabase import create_client, Client
from dotenv import load_dotenv

def get_supabase_client() -> Client:
    # Load environment variables
    load_dotenv()

    # Retrieve URL and Key from environment variables
    url: str = os.getenv("SUPABASE_URL")
    key: str = os.getenv("SUPABASE_KEY")

    # Create and return the Supabase client
    supabase: Client = create_client(url, key)
    return supabase
