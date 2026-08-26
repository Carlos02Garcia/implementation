import os
import smtplib
from email.message import EmailMessage
import logging

logger = logging.getLogger(__name__)

def send_otp_email(to_email: str, code: str) -> bool:
    """
    Envía un OTP por correo usando Gmail.
    Variables necesarias: EMAIL_ENABLED, EMAIL_HOST, EMAIL_PORT,
    EMAIL_USER, EMAIL_PASS, EMAIL_FROM
    """
    enabled = os.getenv("EMAIL_ENABLED", "false").lower() == "true"
    host = os.getenv("EMAIL_HOST", "smtp.gmail.com")
    port = int(os.getenv("EMAIL_PORT", "465"))
    user = os.getenv("EMAIL_USER")
    password = os.getenv("EMAIL_PASS")
    sender = os.getenv("EMAIL_FROM", user or "no-reply@example.com")

    # Logs de depuración
    logger.info(f"EMAIL_ENABLED: {enabled}")
    logger.info(f"EMAIL_USER: {user}")
    logger.info(f"EMAIL_PASS: {'OK' if password else 'FALTA'}")
    logger.info(f"EMAIL_HOST: {host}, EMAIL_PORT: {port}")

    if not enabled:
        logger.warning("EMAIL_ENABLED no está activado")
        return False
    if not user or not password:
        logger.error("EMAIL_USER o EMAIL_PASS no están configurados")
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

        logger.info(f"✅ Correo enviado exitosamente a {to_email} con código {code}")
        return True

    except smtplib.SMTPAuthenticationError as e:
        logger.error(f"❌ Error de autenticación: {e}. Revisa EMAIL_USER y EMAIL_PASS.")
        return False
    except smtplib.SMTPException as e:
        logger.error(f"❌ Error SMTP: {e}")
        return False
    except Exception as e:
        logger.error(f"❌ Error inesperado: {e}")
        return False