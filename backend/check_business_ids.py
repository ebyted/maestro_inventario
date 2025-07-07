"""
Script para verificar qué business_id tienen los productos
"""
import sys
import os

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy.orm import Session
from app.db.database import get_db
from app.models.models import Product, Business

def check_business_ids():
    """Verificar los business_id de los productos"""
    try:
        db_session = next(get_db())
        
        # Verificar todos los business
        businesses = db_session.query(Business).all()
        print("🏢 NEGOCIOS EN LA BD:")
        for business in businesses:
            product_count = db_session.query(Product).filter(Product.business_id == business.id).count()
            print(f"   ID {business.id}: {business.name} - {product_count} productos")
        
        print()
        
        # Verificar productos sin business_id
        products_without_business = db_session.query(Product).filter(Product.business_id == None).count()
        print(f"📦 Productos sin business_id: {products_without_business}")
        
        # Verificar distribución por business_id
        print("\n📊 DISTRIBUCIÓN DE PRODUCTOS POR BUSINESS_ID:")
        from sqlalchemy import func
        result = db_session.query(
            Product.business_id, 
            func.count(Product.id).label('count')
        ).group_by(Product.business_id).all()
        
        for business_id, count in result:
            business_name = "SIN ASIGNAR" if business_id is None else db_session.query(Business).filter(Business.id == business_id).first().name
            print(f"   Business ID {business_id}: {count} productos ({business_name})")
        
    except Exception as e:
        print(f"❌ Error: {e}")
    finally:
        if 'db_session' in locals():
            db_session.close()

if __name__ == "__main__":
    check_business_ids()
