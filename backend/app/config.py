from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

class Settings:
    OUTSCRAPER_API_KEY: str = os.getenv("OUTSCRAPER_API_KEY")

settings = Settings()