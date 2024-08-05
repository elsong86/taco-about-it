from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import google_places

app = FastAPI()

# Define origins for development and production
development_origins = [
    "http://localhost:3000",  # Your frontend running on localhost
]

production_origins = [
    "https://your-production-domain.com",  # Replace with your actual domain
]

# Combine both lists or choose based on environment
origins = development_origins + production_origins

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=development_origins,  # Use the origins list defined above
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(google_places.router)

# Run the app
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
