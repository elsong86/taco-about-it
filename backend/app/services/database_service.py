import logging
import jwt  # For JWT creation
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.exc import SQLAlchemyError
from app.models.tables import UserTable, ReviewTable  # Assuming you have these models
from utils.database import get_database_client
from passlib.context import CryptContext
from fastapi import Depends
from datetime import datetime, timedelta, timezone

logging.basicConfig(level=logging.INFO)

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Secret key for JWT (you should store this in an environment variable)
SECRET_KEY = "your_secret_key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60

class DatabaseService:
    def __init__(self, db: AsyncSession = Depends(get_database_client)):
        self.db = db

    # Password hashing utility
    def hash_password(self, password: str) -> str:
        return pwd_context.hash(password)

    # Validate email and password format
    def validate_credentials(self, email, password):
        if '@' not in email or len(password) < 8:
            logging.error("Invalid credentials provided.")
            return False
        return True

    # Sign up method (registering a new user)
    async def sign_up(self, email, password):
        if not self.validate_credentials(email, password):
            return {"error": "Invalid email or password format"}

        hashed_password = self.hash_password(password)

        new_user = UserTable(email=email, hashed_password=hashed_password)
        
        try:
            self.db.add(new_user)
            await self.db.commit()
            logging.info(f"User signed up successfully: {email}")
            return {"message": "User created successfully"}
        except SQLAlchemyError as e:
            logging.error(f"Signup failed for {email}: {str(e)}")
            return {"error": "Error during signup"}

    # Sign in method (user login)
    async def sign_in(self, email, password):
        if not self.validate_credentials(email, password):
            return {"error": "Invalid email or password format"}

        try:
            # Fetch user by email
            result = await self.db.execute(select(UserTable).where(UserTable.email == email))
            user = result.scalar_one_or_none()

            if user and pwd_context.verify(password, user.hashed_password):
                logging.info(f"User signed in successfully: {email}")
                
                # Generate a JWT token for the user
                access_token = self.create_access_token(data={"sub": str(user.id)})
                
                return {
                    "message": "Login successful",
                    "access_token": access_token,
                    "user_id": user.id
                }
            else:
                logging.error(f"Sign in failed for {email}: Invalid credentials")
                return {"error": "Invalid email or password"}

        except SQLAlchemyError as e:
            logging.error(f"Sign in failed for {email}: {str(e)}")
            return {"error": "Error during sign in"}

    # Create a JWT token
    def create_access_token(data: dict, expires_delta: timedelta = None):
        to_encode = data.copy()
        expire = datetime.now(timezone.utc) + (expires_delta if expires_delta else timedelta(minutes=15))
        to_encode.update({"exp": expire})
        encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
        return encoded_jwt

    # Store a review in the PostgreSQL database
    async def store_review(self, place_id: str, review_text: str):
        new_review = ReviewTable(place_id=place_id, review_text=review_text, source="outscraper_api")

        try:
            self.db.add(new_review)
            await self.db.commit()
            logging.info(f"Review stored successfully: {review_text}")
            return {"message": "Review stored successfully"}
        except SQLAlchemyError as e:
            logging.error(f"Failed to store review: {str(e)}")
            return {"error": "Error storing review"}

    # Fetch user profile
    async def fetch_user(self, user_id: str):
        try:
            logging.info(f"Fetching user with ID: {user_id}")

            # Fetch the user by ID from the database
            result = await self.db.execute(select(UserTable).where(UserTable.id == user_id))
            user = result.scalar_one_or_none()

            if user:
                logging.info(f"User fetched successfully: {user_id}")
                return {"user": {"id": user.id, "email": user.email, "last_sign_in": user.last_sign_in}}
            else:
                logging.error("User not found")
                return {"error": "User not found"}

        except SQLAlchemyError as e:
            logging.error(f"Failed to fetch user: {str(e)}")
            return {"error": "Error fetching user"}
