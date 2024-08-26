# auth.py

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from ..services.supabase_service import sign_up, sign_in, sign_out, get_user
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

router = APIRouter()

class AuthRequest(BaseModel):
    email: str
    password: str

@router.post("/signup")
async def signup(auth_request: AuthRequest):
    try:
        logger.info(f"Attempting to sign up user: {auth_request.email}")
        response = sign_up(auth_request.email, auth_request.password)
        logger.info("Sign up successful")
        return {"message": "User signed up successfully", "data": response}
    except Exception as e:
        logger.error(f"Sign up failed: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/signin")
async def signin(auth_request: AuthRequest):
    try:
        logger.info(f"Attempting to sign in user: {auth_request.email}")
        response = sign_in(auth_request.email, auth_request.password)
        logger.info("Sign in successful")
        return {"message": "User signed in successfully", "data": response}
    except Exception as e:
        logger.error(f"Sign in failed: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/signout")
async def signout():
    try:
        logger.info("Attempting to sign out")
        response = sign_out()
        logger.info("Sign out successful")
        return {"message": "User signed out successfully", "data": response}
    except Exception as e:
        logger.error(f"Sign out failed: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/user")
async def get_current_user():
    try:
        logger.info("Attempting to retrieve current user")
        response = get_user()
        logger.info("User retrieved successfully")
        return {"message": "User retrieved successfully", "data": response}
    except Exception as e:
        logger.error(f"Get user failed: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
