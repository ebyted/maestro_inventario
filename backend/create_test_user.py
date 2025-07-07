"""
Script para crear un usuario de prueba y probar el login
"""
import sys
import os
from datetime import datetime

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy.orm import Session
from app.db.database import get_db
from app.models.models import User, Business, BusinessUser, UserRole
from passlib.context import CryptContext

# Configurar el contexto de contraseñas
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)

def create_test_user():
    """Elimina todos los negocios y crea usuarios de prueba para testing: admin, capturista y almacenista"""
    try:
        db_session = next(get_db())

        # BORRAR TODOS LOS NEGOCIOS (y en cascada usuarios relacionados si aplica)
        db_session.query(Business).delete()
        db_session.commit()
        print("🗑️ Todos los registros de 'businesses' eliminados.")

        # Crear el negocio principal
        business = Business(
            name="Maestro Inventario",
            code="MI001",
            tax_id="XAXX010101000",
            rfc="XAXX010101000",
            address="Dirección de prueba",
            phone="0000000000",
            email="admin@maestro.com",
            is_active=True
        )
        db_session.add(business)
        db_session.flush()  # Para obtener el ID
        print("✅ Negocio 'Maestro Inventario' creado.")

        # Usuarios a crear: (email, nombre, apellido, rol, password, is_superuser)
        users_to_create = [
            ("admin@maestro.com", "Administrador", "de Prueba", UserRole.ADMIN, "admin123", True),
            ("capturista@maestro.com", "Capturista", "de Prueba", UserRole.CAPTURISTA, "captura123", False),
            ("almacenista@maestro.com", "Almacenista", "de Prueba", UserRole.ALMACENISTA, "almacen123", False),
        ]

        for email, first_name, last_name, role, password, is_superuser in users_to_create:
            user = User(
                email=email,
                password_hash=get_password_hash(password),
                first_name=first_name,
                last_name=last_name,
                role=role,
                is_active=True,
                is_superuser=is_superuser
            )
            db_session.add(user)
            db_session.flush()
            business_user = BusinessUser(
                user_id=user.id,
                business_id=business.id
            )
            db_session.add(business_user)
            print(f"✅ Usuario de prueba creado: {email} | Rol: {role.value} | Password: {password}")
        db_session.commit()

    except Exception as e:
        print(f"❌ Error creando usuarios de prueba: {e}")
        if 'db_session' in locals():
            db_session.rollback()
    finally:
        if 'db_session' in locals():
            db_session.close()

if __name__ == "__main__":
    create_test_user()
