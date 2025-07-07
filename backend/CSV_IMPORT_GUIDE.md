# CSV Product Import Documentation

## Overview

The `import_products_csv.py` script allows you to import products from a CSV file into the Maestro Inventario system with built-in duplicate detection. The script will automatically check if products already exist and skip them to avoid duplicates.

## Features

- ✅ **Duplicate Detection**: Checks for existing products by SKU, barcode, and name
- ✅ **Variant Support**: Creates product variants with separate SKUs
- ✅ **Category/Brand Creation**: Automatically creates categories and brands if they don't exist
- ✅ **Error Handling**: Comprehensive error logging and reporting
- ✅ **Progress Tracking**: Real-time progress updates during import
- ✅ **Detailed Reporting**: Summary statistics and skipped items report

## CSV Format

The CSV file should have the following columns:

### Required Columns
- `name`: Product name (required)

### Optional Columns
- `description`: Product description
- `sku`: Product SKU (used for duplicate detection)
- `barcode`: Product barcode (used for duplicate detection)
- `category`: Category name (will be created if doesn't exist)
- `brand`: Brand name (will be created if doesn't exist)
- `base_unit`: Base unit of measure (must exist in system)
- `minimum_stock`: Minimum stock level (default: 0)
- `maximum_stock`: Maximum stock level
- `cost_price`: Product cost price
- `selling_price`: Product selling price

### Variant Columns (Optional)
- `variant_name`: Variant name
- `variant_sku`: Variant SKU (used for duplicate detection)
- `variant_barcode`: Variant barcode
- `variant_attributes`: JSON string with variant attributes (e.g., '{"color": "red", "size": "L"}')

## Usage

### 1. Create Sample CSV File
```bash
python import_products_csv.py --create-sample
```
This creates a `sample_products.csv` file with example data.

### 2. Import Products from CSV
```bash
python import_products_csv.py path/to/your/products.csv
```

### 3. Import with Custom Business Name
```bash
python import_products_csv.py path/to/your/products.csv --business "My Business"
```

## Example CSV Content

```csv
name,description,sku,barcode,category,brand,base_unit,minimum_stock,maximum_stock,cost_price,selling_price
Laptop Dell Inspiron,High-performance laptop for business,DELL-INSP-001,1234567890123,Electronics,Dell,piece,5,50,800.00,1200.00
Office Chair Ergonomic,Comfortable ergonomic office chair,CHAIR-ERG-001,1234567890124,Furniture,Herman Miller,piece,10,100,300.00,450.00
Wireless Mouse,Wireless optical mouse,MOUSE-WRL-001,1234567890125,Electronics,Logitech,piece,20,200,25.00,40.00
```

## Duplicate Detection Logic

The script checks for existing products in the following order:

1. **By SKU**: Most reliable identifier
2. **By Barcode**: Secondary identifier
3. **By Name**: Least reliable (partial matching)

If any of these matches are found, the product is skipped and logged.

## Output and Logging

### Console Output
- Real-time progress updates
- Summary statistics at the end
- List of skipped products
- Error messages

### Log Files
- `import_products.log`: Detailed processing log
- `import_summary_YYYYMMDD_HHMMSS.json`: Complete import summary with statistics

### Sample Summary Output
```
==================================================
PRODUCT IMPORT SUMMARY
==================================================
Total rows processed: 3
Products created: 2
Products skipped: 1
Variants created: 1
Variants skipped: 0
Errors: 0
Success rate: 66.67%

Skipped products (1):
  Row 3: Wireless Mouse - Product already exists (ID: 123)
==================================================
```

## Error Handling

The script handles various error scenarios:

- **Missing required fields**: Logs error and continues with next row
- **Invalid data types**: Logs error and uses default values
- **Database constraints**: Rolls back and logs error
- **File not found**: Exits with error message
- **Invalid CSV format**: Logs parsing errors

## Testing

Run the test script to verify functionality:

```bash
python test_import_csv.py
```

This will:
1. Create a sample CSV file
2. Import it twice to test duplicate detection
3. Show summary of both imports

## Best Practices

1. **Backup Database**: Always backup your database before large imports
2. **Test with Sample**: Use the sample CSV to test before importing real data
3. **Unique SKUs**: Ensure SKUs are unique to avoid confusion
4. **Validate Data**: Review the CSV file for data quality before import
5. **Monitor Logs**: Check log files for any issues during import

## Troubleshooting

### Common Issues

1. **"Unit not found" warnings**
   - Ensure base_unit values match existing units in the system
   - Common units: piece, kg, liter, meter

2. **High number of skipped products**
   - Check if products were previously imported
   - Verify SKU/barcode uniqueness in your CSV

3. **Import fails with database errors**
   - Check database connection
   - Ensure proper permissions
   - Verify database schema is up to date

### Debugging

Enable debug logging by modifying the script:
```python
logging.basicConfig(level=logging.DEBUG)
```

## Integration

The script can be integrated into automated workflows:

```python
from import_products_csv import ProductImporter
from app.db.database import get_db

def automated_import(csv_path, business_name):
    db_session = next(get_db())
    try:
        importer = ProductImporter(db_session)
        result = importer.import_from_csv(csv_path, business_name)
        return result
    finally:
        db_session.close()
```
