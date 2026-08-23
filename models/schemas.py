from pydantic import BaseModel, EmailStr

class RegisterRequest(BaseModel):
    email: EmailStr
    password: str

class LoginRequest(BaseModel):
    email: EmailStr
    password: str

class VerifyOtpRequest(BaseModel):
    email: EmailStr
    code: str


class ResendOtpRequest(BaseModel):
    email: EmailStr
