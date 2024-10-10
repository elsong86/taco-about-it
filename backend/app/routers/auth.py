from fastapi import APIRouter, HTTPException, Response, Depends
from ..models.user import UserCreate  
from ..services.supabase_service import SupabaseService

supabase_service = SupabaseService()
router = APIRouter()

@router.post("/signup", response_model=dict)
async def signup(user_details: UserCreate):
    result = supabase_service.sign_up(user_details.email, user_details.password)
    if 'error' in result:
        raise HTTPException(status_code=400, detail=result['error'])
    return {"message": "Signup successful", "user": result}

@router.post("/signin", response_model=dict)
async def signin(user_details: UserCreate, response: Response):
    result = supabase_service.sign_in(user_details.email, user_details.password)
    if 'error' in result:
        raise HTTPException(status_code=401, detail=result['error'])
    
    # Extract the JWT token from the session
    jwt_token = result.session.access_token

    # Set the JWT token in an HTTP-only cookie
    response.set_cookie(
        key="access_token", 
        value=jwt_token, 
        httponly=True, 
        secure=True,        # Ensure HTTPS in production
        samesite="Lax",     # Adjust based on your CSRF strategy
        max_age=60*60        # 1 hour in seconds
    )

    return {"message": "Signin successful"}


