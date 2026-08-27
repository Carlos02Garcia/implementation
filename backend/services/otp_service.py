import random
from datetime import datetime
from backend.db import get_db

def generate_otp():
    return str(random.randint(100000, 999999))

def save_otp(email: str, code: str, expires):
    db = get_db()
    cur = db.cursor()
    cur.execute(
        "INSERT INTO otp_codes (email, code, expires_at, used) VALUES (%s,%s,%s,0)",
        (email, code, expires),
    )
    db.commit()
    cur.close()
    db.close()

def validate_otp(email: str, code: str):
    db = get_db()
    cur = db.cursor(dictionary=True)
    cur.execute("""
        SELECT * FROM otp_codes
        WHERE email=%s AND code=%s AND used=0 AND expires_at > NOW()
    """, (email, code))
    otp = cur.fetchone()

    if otp:
        cur.execute("UPDATE otp_codes SET used=1 WHERE id=%s", (otp["id"],))
        db.commit()

    cur.close()
    db.close()
    return otp
