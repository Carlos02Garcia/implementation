import os
from pathlib import Path
import mysql.connector
from mysql.connector import pooling
from dotenv import load_dotenv

# Cargar .env solo si existe (para desarrollo local)
env_path = Path(__file__).resolve().parent / ".env"
if env_path.exists():
    load_dotenv(dotenv_path=env_path)

# Verificar que las variables necesarias estén presentes
required_vars = ["DB_HOST", "DB_USER", "DB_PASSWORD", "DB_NAME"]
missing = [v for v in required_vars if not os.getenv(v)]
if missing:
    raise EnvironmentError(f"Faltan variables de entorno: {', '.join(missing)}")

DB_CONFIG = {
    "host": os.getenv("DB_HOST"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "database": os.getenv("DB_NAME"),
    "port": int(os.getenv("DB_PORT", 3306)),
}

# Pool de conexiones reducido a 1 para no exceder el límite de Clever Cloud
pool = pooling.MySQLConnectionPool(pool_name="mypool", pool_size=1, **DB_CONFIG)

def get_db():
    return pool.get_connection()

def get_user_by_email(email: str):
    db = get_db()
    cur = db.cursor(dictionary=True)
    cur.execute("SELECT * FROM users WHERE email = %s", (email,))
    user = cur.fetchone()
    cur.close()
    db.close()
    return user

def create_user(email: str, password_hash: str):
    db = get_db()
    cur = db.cursor()
    cur.execute(
        "INSERT INTO users (email, password_hash) VALUES (%s, %s)",
        (email, password_hash),
    )
    db.commit()
    user_id = cur.lastrowid
    cur.close()
    db.close()
    return user_id