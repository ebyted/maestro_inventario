"""
Script para verificar el estado de la base de datos después de la importación
"""

import sys
import os

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy.orm import Session
from app.db.database import get_db
from app.models.models import Product, ProductVariant, Business, Category, Brand, Unit

def verificar_base_datos():
    """Verifica el estado actual de la base de datos"""
    print("🔍 VERIFICANDO ESTADO DE LA BASE DE DATOS")
    print("=" * 50)
    
    try:
        # Verificar primero la conexión
        print("🔌 Intentando conectar a la base de datos...")
        db_session = next(get_db())
        print("✅ Conexión exitosa a la base de datos")
        
        # Contar registros principales
        business_count = db_session.query(Business).count()
        product_count = db_session.query(Product).count()
        category_count = db_session.query(Category).count()
        brand_count = db_session.query(Brand).count()
        unit_count = db_session.query(Unit).count()
        variant_count = db_session.query(ProductVariant).count()
        
        print(f"🏢 Negocios registrados: {business_count}")
        print(f"📦 Productos totales: {product_count}")
        print(f"🏷️ Categorías: {category_count}")
        print(f"🔖 Marcas: {brand_count}")
        print(f"📏 Unidades: {unit_count}")
        print(f"🔄 Variantes de productos: {variant_count}")
        
        # Obtener información del negocio principal
        business = db_session.query(Business).filter(Business.name == "Maestro Inventario").first()
        if business:
            print(f"\n🏢 NEGOCIO PRINCIPAL:")
            print(f"   Nombre: {business.name}")
            print(f"   Código: {business.code}")
            print(f"   RFC: {business.rfc}")
            print(f"   Activo: {'Sí' if business.is_active else 'No'}")
            print(f"   Creado: {business.created_at}")
            
            # Productos de este negocio
            business_products = db_session.query(Product).filter(Product.business_id == business.id).count()
            print(f"   Productos asociados: {business_products}")
        
        # Mostrar algunas categorías
        print(f"\n🏷️ PRIMERAS 10 CATEGORÍAS:")
        categories = db_session.query(Category).limit(10).all()
        for i, cat in enumerate(categories, 1):
            product_count_in_cat = db_session.query(Product).filter(Product.category_id == cat.id).count()
            print(f"   {i:2d}. {cat.name} ({product_count_in_cat} productos)")
        
        # Mostrar algunas marcas
        print(f"\n🔖 PRIMERAS 10 MARCAS:")
        brands = db_session.query(Brand).limit(10).all()
        for i, brand in enumerate(brands, 1):
            product_count_in_brand = db_session.query(Product).filter(Product.brand_id == brand.id).count()
            print(f"   {i:2d}. {brand.name} ({product_count_in_brand} productos)")
        
        # Mostrar algunos productos recientes
        print(f"\n📦 ÚLTIMOS 5 PRODUCTOS CREADOS:")
        recent_products = db_session.query(Product).order_by(Product.created_at.desc()).limit(5).all()
        for i, product in enumerate(recent_products, 1):
            category_name = product.category.name if product.category else "Sin categoría"
            brand_name = product.brand.name if product.brand else "Sin marca"
            print(f"   {i}. {product.name[:50]}")
            print(f"      SKU: {product.sku} | Categoría: {category_name} | Marca: {brand_name}")
        
        # Estadísticas adicionales
        products_with_category = db_session.query(Product).filter(Product.category_id.isnot(None)).count()
        products_with_brand = db_session.query(Product).filter(Product.brand_id.isnot(None)).count()
        products_active = db_session.query(Product).filter(Product.is_active == True).count()
        
        print(f"\n📊 ESTADÍSTICAS:")
        print(f"   Productos con categoría: {products_with_category}/{product_count} ({(products_with_category/max(product_count,1)*100):.1f}%)")
        print(f"   Productos con marca: {products_with_brand}/{product_count} ({(products_with_brand/max(product_count,1)*100):.1f}%)")
        print(f"   Productos activos: {products_active}/{product_count} ({(products_active/max(product_count,1)*100):.1f}%)")
        
        print(f"\n✅ Verificación completada exitosamente!")
        
        # Verificar si hay duplicados
        print(f"\n🔍 VERIFICANDO DUPLICADOS:")
        duplicated_names = db_session.execute("""
            SELECT name, COUNT(*) as count 
            FROM products 
            GROUP BY name 
            HAVING COUNT(*) > 1
            LIMIT 5
        """).fetchall()
        
        if duplicated_names:
            print(f"   ⚠️ Se encontraron {len(duplicated_names)} nombres duplicados:")
            for name, count in duplicated_names:
                print(f"      '{name}' aparece {count} veces")
        else:
            print(f"   ✅ No se encontraron nombres duplicados")
        
        return True
        
    except Exception as e:
        print(f"❌ Error al verificar la base de datos: {e}")
        print("\n💡 SOLUCIONES POSIBLES:")
        
        if "connection" in str(e).lower() or "refused" in str(e).lower():
            print("   1. 🐳 Iniciar Docker Desktop")
            print("   2. 🔄 Ejecutar: docker start maestro-postgres")
            print("   3. 🆕 O crear contenedor: docker run --name maestro-postgres \\")
            print("      -e POSTGRES_PASSWORD=postgres -e POSTGRES_USER=postgres \\")
            print("      -e POSTGRES_DB=maestro_inventario -p 5432:5432 -d postgres:15")
            print("   4. ⏰ Esperar unos segundos para que PostgreSQL inicie completamente")
        
        if "does not exist" in str(e).lower():
            print("   1. 📊 Ejecutar migraciones: alembic upgrade head")
            print("   2. 🔄 Reiniciar el backend")
        
        print(f"\n🔗 URL de conexión actual: {os.getenv('DATABASE_URL', 'No configurada')}")
        
        return False
    finally:
        if 'db_session' in locals():
            db_session.close()

if __name__ == "__main__":
    verificar_base_datos()
