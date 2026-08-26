-- Schema para la base de datos 'miapp'
<<<<<<< HEAD
USE b88sz46vbki4xwgfjyv7;
=======
CREATE DATABASE IF NOT EXISTS miapp;
USE miapp;
>>>>>>> 792a954d18a029d45d707dc8ca638f1b36e1a392

-- Tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índice adicional sobre email (ya cubierto por UNIQUE, opcional)
<<<<<<< HEAD
CREATE INDEX idx_users_email ON users(email);
=======
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
>>>>>>> 792a954d18a029d45d707dc8ca638f1b36e1a392

-- Tabla de códigos OTP para verificación de login
CREATE TABLE IF NOT EXISTS otp_codes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  code VARCHAR(6) NOT NULL,
  expires_at DATETIME NOT NULL,
  used TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_otp_email (email),
  INDEX idx_otp_expires (expires_at)
);
