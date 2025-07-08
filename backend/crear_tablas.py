"""
Script para crear todas las tablas en PostgreSQL desde cero
"""

import sys
import os
import time

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.db.database import engine
from app.models.models import Base
from app.models.login_attempt import LoginAttempt

def crear_tablas():
    """Crea todas las tablas en PostgreSQL"""
    print("🔧 CREANDO TABLAS EN POSTGRESQL")
    print("=" * 50)
    
    try:
        print("⏰ Esperando 10 segundos para que PostgreSQL esté listo...")
        time.sleep(10)
        
        print("🏗️ Creando todas las tablas...")
        Base.metadata.create_all(bind=engine)  # Solo para desarrollo, comentar en producción
        
        print("✅ Tablas creadas exitosamente")
        
        # Verificar conexión
        with engine.connect() as conn:
            result = conn.execute("SELECT version();")
            version = result.fetchone()[0]
            print(f"📋 PostgreSQL Version: {version}")
        
        return True
        
    except Exception as e:
        print(f"❌ Error creando tablas: {e}")
        return False

if __name__ == "__main__":
    crear_tablas()
