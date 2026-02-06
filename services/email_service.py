import os
import smtplib
from email.message import EmailMessage

def send_otp_email(to_email: str, code: str) -> bool:
    """Envía un OTP por correo. Si no hay configuración válida, no falla y devuelve False.

    Requiere variables de entorno:
      - EMAIL_ENABLED=true/false
      - EMAIL_HOST, EMAIL_PORT, EMAIL_USER, EMAIL_PASS, EMAIL_FROM
    """
    enabled = os.getenv("EMAIL_ENABLED", "false").lower() == "true"
    host = os.getenv("EMAIL_HOST", "smtp.gmail.com")
    port = int(os.getenv("EMAIL_PORT", "465"))
    user = os.getenv("EMAIL_USER")
    password = os.getenv("EMAIL_PASS")
    sender = os.getenv("EMAIL_FROM", user or "no-reply@example.com")

    if not enabled:
        # Envío deshabilitado para entorno de pruebas
        return False
    if not user or not password:
        # Configuración incompleta: no intentar enviar
        return False

    try:
        msg = EmailMessage()
        msg.set_content(f"Tu código de verificación es: {code}")
        msg["Subject"] = "Código de inicio de sesión"
        msg["From"] = sender
        msg["To"] = to_email

        with smtplib.SMTP_SSL(host, port) as smtp:
            smtp.login(user, password)
            smtp.send_message(msg)
        return True
    except Exception:
        # No propagamos errores de SMTP para no romper el flujo
        return False
