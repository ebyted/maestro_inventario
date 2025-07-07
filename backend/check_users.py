import sys
import os

# Asegurar que el directorio backend esté en el path
backend_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, backend_dir)

try:
    from app.db.database import SessionLocal
    from app.models import User
except ImportError as e:
    print(f"❌ Error de importación: {e}")
    print(f"📍 Directorio actual: {os.getcwd()}")
    print(f"📍 Directorio del script: {backend_dir}")
    print(f"📍 Python path: {sys.path}")
    sys.exit(1)

print("🔍 Iniciando verificación de usuarios...")

db = SessionLocal()
try:
    users = db.query(User).all()
    print(f"📊 Total usuarios: {len(users)}")
    
    if len(users) == 0:
        print("❌ No hay usuarios en la base de datos")
    else:
        for user in users:
            print(f"👤 ID: {user.id}")
            print(f"📧 Email: {user.email}")
            print(f"✅ Activo: {user.is_active}")
            print(f"🔐 Superuser: {user.is_superuser}")
            print(f"🔑 Hash password exists: {bool(user.password_hash)}")
            print(f"📝 Nombre: {user.first_name} {user.last_name}")
            print("---")
except Exception as e:
    print(f"❌ Error al consultar usuarios: {e}")
finally:
    db.close()

print("✅ Verificación completada.")
