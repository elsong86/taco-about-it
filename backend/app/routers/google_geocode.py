from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import requests
import os
from dotenv import load_dotenv

load_dotenv()

api_key = os.getenv("GOOGLE_API_KEY")

router = APIRouter()

class AddressRequest(BaseModel):
    address: str

@router.post("/geocode")
def get_geocode(request: AddressRequest):
    geocode_url = f"https://maps.googleapis.com/maps/api/geocode/json?address={requests.utils.quote(request.address)}&key={api_key}"

    try:
        response = requests.get(geocode_url)
        response.raise_for_status()
        data = response.json()

        if data["status"] != "OK":
            raise HTTPException(status_code=400, detail="Error geocoding address")

        location = data["results"][0]["geometry"]["location"]
        return {"latitude": location["lat"], "longitude": location["lng"]}
    except requests.RequestException as e:
        raise HTTPException(status_code=500, detail=str(e))
