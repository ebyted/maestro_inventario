import sys
import os
sys.path.append(os.getcwd())

from app.db.database import SessionLocal
from sqlalchemy import text

db = SessionLocal()
try:
    # Verificar estructura de la tabla users
    result = db.execute(text("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'users'"))
    columns = result.fetchall()
    
    print("📋 Columnas de la tabla 'users':")
    for col in columns:
        print(f"  - {col[0]}: {col[1]}")
        
    # Verificar si existe algún usuario
    result = db.execute(text("SELECT COUNT(*) FROM users"))
    count = result.fetchone()[0]
    print(f"\n👥 Total usuarios: {count}")
    
    if count > 0:
        result = db.execute(text("SELECT id, email, first_name, last_name FROM users"))
        users = result.fetchall()
        print("\n📝 Usuarios existentes:")
        for user in users:
            print(f"  - ID: {user[0]}, Email: {user[1]}, Nombre: {user[2]} {user[3]}")
            
finally:
    db.close()
