from fastapi import APIRouter, HTTPException
from passlib.context import CryptContext
from datetime import datetime, timedelta

from backend.db import get_user_by_email, create_user
from models.schemas import RegisterRequest, LoginRequest, VerifyOtpRequest, ResendOtpRequest
from backend.services.otp_service import generate_otp, save_otp, validate_otp
from backend.email_service import send_otp_email
import os
from backend.services.jwt_services import create_access_token

router = APIRouter()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

@router.post("/register")
def register(payload: RegisterRequest):
    if get_user_by_email(payload.email):
        raise HTTPException(400, "Usuario ya existe")

    hashed = pwd_context.hash(payload.password)
    user_id = create_user(payload.email, hashed)
    return {"id": user_id, "email": payload.email}

@router.post("/login-step1")
def login_step1(payload: LoginRequest):
    user = get_user_by_email(payload.email)
    if not user or not pwd_context.verify(payload.password, user["password_hash"]):
        raise HTTPException(401, "Credenciales inválidas")

    code = generate_otp()
    save_otp(payload.email, code, datetime.now() + timedelta(minutes=5))
    # Enviar OTP solo si está habilitado y configurado; no bloquear ante fallos
    email_enabled = os.getenv("EMAIL_ENABLED", "false").lower() == "true"
    if email_enabled:
        send_otp_email(payload.email, code)

    return {"message": "OTP enviado"}

@router.post("/verify-otp")
def verify_otp(payload: VerifyOtpRequest):
    otp = validate_otp(payload.email, payload.code)
    if not otp:
        raise HTTPException(401, "OTP inválido")

    token = create_access_token({"sub": payload.email})
    return {"access_token": token, "token_type": "bearer"}


@router.post("/resend-otp")
def resend_otp(payload: ResendOtpRequest):
    user = get_user_by_email(payload.email)
    if not user:
        raise HTTPException(404, "Usuario no encontrado")

    code = generate_otp()
    save_otp(payload.email, code, datetime.now() + timedelta(minutes=5))

    email_enabled = os.getenv("EMAIL_ENABLED", "false").lower() == "true"
    if email_enabled:
        send_otp_email(payload.email, code)

    return {"message": "OTP reenviado"}
