import jwt
from fastapi import HTTPException
from datetime import datetime, timezone

# Secret key for JWT (make sure this is stored securely, e.g., in environment variables)
SECRET_KEY = "your_secret_key"
ALGORITHM = "HS256"

def decode_jwt(token: str):
    try:
        # Decode the JWT token
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])

        # Ensure the token has not expired
        if payload.get("exp") < datetime.now(timezone.utc).timestamp():
            raise HTTPException(status_code=401, detail="Token has expired")

        return payload
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token has expired")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Invalid token")
