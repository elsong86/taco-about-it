from sqlalchemy import Column, String, DateTime, Enum as SQLAlchemyEnum
from sqlalchemy.dialects.postgresql import UUID as PostgresUUID
from sqlalchemy.ext.declarative import declarative_base
from uuid import uuid4
from typing import Optional
from datetime import datetime, timezone
from enum import Enum

# Create the base for SQLAlchemy models
Base = declarative_base()

# Enum for provider types (email, google, etc.)
class ProviderEnum(str, Enum):
    email = "email"
    google = "google"
    apple = "apple"

# SQLAlchemy model for the User table
class UserTable(Base):
    __tablename__ = 'users'

    id = Column(PostgresUUID(as_uuid=True), primary_key=True, default=uuid4)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    providers = Column(SQLAlchemyEnum(ProviderEnum), default=ProviderEnum.email)
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    last_sign_in = Column(DateTime(timezone=True), nullable=True)
