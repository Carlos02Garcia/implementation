from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from passlib.context import CryptContext
from db import get_user_by_username, create_user

app = FastAPI(title='MiApp Auth')

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


class RegisterRequest(BaseModel):
    username: str
    password: str


class LoginRequest(BaseModel):
    username: str
    password: str


@app.post('/register')
def register(payload: RegisterRequest):
    existing = get_user_by_username(payload.username)
    if existing:
        raise HTTPException(status_code=400, detail='Usuario ya existe')
    hashed = pwd_context.hash(payload.password)
    user_id = create_user(payload.username, hashed)
    return {'id': user_id, 'username': payload.username}


@app.post('/login')
def login(payload: LoginRequest):
    user = get_user_by_username(payload.username)
    if not user:
        raise HTTPException(status_code=401, detail='Credenciales inválidas')
    if not pwd_context.verify(payload.password, user['password_hash']):
        raise HTTPException(status_code=401, detail='Credenciales inválidas')
    return {'id': user['id'], 'username': user['username'], 'message': 'Login ok'}
