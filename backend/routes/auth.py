from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, EmailStr
from passlib.hash import bcrypt
from .. import db

router = APIRouter(tags=["auth"])


class RegisterRequest(BaseModel):
    email: EmailStr
    password: str


class LoginStep1Request(BaseModel):
    email: EmailStr
    password: str


class VerifyOtpRequest(BaseModel):
    email: EmailStr
    code: str


class ResendOtpRequest(BaseModel):
    email: EmailStr


@router.post("/register")
def register(payload: RegisterRequest):
    existing = db.get_user_by_email(payload.email)
    if existing:
        raise HTTPException(status_code=400, detail="El usuario ya existe")
    password_hash = bcrypt.hash(payload.password)
    user_id = db.create_user(payload.email, password_hash)
    return {"message": "Usuario registrado", "user_id": user_id}


@router.post("/login-step1")
def login_step1(payload: LoginStep1Request):
    user = db.get_user_by_email(payload.email)
    if not user:
        raise HTTPException(status_code=401, detail="Credenciales inválidas")
    password_hash = user.get("password_hash")
    if not password_hash:
        # Usuario sin hash almacenado: tratar como credenciales inválidas
        raise HTTPException(status_code=401, detail="Credenciales inválidas")
    try:
        ok = bcrypt.verify(payload.password, password_hash)
    except Exception:
        # Cualquier error de verificación se trata como credenciales inválidas
        ok = False
    if not ok:
        raise HTTPException(status_code=401, detail="Credenciales inválidas")
    # En un caso real, generar y enviar OTP (email/SMS) y persistirlo
    # Aquí simulamos que se envió correctamente
    return {"message": "OTP enviado"}


@router.post("/resend-otp")
def resend_otp(payload: ResendOtpRequest):
    user = db.get_user_by_email(payload.email)
    if not user:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    # En un caso real, regenerar y enviar OTP y persistirlo
    return {"message": "OTP reenviado"}


@router.post("/verify-otp")
def verify_otp(payload: VerifyOtpRequest):
    # Simulación: aceptar cualquier código para pruebas
    # En producción, validar contra OTP almacenado con caducidad
    return {"message": "OTP verificado", "token": "fake-jwt-token"}
