from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, EmailStr
from passlib.hash import bcrypt
import db
from services.email_service import send_otp_email   # <--- CAMBIA ESTO
import random
import datetime
import logging
logger = logging.getLogger(__name__)
router = APIRouter(tags=["auth"])

# Modelos de solicitud
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

# Endpoint de registro
@router.post("/register")
def register(data: RegisterRequest):
    # Verificar si el usuario ya existe
    existing = db.get_user_by_email(data.email)
    if existing:
        raise HTTPException(status_code=400, detail="El usuario ya existe")
    
    # Hashear la contraseña
    hashed = bcrypt.hash(data.password)
    # Crear usuario
    user_id = db.create_user(data.email, hashed)
    return {"message": "Usuario registrado correctamente", "user_id": user_id}

#from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, EmailStr
from passlib.hash import bcrypt
import db
from services.email_service import send_otp_email  # <--- CAMBIO IMPORTANTE
import random
import datetime
import logging

logger = logging.getLogger(__name__)
router = APIRouter(tags=["auth"])

# Modelos de solicitud
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

# Endpoint de registro
@router.post("/register")
def register(data: RegisterRequest):
    # Verificar si el usuario ya existe
    existing = db.get_user_by_email(data.email)
    if existing:
        raise HTTPException(status_code=400, detail="El usuario ya existe")
    
    # Hashear la contraseña
    hashed = bcrypt.hash(data.password)
    # Crear usuario
    user_id = db.create_user(data.email, hashed)
    return {"message": "Usuario registrado correctamente", "user_id": user_id}

# Paso 1 del login (solicitar OTP)
@router.post("/login-step1")
def login_step1(data: LoginStep1Request):
    user = db.get_user_by_email(data.email)
    if not user:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    
    # Verificar contraseña (si la tienes hasheada)
    # if not bcrypt.verify(data.password, user["password_hash"]):
    #     raise HTTPException(status_code=401, detail="Contraseña incorrecta")
    
    # Generar código OTP de 6 dígitos
    code = f"{random.randint(100000, 999999)}"
    
    # Guardar OTP en la base de datos (tabla otp_codes)
    conn = db.get_db()
    cur = conn.cursor()
    expires_at = datetime.datetime.now() + datetime.timedelta(minutes=5)
    cur.execute(
        "INSERT INTO otp_codes (email, code, expires_at) VALUES (%s, %s, %s)",
        (data.email, code, expires_at)
    )
    conn.commit()
    cur.close()
    conn.close()
    
    # Enviar el OTP por correo (AHORA usa send_otp_email directamente)
    success = send_otp_email(data.email, code)   # <--- CAMBIO AQUÍ
    if not success:
        logger.error(f"❌ Falló el envío de OTP a {data.email}")
        # Podrías devolver un 500 o seguir adelante, depende de tu lógica
        # raise HTTPException(status_code=500, detail="Error al enviar el código")
    
    return {"message": "Código OTP enviado a tu correo"}

# Verificación del OTP
@router.post("/verify-otp")
def verify_otp(data: VerifyOtpRequest):
    conn = db.get_db()
    cur = conn.cursor(dictionary=True)
    cur.execute(
        "SELECT * FROM otp_codes WHERE email = %s AND code = %s AND used = 0 AND expires_at > NOW()",
        (data.email, data.code)
    )
    row = cur.fetchone()
    if not row:
        cur.close()
        conn.close()
        raise HTTPException(status_code=400, detail="Código inválido o expirado")
    
    # Marcar como usado
    cur.execute("UPDATE otp_codes SET used = 1 WHERE id = %s", (row["id"],))
    conn.commit()
    cur.close()
    conn.close()
    
    return {"message": "OTP verificado correctamente"}

# Reenvío de OTP
@router.post("/resend-otp")
def resend_otp(data: ResendOtpRequest):
    """
    Reenvía un nuevo código OTP al correo del usuario.
    """
    # 1. Verificar que el usuario existe
    user = db.get_user_by_email(data.email)
    if not user:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    
    # 2. Generar un nuevo código OTP de 6 dígitos
    new_code = f"{random.randint(100000, 999999)}"
    
    # 3. Guardar el nuevo código en la base de datos (tabla otp_codes)
    conn = db.get_db()
    cur = conn.cursor()
    expires_at = datetime.datetime.now() + datetime.timedelta(minutes=5)
    
    # Marcar códigos anteriores como expirados (opcional)
    # cur.execute("UPDATE otp_codes SET used = 1 WHERE email = %s AND used = 0", (data.email,))
    
    # Insertar el nuevo código
    cur.execute(
        "INSERT INTO otp_codes (email, code, expires_at, used) VALUES (%s, %s, %s, 0)",
        (data.email, new_code, expires_at)
    )
    conn.commit()
    cur.close()
    conn.close()
    
    # 4. Enviar el nuevo OTP por correo (AHORA usa send_otp_email directamente)
    success = send_otp_email(data.email, new_code)   # <--- CAMBIO AQUÍ
    if not success:
        logger.error(f"❌ Falló el reenvío de OTP a {data.email}")
        # Puedes decidir si devolver error o solo un warning
        # raise HTTPException(status_code=500, detail="Error al reenviar el código")
    
    return {"message": "Nuevo código OTP enviado a tu correo"}