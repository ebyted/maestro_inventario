#!/usr/bin/env python3
"""
Direct test of the export functions without running the full server
"""
import sys
import os
import traceback
import asyncio

# Add the backend directory to the Python path
backend_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, backend_dir)

# Configure environment for testing
os.environ.setdefault('DATABASE_URL', 'postgresql://postgres:postgres@localhost:5432/maestro_inventario')

from app.db.database import SessionLocal, engine
from app.models.models import Base

# Create tables if they don't exist
Base.metadata.create_all(bind=engine)

async def test_warehouse_export():
    """Test the warehouse export function directly"""
    print("\n=== Testing Warehouse Export Function ===")
    try:
        from app.api.v1.endpoints.admin_panel import export_warehouses_excel
        from sqlalchemy.orm import Session
        
        # Create a database session
        db = SessionLocal()
        
        # Call the export function directly
        response = await export_warehouses_excel(db=db)
        
        print(f"Export successful! Response type: {type(response)}")
        if hasattr(response, 'body'):
            print(f"Response body size: {len(response.body)} bytes")
        return True
        
    except Exception as e:
        print(f"Error in warehouse export: {e}")
        traceback.print_exc()
        return False
    finally:
        if 'db' in locals():
            db.close()

async def test_articles_export():
    """Test the articles export function directly"""
    print("\n=== Testing Articles Export Function ===")
    try:
        from app.api.v1.endpoints.admin_panel import export_articles
        from sqlalchemy.orm import Session
        
        # Create a database session
        db = SessionLocal()
        
        # Call the export function directly
        response = await export_articles(db=db)
        
        print(f"Export successful! Response type: {type(response)}")
        if hasattr(response, 'body'):
            print(f"Response body size: {len(response.body)} bytes")
        return True
        
    except Exception as e:
        print(f"Error in articles export: {e}")
        traceback.print_exc()
        return False
    finally:
        if 'db' in locals():
            db.close()

async def test_purchase_orders_export():
    """Test the purchase orders export function directly"""
    print("\n=== Testing Purchase Orders Export Function ===")
    try:
        from app.api.v1.endpoints.admin_panel import export_purchase_orders
        from sqlalchemy.orm import Session
        
        # Create a database session
        db = SessionLocal()
        
        # Call the export function directly
        response = await export_purchase_orders(db=db)
        
        print(f"Export successful! Response type: {type(response)}")
        if hasattr(response, 'body'):
            print(f"Response body size: {len(response.body)} bytes")
        return True
        
    except Exception as e:
        print(f"Error in purchase orders export: {e}")
        traceback.print_exc()
        return False
    finally:
        if 'db' in locals():
            db.close()

async def test_inventory_movements_export():
    """Test the inventory movements export function directly"""
    print("\n=== Testing Inventory Movements Export Function ===")
    try:
        from app.api.v1.endpoints.admin_panel import export_inventory_movements
        from sqlalchemy.orm import Session
        
        # Create a database session
        db = SessionLocal()
        
        # Call the export function directly
        response = await export_inventory_movements(db=db)
        
        print(f"Export successful! Response type: {type(response)}")
        if hasattr(response, 'body'):
            print(f"Response body size: {len(response.body)} bytes")
        return True
        
    except Exception as e:
        print(f"Error in inventory movements export: {e}")
        traceback.print_exc()
        return False
    finally:
        if 'db' in locals():
            db.close()

async def main():
    print("🔍 Direct Testing of Export Functions")
    print("=" * 50)
    
    results = {}
    
    # Test each export function
    results['warehouses'] = await test_warehouse_export()
    results['articles'] = await test_articles_export()
    results['purchase_orders'] = await test_purchase_orders_export()
    results['inventory_movements'] = await test_inventory_movements_export()
    
    # Print summary
    print("\n" + "=" * 50)
    print("📊 SUMMARY")
    print("=" * 50)
    
    for name, success in results.items():
        status = "✅ SUCCESS" if success else "❌ FAILED"
        print(f"{name.replace('_', ' ').title()}: {status}")

if __name__ == "__main__":
    asyncio.run(main())
