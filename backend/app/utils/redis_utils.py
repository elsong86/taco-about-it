import os
import redis
from dotenv import load_dotenv
from urllib.parse import urlparse

# Load environment variables from the .env file
load_dotenv()

# Get Redis connection details from the environment
redis_url = os.getenv("REDIS_HOST", "redis")  # Defaults to "redis" for local development

# Parse the Redis URL if it's in rediss:// format
if redis_url.startswith("rediss://"):
    parsed_url = urlparse(redis_url)
    redis_host = parsed_url.hostname
    redis_port = parsed_url.port or 6379  # Defaults to 6379 if not specified
    redis_password = parsed_url.password
    use_ssl = True
else:
    redis_host = redis_url
    redis_port = 6379
    redis_password = None
    use_ssl = False

# Initialize the Redis client
redis_client = redis.Redis(
    host=redis_host,
    port=redis_port,
    password=redis_password,
    db=0,
    decode_responses=True,
    ssl=use_ssl
)
