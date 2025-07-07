"""
Script para agregar un negocio y un usuario de prueba
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

def add_business_and_user():
    """Agrega un negocio y un usuario de prueba"""
    try:
        db_session = next(get_db())

        # Crear el negocio
        business = Business(
            name="Negocio Demo",
            description="Negocio de ejemplo creado por script",
            code="DEMO001",
            tax_id="XAXX010101000",
            rfc="XAXX010101000",
            address="Dirección demo",
            phone="1111111111",
            email="demo@negocio.com",
            is_active=True
        )
        db_session.add(business)
        db_session.flush()  # Para obtener el ID
        print(f"✅ Negocio creado: {business.name}")

        # Crear el usuario
        user = User(
            email="usuario@demo.com",
            password_hash=get_password_hash("demo123"),
            first_name="Usuario",
            last_name="Demo",
            role=UserRole.ADMIN,
            is_active=True,
            is_superuser=True
        )
        db_session.add(user)
        db_session.flush()
        print(f"✅ Usuario creado: {user.email} | Password: demo123")

        # Relacionar usuario con negocio
        business_user = BusinessUser(
            user_id=user.id,
            business_id=business.id
        )
        db_session.add(business_user)
        db_session.commit()
        print(f"✅ Usuario vinculado al negocio correctamente.")

    except Exception as e:
        print(f"❌ Error agregando negocio y usuario: {e}")
        if 'db_session' in locals():
            db_session.rollback()
    finally:
        if 'db_session' in locals():
            db_session.close()

if __name__ == "__main__":
    add_business_and_user()
