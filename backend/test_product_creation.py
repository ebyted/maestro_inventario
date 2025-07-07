#!/usr/bin/env python3
"""
Script para probar la creación de productos
"""
import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.db.database import get_db
from app.models.models import Product, User
from app.schemas import ProductCreate
from sqlalchemy.orm import Session

def test_product_creation():
    """Test direct product creation"""
    db = next(get_db())
    
    try:
        # Test data
        product_data = {
            'name': 'Producto Test Directo',
            'description': 'Descripción de prueba',
            'business_id': 1,
            'sku': 'DIRECT001',
            'category_id': 1,
            'brand_id': 1,
            'base_unit_id': 1
        }
        
        # Create ProductCreate instance
        product_create = ProductCreate(**product_data)
        print(f"ProductCreate data: {product_create.dict()}")
        
        # Check if SKU exists
        existing = db.query(Product).filter(Product.sku == product_create.sku).first()
        if existing:
            print(f"SKU {product_create.sku} already exists, deleting...")
            db.delete(existing)
            db.commit()
        
        # Create product
        db_product = Product(**product_create.dict())
        db.add(db_product)
        db.commit()
        db.refresh(db_product)
        
        print(f"SUCCESS: Product created with ID {db_product.id}")
        print(f"Name: {db_product.name}")
        print(f"SKU: {db_product.sku}")
        print(f"Business ID: {db_product.business_id}")
        
        return True
        
    except Exception as e:
        print(f"ERROR: {e}")
        db.rollback()
        return False
    finally:
        db.close()

if __name__ == "__main__":
    test_product_creation()
