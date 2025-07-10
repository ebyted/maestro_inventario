from passlib.context import CryptContext

# Configura bcrypt
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Genera el hash
password_hash = pwd_context.hash("admin123")
print("Hash generado:", password_hash)

# Verifica el hash (cambia este valor por el hash guardado en tu base de datos)
hash_guardado = password_hash  # O pega aquí el hash de la base de datos
hash_guardado = '$2b$12$mEGX8Kq6XfXrstNo1A0Ga.rm3ofvCi3HEHTEoFsWjQEZ2QhLnjaa.'  # O pega aquí el hash de la base de datos


# Validar la contraseña
if pwd_context.verify("admin123", hash_guardado):
    print("✅ La contraseña es válida para el hash.")
else:
    print("❌ La contraseña NO coincide con el hash.")
