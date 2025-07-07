"""
Script para importar categorías y marcas del CSV al catálogo de la base de datos
Extrae y registra todas las categorías y marcas únicas encontradas en el CSV
"""

import csv
import sys
import os
from typing import Dict, List, Set
from datetime import datetime
import logging

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy.orm import Session
from app.db.database import get_db, engine
from app.models.models import Business, Category, Brand
from app.core.config import settings

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('import_categories_brands.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


class CatalogImporter:
    """Handle categories and brands import from CSV"""
    
    def __init__(self, db_session: Session):
        self.db = db_session
        self.stats = {
            'categories_found': 0,
            'categories_created': 0,
            'categories_existing': 0,
            'brands_found': 0,
            'brands_created': 0,
            'brands_existing': 0,
            'rows_processed': 0,
            'errors': 0
        }
        self.errors = []
        self.categories_created = []
        self.brands_created = []
    
    def get_or_create_business(self, business_name: str) -> Business:
        """Get or create business"""
        business = self.db.query(Business).filter(Business.name == business_name).first()
        if not business:
            business = Business(
                name=business_name,
                code=business_name.upper().replace(' ', '_')[:50],
                description=f"Business created during catalog import on {datetime.now().strftime('%Y-%m-%d')}"
            )
            self.db.add(business)
            self.db.flush()
            logger.info(f"Created new business: {business_name}")
        return business
    
    def create_category(self, category_name: str, business_id: int) -> Category:
        """Create a new category"""
        # Generate code from name
        code = category_name.upper().replace(' ', '_').replace('/', '_').replace('-', '_')
        # Ensure code is not too long
        code = code[:50]
        
        category = Category(
            business_id=business_id,
            name=category_name,
            code=code,
            description=f"Category imported from CSV on {datetime.now().strftime('%Y-%m-%d')}"
        )
        
        self.db.add(category)
        self.db.flush()
        
        self.categories_created.append({
            'name': category_name,
            'code': code,
            'id': category.id
        })
        
        logger.info(f"Created new category: {category_name} (Code: {code})")
        return category
    
    def create_brand(self, brand_name: str, business_id: int) -> Brand:
        """Create a new brand"""
        # Generate code from name
        code = brand_name.upper().replace(' ', '_').replace('/', '_').replace('-', '_')
        # Ensure code is not too long
        code = code[:50]
        
        brand = Brand(
            business_id=business_id,
            name=brand_name,
            code=code,
            description=f"Brand imported from CSV on {datetime.now().strftime('%Y-%m-%d')}"
        )
        
        self.db.add(brand)
        self.db.flush()
        
        self.brands_created.append({
            'name': brand_name,
            'code': code,
            'id': brand.id
        })
        
        logger.info(f"Created new brand: {brand_name} (Code: {code})")
        return brand
    
    def check_category_exists(self, category_name: str, business_id: int) -> bool:
        """Check if category already exists"""
        return self.db.query(Category).filter(
            Category.name == category_name,
            Category.business_id == business_id
        ).first() is not None
    
    def check_brand_exists(self, brand_name: str, business_id: int) -> bool:
        """Check if brand already exists"""
        return self.db.query(Brand).filter(
            Brand.name == brand_name,
            Brand.business_id == business_id
        ).first() is not None
    
    def extract_catalog_data(self, csv_file_path: str) -> Dict[str, Set[str]]:
        """Extract unique categories and brands from CSV"""
        categories = set()
        brands = set()
        
        logger.info(f"Extracting catalog data from: {csv_file_path}")
        
        try:
            # Detect CSV delimiter
            with open(csv_file_path, 'r', encoding='utf-8-sig') as file:
                sample = file.read(1024)
                delimiter = ';' if ';' in sample else ','
                logger.info(f"Detected CSV delimiter: '{delimiter}'")
            
            # Open and read CSV
            with open(csv_file_path, 'r', encoding='utf-8-sig') as file:
                csv_reader = csv.DictReader(file, delimiter=delimiter)
                
                for row in csv_reader:
                    self.stats['rows_processed'] += 1
                    
                    # Extract category
                    for col_name, value in row.items():
                        clean_col = col_name.strip().lstrip('\ufeff')
                        
                        if clean_col == 'CATEGORIA' and value and value.strip():
                            category_name = value.strip()
                            if category_name and category_name not in ['', 'N/A', 'NULL', 'null']:
                                categories.add(category_name)
                        
                        if clean_col == 'Marca' and value and value.strip():
                            brand_name = value.strip()
                            if brand_name and brand_name not in ['', 'N/A', 'NULL', 'null']:
                                brands.add(brand_name)
                    
                    # Log progress every 500 rows
                    if self.stats['rows_processed'] % 500 == 0:
                        logger.info(f"Processed {self.stats['rows_processed']} rows...")
        
        except Exception as e:
            logger.error(f"Error extracting catalog data: {e}")
            self.errors.append(f"Extraction error: {str(e)}")
            self.stats['errors'] += 1
        
        self.stats['categories_found'] = len(categories)
        self.stats['brands_found'] = len(brands)
        
        logger.info(f"Found {len(categories)} unique categories and {len(brands)} unique brands")
        
        return {
            'categories': categories,
            'brands': brands
        }
    
    def import_catalog_from_csv(self, csv_file_path: str, business_name: str = "Default Business") -> Dict:
        """Import categories and brands from CSV file"""
        logger.info(f"Starting catalog import from: {csv_file_path}")
        
        try:
            # Get or create business
            business = self.get_or_create_business(business_name)
            
            # Extract unique categories and brands
            catalog_data = self.extract_catalog_data(csv_file_path)
            
            # Process categories
            logger.info("Processing categories...")
            for category_name in sorted(catalog_data['categories']):
                if self.check_category_exists(category_name, business.id):
                    self.stats['categories_existing'] += 1
                    logger.debug(f"Category already exists: {category_name}")
                else:
                    self.create_category(category_name, business.id)
                    self.stats['categories_created'] += 1
            
            # Process brands
            logger.info("Processing brands...")
            for brand_name in sorted(catalog_data['brands']):
                if self.check_brand_exists(brand_name, business.id):
                    self.stats['brands_existing'] += 1
                    logger.debug(f"Brand already exists: {brand_name}")
                else:
                    self.create_brand(brand_name, business.id)
                    self.stats['brands_created'] += 1
            
            # Commit all changes
            self.db.commit()
            logger.info("Catalog import completed successfully")
            
        except Exception as e:
            logger.error(f"Error during catalog import: {e}")
            self.db.rollback()
            self.errors.append(f"Import error: {str(e)}")
            self.stats['errors'] += 1
        
        return self.get_import_summary()
    
    def get_import_summary(self) -> Dict:
        """Get import summary statistics"""
        summary = {
            'statistics': self.stats,
            'categories_created': self.categories_created,
            'brands_created': self.brands_created,
            'errors': self.errors
        }
        
        return summary
    
    def print_summary(self):
        """Print import summary to console"""
        print("\n" + "="*60)
        print("CATALOG IMPORT SUMMARY (CATEGORIES & BRANDS)")
        print("="*60)
        print(f"CSV rows processed: {self.stats['rows_processed']}")
        print()
        print("CATEGORIES:")
        print(f"  - Found in CSV: {self.stats['categories_found']}")
        print(f"  - Created: {self.stats['categories_created']}")
        print(f"  - Already existed: {self.stats['categories_existing']}")
        print()
        print("BRANDS:")
        print(f"  - Found in CSV: {self.stats['brands_found']}")
        print(f"  - Created: {self.stats['brands_created']}")
        print(f"  - Already existed: {self.stats['brands_existing']}")
        print()
        print(f"Errors: {self.stats['errors']}")
        
        if self.categories_created:
            print(f"\nNew Categories Created ({len(self.categories_created)}):")
            for cat in self.categories_created[:10]:  # Show first 10
                print(f"  - {cat['name']} (ID: {cat['id']}, Code: {cat['code']})")
            
            if len(self.categories_created) > 10:
                print(f"  ... and {len(self.categories_created) - 10} more categories")
        
        if self.brands_created:
            print(f"\nNew Brands Created ({len(self.brands_created)}):")
            for brand in self.brands_created[:10]:  # Show first 10
                print(f"  - {brand['name']} (ID: {brand['id']}, Code: {brand['code']})")
            
            if len(self.brands_created) > 10:
                print(f"  ... and {len(self.brands_created) - 10} more brands")
        
        if self.errors:
            print(f"\nErrors ({len(self.errors)}):")
            for error in self.errors:
                print(f"  {error}")
        
        print("="*60)


def main():
    """Main function to run the catalog import"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Import categories and brands from CSV')
    parser.add_argument('csv_file', help='Path to CSV file')
    parser.add_argument('--business', default='Default Business', help='Business name')
    
    args = parser.parse_args()
    
    if not os.path.exists(args.csv_file):
        print(f"CSV file not found: {args.csv_file}")
        return
    
    # Get database session
    db_session = next(get_db())
    
    try:
        # Create importer and run import
        importer = CatalogImporter(db_session)
        result = importer.import_catalog_from_csv(args.csv_file, args.business)
        
        # Print summary
        importer.print_summary()
        
        # Save detailed log
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        log_file = f"catalog_import_summary_{timestamp}.json"
        
        import json
        with open(log_file, 'w', encoding='utf-8') as f:
            json.dump(result, f, indent=2, default=str, ensure_ascii=False)
        
        print(f"\nDetailed log saved to: {log_file}")
        
    except Exception as e:
        logger.error(f"Catalog import failed: {e}")
        print(f"Catalog import failed: {e}")
    
    finally:
        db_session.close()


if __name__ == "__main__":
    main()
