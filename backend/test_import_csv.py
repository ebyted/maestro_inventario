"""
Test script for the CSV import functionality
"""

import sys
import os

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from import_products_csv import ProductImporter, create_sample_csv
from app.db.database import get_db

def test_import():
    """Test the import functionality"""
    print("Testing CSV Product Import Script...")
    
    # Create sample CSV
    print("1. Creating sample CSV file...")
    create_sample_csv()
    
    # Test import with duplicate detection
    print("2. Testing import with duplicate detection...")
    
    db_session = next(get_db())
    try:
        importer = ProductImporter(db_session)
        
        # First import
        print("   First import (should create products)...")
        result1 = importer.import_from_csv('sample_products.csv', 'Test Business')
        importer.print_summary()
        
        # Second import (should skip duplicates)
        print("\n   Second import (should skip duplicates)...")
        importer2 = ProductImporter(db_session)
        result2 = importer2.import_from_csv('sample_products.csv', 'Test Business')
        importer2.print_summary()
        
        print("\n✅ Test completed successfully!")
        print(f"First import created: {result1['statistics']['products_created']} products")
        print(f"Second import skipped: {result2['statistics']['products_skipped']} products")
        
    except Exception as e:
        print(f"❌ Test failed: {e}")
    
    finally:
        db_session.close()

if __name__ == "__main__":
    test_import()
