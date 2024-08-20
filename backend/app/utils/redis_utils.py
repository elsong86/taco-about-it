import os
import redis

REDIS_HOST = os.getenv('REDIS_HOST', 'localhost')  # Default to 'localhost' if not set
redis_client = redis.Redis(host=REDIS_HOST, port=6379, db=0, decode_responses=True)
