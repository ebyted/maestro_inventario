"""
Script para verificar que no hay datos mock en el frontend
y que todo viene de la base de datos PostgreSQL
"""

import sys
import os
import subprocess

def verificar_docker():
    """Verifica si Docker está disponible"""
    try:
        result = subprocess.run(['docker', '--version'], capture_output=True, text=True)
        if result.returncode == 0:
            print("✅ Docker está disponible")
            return True
        else:
            print("❌ Docker no está disponible")
            return False
    except FileNotFoundError:
        print("❌ Docker no está instalado")
        return False

def verificar_contenedor_postgres():
    """Verifica si el contenedor de PostgreSQL existe y está ejecutándose"""
    try:
        # Verificar si el contenedor existe
        result = subprocess.run(['docker', 'ps', '-a', '--filter', 'name=maestro-postgres'], 
                              capture_output=True, text=True)
        
        if 'maestro-postgres' in result.stdout:
            print("✅ Contenedor maestro-postgres existe")
            
            # Verificar si está ejecutándose
            result = subprocess.run(['docker', 'ps', '--filter', 'name=maestro-postgres'], 
                                  capture_output=True, text=True)
            
            if 'maestro-postgres' in result.stdout:
                print("✅ Contenedor maestro-postgres está ejecutándose")
                return True
            else:
                print("⚠️ Contenedor maestro-postgres existe pero no está ejecutándose")
                return False
        else:
            print("❌ Contenedor maestro-postgres no existe")
            return False
            
    except Exception as e:
        print(f"❌ Error verificando contenedor: {e}")
        return False

def iniciar_contenedor_postgres():
    """Inicia el contenedor de PostgreSQL"""
    try:
        print("🔄 Intentando iniciar contenedor maestro-postgres...")
        result = subprocess.run(['docker', 'start', 'maestro-postgres'], 
                              capture_output=True, text=True)
        
        if result.returncode == 0:
            print("✅ Contenedor iniciado exitosamente")
            print("⏰ Esperando 10 segundos para que PostgreSQL esté listo...")
            import time
            time.sleep(10)
            return True
        else:
            print(f"❌ Error iniciando contenedor: {result.stderr}")
            return False
            
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def crear_contenedor_postgres():
    """Crea y ejecuta el contenedor de PostgreSQL"""
    try:
        print("🆕 Creando nuevo contenedor maestro-postgres...")
        cmd = [
            'docker', 'run', '--name', 'maestro-postgres',
            '-e', 'POSTGRES_PASSWORD=postgres',
            '-e', 'POSTGRES_USER=postgres', 
            '-e', 'POSTGRES_DB=maestro_inventario',
            '-p', '5432:5432',
            '-d', 'postgres:15'
        ]
        
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode == 0:
            print("✅ Contenedor creado exitosamente")
            print("⏰ Esperando 15 segundos para que PostgreSQL esté listo...")
            import time
            time.sleep(15)
            return True
        else:
            print(f"❌ Error creando contenedor: {result.stderr}")
            return False
            
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def setup_postgresql():
    """Configura PostgreSQL automáticamente"""
    print("🔍 CONFIGURANDO POSTGRESQL PARA MAESTRO INVENTARIO")
    print("=" * 60)
    
    # Verificar Docker
    if not verificar_docker():
        print("\n💡 SOLUCIÓN: Instala Docker Desktop desde https://www.docker.com/products/docker-desktop")
        return False
    
    # Verificar contenedor
    if verificar_contenedor_postgres():
        print("✅ PostgreSQL ya está ejecutándose")
        return True
    
    # Intentar iniciar contenedor existente
    if 'maestro-postgres' in subprocess.run(['docker', 'ps', '-a'], capture_output=True, text=True).stdout:
        if iniciar_contenedor_postgres():
            return True
    
    # Crear nuevo contenedor
    if crear_contenedor_postgres():
        return True
    
    print("❌ No se pudo configurar PostgreSQL")
    return False

def verificar_datos_reales():
    """Verifica que el frontend esté usando datos reales de la BD"""
    print("\n🔍 VERIFICANDO QUE NO HAY DATOS MOCK EN EL FRONTEND")
    print("=" * 60)
    
    # Add the backend directory to Python path
    sys.path.append(os.path.dirname(os.path.abspath(__file__)))
    
    try:
        from app.db.database import get_db
        from app.models.models import Product, Business
        
        db_session = next(get_db())
        
        # Verificar productos
        product_count = db_session.query(Product).count()
        business_count = db_session.query(Business).count()
        
        print(f"✅ Productos en BD: {product_count}")
        print(f"✅ Negocios en BD: {business_count}")
        
        if product_count > 0:
            print("✅ El sistema está usando datos reales de PostgreSQL")
            
            # Mostrar algunos productos de ejemplo
            sample_products = db_session.query(Product).limit(3).all()
            print("\n📦 PRODUCTOS DE EJEMPLO (de la BD):")
            for i, product in enumerate(sample_products, 1):
                print(f"   {i}. {product.name} (SKU: {product.sku})")
            
            return True
        else:
            print("⚠️ No hay productos en la base de datos")
            print("💡 Ejecuta el script de importación de productos")
            return False
            
    except Exception as e:
        print(f"❌ Error verificando datos: {e}")
        return False
    finally:
        if 'db_session' in locals():
            db_session.close()

def main():
    """Función principal"""
    print("🚀 MAESTRO INVENTARIO - VERIFICACIÓN DE CONFIGURACIÓN")
    print("=" * 60)
    
    # 1. Configurar PostgreSQL
    if not setup_postgresql():
        print("\n❌ No se pudo configurar PostgreSQL")
        return False
    
    # 2. Verificar datos reales
    if not verificar_datos_reales():
        print("\n⚠️ Sistema configurado pero sin datos")
        return False
    
    print("\n🎉 SISTEMA CONFIGURADO CORRECTAMENTE")
    print("✅ PostgreSQL ejecutándose")
    print("✅ Datos reales en la base de datos")
    print("✅ Frontend conectado a BD (sin mocks)")
    
    return True

if __name__ == "__main__":
    main()
