from fastapi import APIRouter, HTTPException, Request, Depends
from app.services.session_service import SessionService
import logging

router = APIRouter()
logger = logging.getLogger(__name__)

@router.post("/create-session")
async def create_session(
    request: Request, 
    session_service: SessionService = Depends()
):
    # Extract app secret from headers
    app_secret = request.headers.get("X-App-Secret")
    
    # Validate app secret
    if not app_secret or not session_service.validate_app_secret(app_secret):
        logger.warning("Invalid app secret provided")
        raise HTTPException(status_code=403, detail="Invalid app secret")
    
    try:
        # Create a new session
        session_data = await session_service.create_anonymous_session()
        return session_data
    except Exception as e:
        logger.error(f"Error creating session: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to create session")