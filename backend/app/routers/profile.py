from fastapi import APIRouter, HTTPException, Header
from ..services.supabase_service import SupabaseService

router = APIRouter()
supabase_service = SupabaseService()  # Instantiate the SupabaseService

@router.get("/profile")
def get_profile(authorization: str = Header(None)):
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")

    jwt = authorization.split(" ")[1]

    try:
        # Use the SupabaseService's fetch_user method with the JWT
        user_response = supabase_service.fetch_user(jwt)

        # If there's an error in the response, return it
        if "error" in user_response:
            raise HTTPException(status_code=400, detail=user_response["error"])

        # Access the 'user' attribute of the 'user_response'
        user_data = user_response.user

        # Extract user ID and email from the 'user_data' object
        user_id = user_data.id
        email = user_data.email

        if not user_id or not email:
            raise HTTPException(status_code=404, detail="User ID or email not found")

        return {"user_id": user_id, "email": email}

    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to retrieve profile: {str(e)}")
