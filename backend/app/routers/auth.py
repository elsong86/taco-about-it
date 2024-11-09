from fastapi import APIRouter, HTTPException, Response, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.models.user import UserCreate
from app.services.database_service import DatabaseService
from app.utils.database import get_database_client
import logging

# Constants for JWT expiration (1 hour in this case)
ACCESS_TOKEN_EXPIRE_MINUTES = 60

router = APIRouter()

# Dependency to get the database session
async def get_database_service(db: AsyncSession = Depends(get_database_client)):
    return DatabaseService(db)

@router.post("/signup", response_model=dict)
async def signup(user_details: UserCreate, db_service: DatabaseService = Depends(get_database_service)):
    result = await db_service.sign_up(user_details.email, user_details.password)
    if 'error' in result:
        raise HTTPException(status_code=400, detail=result['error'])
    return {"message": "Signup successful", "user": result}

@router.post("/signin", response_model=dict)
async def signin(user_details: UserCreate, response: Response, db_service: DatabaseService = Depends(get_database_service)):
    result = await db_service.sign_in(user_details.email, user_details.password)
    if 'error' in result:
        raise HTTPException(status_code=401, detail=result['error'])
    
    jwt_token = result["access_token"]
    response.set_cookie(
        key="access_token", 
        value=jwt_token, 
        httponly=True, 
        secure=True,        
        samesite="None",     
        max_age=60 * 60     
    )
    
    # Prevent caching
    response.headers["Cache-Control"] = "no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"

    return {"message": "Signin successful"}

@router.post("/logout")
async def logout(response: Response):
    # Clear the cookie by setting an expired max_age
    response.delete_cookie(key="access_token", path="/", httponly=True)
    return {"message": "Logged out successfully"}