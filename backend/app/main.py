from contextlib import asynccontextmanager
from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import sessionmaker
from utils.database import get_database_client, test_connection
from app.models.tables import Base
from app.routers import google_places, google_geocode, outscraper_reviews, auth, profile

# Global variables for engine and session factory
engine = None
SessionLocal = None

@asynccontextmanager
async def lifespan(app: FastAPI):
    global engine, SessionLocal

    # Startup logic: Create the database engine and session factory
    engine = get_database_client()
    SessionLocal = sessionmaker(bind=engine, class_=AsyncSession, expire_on_commit=False)

    # Optionally, create the database tables on startup
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    # Test the connection (optional)
    await test_connection(engine)

    # Yield control to the application
    yield

    # Shutdown logic: Dispose of the database engine
    await engine.dispose()

# Initialize the FastAPI app with the lifespan context manager
app = FastAPI(lifespan=lifespan)

# CORS configuration
origins = [
    "http://localhost:3000",
    "http://frontend:3000"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include your routers
app.include_router(google_places.router)
app.include_router(google_geocode.router)
app.include_router(outscraper_reviews.router)
app.include_router(auth.router)
app.include_router(profile.router)

# Dependency for getting a database session
async def get_db():
    async with SessionLocal() as session:
        yield session

# Run the app with Uvicorn
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
