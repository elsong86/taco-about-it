from pydantic import BaseModel, EmailStr, UUID4

class UserBase(BaseModel):
    email: EmailStr
    class Config:
        form_attributes = True

class UserCreate(UserBase):
    password: str

class User(UserBase):
    id: UUID4