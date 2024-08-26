# supabase_service.py

import os
from dotenv import load_dotenv
from supabase import create_client, Client
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Load environment variables from .env file
load_dotenv()

# Get Supabase credentials from .env
url: str = os.getenv("SUPABASE_URL")
key: str = os.getenv("SUPABASE_KEY")

# Ensure the variables are set
if not url or not key:
    raise ValueError("SUPABASE_URL and SUPABASE_KEY must be set in .env file")

# Initialize the Supabase client
supabase: Client = create_client(url, key)

def get_supabase_client() -> Client:
    return supabase

# Authentication-related functions
def sign_up(email: str, password: str):
    client = get_supabase_client()
    try:
        logger.info(f"Attempting to sign up user: {email}")
        response = client.auth.sign_up({
            "email": email,
            "password": password
        })
        logger.info("Sign up successful")
        return response
    except Exception as e:
        logger.error(f"Sign up failed: {str(e)}")
        raise

def sign_in(email: str, password: str):
    client = get_supabase_client()
    try:
        logger.info(f"Attempting to sign in user: {email}")
        response = client.auth.sign_in_with_password({
            "email": email,
            "password": password
        })
        return response
    except Exception as e:
        logger.error(f"Sign in failed: {str(e)}")
        raise

def sign_out():
    client = get_supabase_client()
    try:
        logger.info("Attempting to sign out")
        response = client.auth.sign_out()
        logger.info("Sign out successful")
        return response
    except Exception as e:
        logger.error(f"Sign out failed: {str(e)}")
        raise

def get_user():
    client = get_supabase_client()
    try:
        logger.info("Attempting to retrieve user")
        response = client.auth.get_user()
        return response
    except Exception as e:
        logger.error(f"Get user failed: {str(e)}")
        raise
