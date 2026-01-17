from typing import Optional
import mysql.connector
from mysql.connector import pooling
import os

from dotenv import load_dotenv

load_dotenv()

DB_CONFIG = {
    'host': os.getenv('DB_HOST', '127.0.0.1'),
    'port': int(os.getenv('DB_PORT', '3306')),
    'user': os.getenv('DB_USER', 'root'),
    'password': os.getenv('DB_PASSWORD', ''),
    'database': os.getenv('DB_NAME', 'miapp'),
}

pool = pooling.MySQLConnectionPool(pool_name="mypool", pool_size=5, **DB_CONFIG)

def get_conn():
    return pool.get_connection()

def get_user_by_username(username: str) -> Optional[dict]:
    conn = get_conn()
    try:
        cur = conn.cursor(dictionary=True)
        cur.execute('SELECT id, username, password_hash FROM users WHERE username = %s', (username,))
        row = cur.fetchone()
        return row
    finally:
        try:
            cur.close()
        except Exception:
            pass
        conn.close()

def create_user(username: str, password_hash: str) -> int:
    conn = get_conn()
    try:
        cur = conn.cursor()
        cur.execute('INSERT INTO users (username, password_hash) VALUES (%s, %s)', (username, password_hash))
        conn.commit()
        return cur.lastrowid
    finally:
        try:
            cur.close()
        except Exception:
            pass
        conn.close()
