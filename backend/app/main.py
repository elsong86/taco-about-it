from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import google_places, google_geocode, outscraper_reviews, auth, profile


app = FastAPI()

origins = [
    "http://localhost:3000",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(google_places.router)
app.include_router(google_geocode.router)
app.include_router(outscraper_reviews.router)
app.include_router(auth.router)
app.include_router(profile.router)

# Run the app
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
