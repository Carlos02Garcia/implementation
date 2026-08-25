import os
from pathlib import Path
import mysql.connector
from mysql.connector import pooling
from dotenv import load_dotenv

#load_dotenv(dotenv_path=Path(__file__).resolve().parent / ".env")

DB_CONFIG = {
    "host": os.getenv("DB_HOST"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "database": os.getenv("DB_NAME"),
    "port": int(os.getenv("DB_PORT", 3306)),  # 3306 es un valor seguro por defecto
}

pool = pooling.MySQLConnectionPool(pool_name="mypool", pool_size=2, **DB_CONFIG)  # Reducido a 2

def get_db():
    return pool.get_connection()

def get_user_by_email(email: str):
    db = get_db()
    cur = db.cursor(dictionary=True)
    cur.execute("SELECT * FROM users WHERE email=%s", (email,))
    user = cur.fetchone()
    cur.close()
    db.close()
    return user

def create_user(email: str, password_hash: str):
    db = get_db()
    cur = db.cursor()
    cur.execute(
        "INSERT INTO users (email, password_hash) VALUES (%s,%s)",
        (email, password_hash),
    )
    db.commit()
    user_id = cur.lastrowid
    cur.close()
    db.close()
    return user_id
