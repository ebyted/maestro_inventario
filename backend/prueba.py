from passlib.context import CryptContext

# Configura bcrypt
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Genera el hash
password_hash = pwd_context.hash("admin123")

print("Hash generado:", password_hash)
