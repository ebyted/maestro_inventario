"""
CSV Product Import Script for Maestro Inventario
Imports products from CSV file with duplicate verification
"""

import csv
import sys
import os
from typing import Dict, List, Optional, Tuple
from datetime import datetime
import logging

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy.orm import Session
from app.db.database import get_db, engine
from app.models.models import Product, ProductVariant, Business, Category, Brand, Unit
from app.core.config import settings

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('import_products.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


class ProductImporter:
    """Handle CSV product import with duplicate checking"""
    
    def __init__(self, db_session: Session):
        self.db = db_session
        self.stats = {
            'total_rows': 0,
            'products_created': 0,
            'products_skipped': 0,
            'variants_created': 0,
            'variants_skipped': 0,
            'errors': 0
        }
        self.skipped_products = []
        self.errors = []
    
    def check_product_exists(self, sku: str = None, barcode: str = None, name: str = None, business_id: int = None) -> Optional[Product]:
        """
        Check if a product already exists in the database
        Returns the existing product if found, None otherwise
        """
        query = self.db.query(Product)
        
        # Filter by business if provided
        if business_id:
            query = query.filter(Product.business_id == business_id)
        
        # Check by SKU first (most reliable)
        if sku:
            existing = query.filter(Product.sku == sku).first()
            if existing:
                return existing
        
        # Check by barcode
        if barcode:
            existing = query.filter(Product.barcode == barcode).first()
            if existing:
                return existing
        
        # Check by name (less reliable, but useful)
        if name:
            existing = query.filter(Product.name.ilike(f"%{name}%")).first()
            if existing:
                return existing
        
        return None
    
    def check_variant_exists(self, product_id: int, sku: str = None, barcode: str = None) -> Optional[ProductVariant]:
        """
        Check if a product variant already exists
        Returns the existing variant if found, None otherwise
        """
        query = self.db.query(ProductVariant).filter(ProductVariant.product_id == product_id)
        
        # Check by SKU
        if sku:
            existing = query.filter(ProductVariant.sku == sku).first()
            if existing:
                return existing
        
        # Check by barcode
        if barcode:
            existing = query.filter(ProductVariant.barcode == barcode).first()
            if existing:
                return existing
        
        return None
    
    def get_or_create_business(self, business_name: str) -> Business:
        """Get or create business"""
        business = self.db.query(Business).filter(Business.name == business_name).first()
        if not business:
            business = Business(
                name=business_name,
                code=business_name.upper().replace(' ', '_')[:50]
            )
            self.db.add(business)
            self.db.flush()
            logger.info(f"Created new business: {business_name}")
        return business
    
    def get_or_create_category(self, category_name: str, business_id: int) -> Optional[Category]:
        """Get or create category"""
        if not category_name:
            return None
        
        category = self.db.query(Category).filter(
            Category.name == category_name,
            Category.business_id == business_id
        ).first()
        
        if not category:
            category = Category(
                business_id=business_id,
                name=category_name,
                code=category_name.upper().replace(' ', '_')[:50]
            )
            self.db.add(category)
            self.db.flush()
            logger.info(f"Created new category: {category_name}")
        
        return category
    
    def get_or_create_brand(self, brand_name: str, business_id: int) -> Optional[Brand]:
        """Get or create brand"""
        if not brand_name:
            return None
        
        brand = self.db.query(Brand).filter(
            Brand.name == brand_name,
            Brand.business_id == business_id
        ).first()
        
        if not brand:
            brand = Brand(
                business_id=business_id,
                name=brand_name,
                code=brand_name.upper().replace(' ', '_')[:50]
            )
            self.db.add(brand)
            self.db.flush()
            logger.info(f"Created new brand: {brand_name}")
        
        return brand
    
    def get_unit(self, unit_name: str) -> Optional[Unit]:
        """Get unit by name or abbreviation"""
        if not unit_name:
            return None
        
        unit = self.db.query(Unit).filter(
            (Unit.name == unit_name) | (Unit.abbreviation == unit_name)
        ).first()
        
        if not unit:
            logger.warning(f"Unit not found: {unit_name}")
        
        return unit
    
    def create_product_from_row(self, row: Dict[str, str], business: Business) -> Optional[Product]:
        """Create a new product from CSV row data"""
        try:
            # Get or create category and brand
            category = None
            if row.get('category'):
                category = self.get_or_create_category(row['category'], business.id)
            
            brand = None
            if row.get('brand'):
                brand = self.get_or_create_brand(row['brand'], business.id)
            
            # Get base unit
            base_unit = None
            if row.get('base_unit'):
                base_unit = self.get_unit(row['base_unit'])
            
            # Create product
            product_data = {
                'business_id': business.id,
                'name': row['name'],
                'description': row.get('description', ''),
                'sku': row.get('sku'),
                'barcode': row.get('barcode'),
                'minimum_stock': float(row.get('minimum_stock', 0)),
                'maximum_stock': float(row.get('maximum_stock')) if row.get('maximum_stock') else None,
                'category_id': category.id if category else None,
                'brand_id': brand.id if brand else None,
                'base_unit_id': base_unit.id if base_unit else None
            }
            
            # Remove empty values
            product_data = {k: v for k, v in product_data.items() if v is not None and v != ''}
            
            product = Product(**product_data)
            self.db.add(product)
            self.db.flush()  # Get the ID
            
            return product
            
        except Exception as e:
            logger.error(f"Error creating product from row: {e}")
            self.errors.append(f"Row {self.stats['total_rows']}: {str(e)}")
            return None
    
    def create_variant_from_row(self, row: Dict[str, str], product: Product) -> Optional[ProductVariant]:
        """Create a product variant from CSV row data"""
        try:
            variant_data = {
                'product_id': product.id,
                'name': row.get('variant_name'),
                'sku': row.get('variant_sku') or row.get('sku'),
                'barcode': row.get('variant_barcode') or row.get('barcode'),
                'attributes': row.get('variant_attributes'),
                'cost_price': float(row.get('cost_price')) if row.get('cost_price') else None,
                'selling_price': float(row.get('selling_price')) if row.get('selling_price') else None
            }
            
            # Remove empty values
            variant_data = {k: v for k, v in variant_data.items() if v is not None and v != ''}
            
            variant = ProductVariant(**variant_data)
            self.db.add(variant)
            self.db.flush()
            
            return variant
            
        except Exception as e:
            logger.error(f"Error creating variant: {e}")
            self.errors.append(f"Row {self.stats['total_rows']} variant: {str(e)}")
            return None
    
    def process_row(self, row: Dict[str, str], business: Business) -> bool:
        """Process a single CSV row"""
        try:
            self.stats['total_rows'] += 1
            
            # Required fields
            if not row.get('name'):
                self.errors.append(f"Row {self.stats['total_rows']}: Missing required field 'name'")
                self.stats['errors'] += 1
                return False
            
            # Check if product already exists
            existing_product = self.check_product_exists(
                sku=row.get('sku'),
                barcode=row.get('barcode'),
                name=row.get('name'),
                business_id=business.id
            )
            
            if existing_product:
                self.skipped_products.append({
                    'row': self.stats['total_rows'],
                    'name': row.get('name'),
                    'sku': row.get('sku'),
                    'reason': f'Product already exists (ID: {existing_product.id})'
                })
                self.stats['products_skipped'] += 1
                logger.info(f"Skipped existing product: {row.get('name')} (SKU: {row.get('sku')})")
                
                # Check if we need to create/skip variant
                if row.get('variant_sku') or row.get('variant_name'):
                    existing_variant = self.check_variant_exists(
                        product_id=existing_product.id,
                        sku=row.get('variant_sku'),
                        barcode=row.get('variant_barcode')
                    )
                    
                    if existing_variant:
                        self.stats['variants_skipped'] += 1
                        logger.info(f"Skipped existing variant: {row.get('variant_name')} (SKU: {row.get('variant_sku')})")
                    else:
                        # Create new variant for existing product
                        variant = self.create_variant_from_row(row, existing_product)
                        if variant:
                            self.stats['variants_created'] += 1
                            logger.info(f"Created new variant: {variant.name} for existing product: {existing_product.name}")
                
                return True
            
            # Create new product
            product = self.create_product_from_row(row, business)
            if not product:
                self.stats['errors'] += 1
                return False
            
            self.stats['products_created'] += 1
            logger.info(f"Created new product: {product.name} (SKU: {product.sku})")
            
            # Create variant if specified
            if row.get('variant_sku') or row.get('variant_name'):
                variant = self.create_variant_from_row(row, product)
                if variant:
                    self.stats['variants_created'] += 1
                    logger.info(f"Created variant: {variant.name} for product: {product.name}")
            
            return True
            
        except Exception as e:
            logger.error(f"Error processing row {self.stats['total_rows']}: {e}")
            self.errors.append(f"Row {self.stats['total_rows']}: {str(e)}")
            self.stats['errors'] += 1
            return False
    
    def map_csv_row(self, raw_row: Dict[str, str]) -> Dict[str, str]:
        """Map CSV columns to expected format"""
        # Column mapping for the specific CSV format
        column_mapping = {
            'PRODUCTO': 'name',
            'NUMERO DE PRODUCTO SIMILAR': 'sku', 
            'Marca': 'brand',
            'CATEGORIA': 'category'
        }
        
        mapped_row = {}
        
        for original_key, value in raw_row.items():
            # Clean up the key (remove BOM, extra spaces, etc.)
            clean_key = original_key.strip().lstrip('\ufeff')
            
            # Map to expected column name
            if clean_key in column_mapping:
                mapped_key = column_mapping[clean_key]
                mapped_row[mapped_key] = value.strip() if value else ''
            else:
                # Keep unmapped columns as-is (in case they're needed)
                if clean_key:  # Only add non-empty keys
                    mapped_row[clean_key] = value.strip() if value else ''
        
        return mapped_row

    def import_from_csv(self, csv_file_path: str, business_name: str = "Default Business") -> Dict:
        """Import products from CSV file"""
        logger.info(f"Starting CSV import from: {csv_file_path}")
        
        try:
            # Get or create business
            business = self.get_or_create_business(business_name)
            
            # Detect CSV delimiter
            with open(csv_file_path, 'r', encoding='utf-8-sig') as file:
                sample = file.read(1024)
                delimiter = ';' if ';' in sample else ','
                logger.info(f"Detected CSV delimiter: '{delimiter}'")
            
            # Open and read CSV
            with open(csv_file_path, 'r', encoding='utf-8-sig') as file:
                csv_reader = csv.DictReader(file, delimiter=delimiter)
                
                for raw_row in csv_reader:
                    # Map columns to expected format
                    mapped_row = self.map_csv_row(raw_row)
                    self.process_row(mapped_row, business)
                    
                    # Commit every 100 rows
                    if self.stats['total_rows'] % 100 == 0:
                        self.db.commit()
                        logger.info(f"Processed {self.stats['total_rows']} rows...")
                
                # Final commit
                self.db.commit()
                
        except Exception as e:
            logger.error(f"Error during CSV import: {e}")
            self.db.rollback()
            self.errors.append(f"Import error: {str(e)}")
            return self.get_import_summary()
        
        logger.info("CSV import completed successfully")
        return self.get_import_summary()
    
    def get_import_summary(self) -> Dict:
        """Get import summary statistics"""
        summary = {
            'statistics': self.stats,
            'skipped_products': self.skipped_products,
            'errors': self.errors,
            'success_rate': round(
                (self.stats['products_created'] / max(self.stats['total_rows'], 1)) * 100, 2
            ) if self.stats['total_rows'] > 0 else 0
        }
        
        return summary
    
    def print_summary(self):
        """Print import summary to console"""
        print("\n" + "="*50)
        print("PRODUCT IMPORT SUMMARY")
        print("="*50)
        print(f"Total rows processed: {self.stats['total_rows']}")
        print(f"Products created: {self.stats['products_created']}")
        print(f"Products skipped: {self.stats['products_skipped']}")
        print(f"Variants created: {self.stats['variants_created']}")
        print(f"Variants skipped: {self.stats['variants_skipped']}")
        print(f"Errors: {self.stats['errors']}")
        
        if self.stats['total_rows'] > 0:
            success_rate = (self.stats['products_created'] / self.stats['total_rows']) * 100
            print(f"Success rate: {success_rate:.2f}%")
        
        if self.skipped_products:
            print(f"\nSkipped products ({len(self.skipped_products)}):")
            for item in self.skipped_products[:10]:  # Show first 10
                print(f"  Row {item['row']}: {item['name']} - {item['reason']}")
            
            if len(self.skipped_products) > 10:
                print(f"  ... and {len(self.skipped_products) - 10} more")
        
        if self.errors:
            print(f"\nErrors ({len(self.errors)}):")
            for error in self.errors[:5]:  # Show first 5
                print(f"  {error}")
            
            if len(self.errors) > 5:
                print(f"  ... and {len(self.errors) - 5} more errors")
        
        print("="*50)


def create_sample_csv():
    """Create a sample CSV file for testing"""
    sample_data = [
        {
            'name': 'Laptop Dell Inspiron',
            'description': 'High-performance laptop for business',
            'sku': 'DELL-INSP-001',
            'barcode': '1234567890123',
            'category': 'Electronics',
            'brand': 'Dell',
            'base_unit': 'piece',
            'minimum_stock': '5',
            'maximum_stock': '50',
            'cost_price': '800.00',
            'selling_price': '1200.00'
        },
        {
            'name': 'Office Chair Ergonomic',
            'description': 'Comfortable ergonomic office chair',
            'sku': 'CHAIR-ERG-001',
            'barcode': '1234567890124',
            'category': 'Furniture',
            'brand': 'Herman Miller',
            'base_unit': 'piece',
            'minimum_stock': '10',
            'maximum_stock': '100',
            'cost_price': '300.00',
            'selling_price': '450.00'
        },
        {
            'name': 'Wireless Mouse',
            'description': 'Wireless optical mouse',
            'sku': 'MOUSE-WRL-001',
            'barcode': '1234567890125',
            'category': 'Electronics',
            'brand': 'Logitech',
            'base_unit': 'piece',
            'minimum_stock': '20',
            'maximum_stock': '200',
            'variant_name': 'Black',
            'variant_sku': 'MOUSE-WRL-001-BLK',
            'variant_attributes': '{"color": "black"}',
            'cost_price': '25.00',
            'selling_price': '40.00'
        }
    ]
    
    with open('sample_products.csv', 'w', newline='', encoding='utf-8') as file:
        writer = csv.DictWriter(file, fieldnames=sample_data[0].keys())
        writer.writeheader()
        writer.writerows(sample_data)
    
    print("Sample CSV file 'sample_products.csv' created successfully!")


def main():
    """Main function to run the import"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Import products from CSV')
    parser.add_argument('csv_file', nargs='?', help='Path to CSV file')
    parser.add_argument('--business', default='Default Business', help='Business name')
    parser.add_argument('--create-sample', action='store_true', help='Create sample CSV file')
    
    args = parser.parse_args()
    
    if args.create_sample:
        create_sample_csv()
        return
    
    if not args.csv_file:
        print("Please provide a CSV file path or use --create-sample to generate a sample file")
        print("Usage: python import_products_csv.py <csv_file> [--business 'Business Name']")
        return
    
    if not os.path.exists(args.csv_file):
        print(f"CSV file not found: {args.csv_file}")
        return
    
    # Get database session
    db_session = next(get_db())
    
    try:
        # Create importer and run import
        importer = ProductImporter(db_session)
        result = importer.import_from_csv(args.csv_file, args.business)
        
        # Print summary
        importer.print_summary()
        
        # Save detailed log
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        log_file = f"import_summary_{timestamp}.json"
        
        import json
        with open(log_file, 'w') as f:
            json.dump(result, f, indent=2, default=str)
        
        print(f"\nDetailed log saved to: {log_file}")
        
    except Exception as e:
        logger.error(f"Import failed: {e}")
        print(f"Import failed: {e}")
    
    finally:
        db_session.close()


if __name__ == "__main__":
    main()
