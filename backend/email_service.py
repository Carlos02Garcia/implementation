import logging
import os

import resend


logger = logging.getLogger(__name__)


def send_otp_email(to_email: str, code: str) -> bool:
    """Envía un OTP mediante la API HTTPS de Resend."""
    enabled = os.getenv("EMAIL_ENABLED", "false").lower() == "true"
    api_key = os.getenv("RESEND_API_KEY")
    sender = os.getenv("EMAIL_FROM")

    if not enabled:
        logger.warning("EMAIL_ENABLED no está activado")
        return False
    if not api_key:
        logger.error("RESEND_API_KEY no está configurada")
        return False
    if not sender:
        logger.error("EMAIL_FROM no está configurado")
        return False

    try:
        resend.api_key = api_key
        response = resend.Emails.send(
            {
                "from": sender,
                "to": [to_email],
                "subject": "Código de inicio de sesión",
                "text": f"Tu código de verificación es: {code}",
                "html": (
                    "<p>Tu código de verificación es:</p>"
                    f"<p><strong style=\"font-size: 24px; letter-spacing: 4px;\">{code}</strong></p>"
                    "<p>Este código vence en 5 minutos.</p>"
                ),
            }
        )
        email_id = response.get("id") if isinstance(response, dict) else None
        logger.info("Correo OTP aceptado por Resend para %s (id: %s)", to_email, email_id)
        return True
    except Exception:
        logger.exception("Resend no pudo enviar el OTP a %s", to_email)
        return False
