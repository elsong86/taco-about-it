from fastapi import FastAPI

from .routers import google_places

app = FastAPI()

app.include_router(google_places.router)


# Run the app
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
