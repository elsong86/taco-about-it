from fastapi import APIRouter, HTTPException, Depends
from ..models.user import UserCreate  
from ..services.supabase_service import SupabaseService
import os

supabase_service = SupabaseService(os.getenv("SUPABASE_URL"), os.getenv("SUPABASE_KEY"))

router = APIRouter()

@router.post("/signup", response_model=dict)
async def signup(user_details: UserCreate):
    result = supabase_service.sign_up(user_details.email, user_details.password)
    if 'error' in result:
        raise HTTPException(status_code=400, detail=result['error'])
    return {"message": "Signup successful", "user": result}

@router.post("/signin", response_model=dict)
async def signin(user_details: UserCreate):
    result = supabase_service.sign_in(user_details.email, user_details.password)
    if 'error' in result:
        raise HTTPException(status_code=401, detail=result['error'])
    return {"message": "Signin successful", "session": result}
