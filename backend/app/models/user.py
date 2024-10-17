from pydantic import BaseModel, EmailStr, UUID4
from sqlmodel import SQLModel, Field
from typing import Optional
from uuid import uuid4
from datetime import datetime, timezone
from enum import Enum

# Enum for provider types (email, google, etc.)
class ProviderEnum(str, Enum):
    email = "email"
    google = "google"
    apple = "apple"
    # Add other providers as needed

# SQLModel to define the User table in the database
class UserTable(SQLModel, table=True):
    id: UUID4 = Field(default_factory=uuid4, primary_key=True)  # UUID primary key
    email: EmailStr = Field(index=True, unique=True)  # Indexed and unique email
    hashed_password: str  # Hashed password
    providers: ProviderEnum = Field(default=ProviderEnum.email)  # Signup method (email, google, etc.)
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))  # Use timezone-aware datetime
    last_sign_in: Optional[datetime] = None  # Set when user signs in


# Pydantic models for validation
class UserBase(BaseModel):
    email: EmailStr

    class Config:
        orm_mode = True  # Allows using SQLModel instances with Pydantic validation

class UserCreate(UserBase):
    password: str

class User(UserBase):
    id: UUID4
