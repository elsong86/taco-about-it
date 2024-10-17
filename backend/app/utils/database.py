from sqlalchemy import text
from sqlalchemy.ext.asyncio import create_async_engine
from dotenv import load_dotenv
import os
import logging

def get_database_client():
    # Load environment variables from the .env file
    load_dotenv()

    # Fetch DATABASE_URL from environment
    url: str = os.getenv("DATABASE_URL")

    if not url:
        logging.error("DATABASE_URL not set in environment variables.")
        raise ValueError("DATABASE_URL must be set")

    # Create async engine with some optional configuration
    engine = create_async_engine(
        url,
        echo=True,  # Enable SQL query logging (useful for debugging)
        pool_size=5,  # Set pool size
        max_overflow=10  # Allow additional overflow connections
    )
    
    logging.info("Database client created successfully.")
    return engine

# Optional: Test database connection after creating engine
async def test_connection(engine):
    try:
        async with engine.connect() as conn:
            result = await conn.execute(text("SELECT 1"))
            logging.info("Database connection test passed.")
    except Exception as e:
        logging.error(f"Database connection failed: {e}")
