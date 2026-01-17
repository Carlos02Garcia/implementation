FastAPI backend (minimal)

Requisitos: Python 3.9+, MySQL (XAMPP) corriendo localmente.

Pasos rápidos:

1. Crear la base de datos y tabla (usar MySQL Workbench o la CLI):

   mysql -u root -p < models.sql

2. Copiar `.env.example` a `.env` y ajustar credenciales.

3. Instalar dependencias:

   python -m pip install -r requirements.txt

4. Lanzar el servidor de desarrollo:

   uvicorn main:app --reload --host 0.0.0.0 --port 8000

Endpoints:
- POST /register  {"username": "...", "password": "..."}
- POST /login     {"username": "...", "password": "..."}

Notas:
- Usa `DB_HOST=127.0.0.1` y el puerto `3306` para XAMPP.
- Este es un ejemplo mínimo pensado para desarrollo local.
