"""
Script para importar productos desde productos.csv
Adaptado para el formato específico del archivo productos.csv
"""

import csv
import sys
import os
from typing import Dict, List, Optional
from datetime import datetime
import logging

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy.orm import Session
from app.db.database import get_db
from app.models.models import Product, ProductVariant, Business, Category, Brand, Unit

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('import_productos.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


def read_productos_csv():
    """Lee y procesa el archivo productos.csv"""
    print("Iniciando lectura del archivo productos.csv...")
    
    try:
        db_session = next(get_db())
        
        # Obtener o crear business
        business = db_session.query(Business).filter(Business.name == "Maestro Inventario").first()
        if not business:
            business = Business(
                name="Maestro Inventario",
                code="MAESTRO_INVENTARIO",
                rfc="GENERIC123"
            )
            db_session.add(business)
            db_session.flush()
            print(f"✅ Negocio creado: {business.name}")
        
        stats = {
            'total_rows': 0,
            'products_created': 0,
            'products_skipped': 0,
            'errors': 0
        }
        
        skipped_products = []
        errors = []
        
        # Leer archivo CSV
        with open('productos.csv', 'r', encoding='utf-8') as file:
            # Usar ; como delimitador
            csv_reader = csv.reader(file, delimiter=';')
            
            # Leer header
            header = next(csv_reader)
            print(f"Columnas detectadas: {header}")
            
            for row_num, row in enumerate(csv_reader, start=2):
                try:
                    stats['total_rows'] += 1
                    
                    # Verificar que la fila tenga suficientes columnas
                    if len(row) < 3:
                        continue
                    
                    # Extraer datos de la fila
                    producto_nombre = row[0].strip() if row[0] else ""
                    numero_similar = row[1].strip() if len(row) > 1 and row[1] else ""
                    marca = row[2].strip() if len(row) > 2 and row[2] else ""
                    categoria = row[3].strip() if len(row) > 3 and row[3] else ""
                    
                    # Saltar filas vacías o sin nombre de producto
                    if not producto_nombre:
                        continue
                    
                    # Generar SKU basado en el nombre del producto
                    sku = f"PROD-{stats['total_rows']:04d}"
                    
                    # Verificar si el producto ya existe
                    existing_product = db_session.query(Product).filter(
                        (Product.name == producto_nombre) | 
                        (Product.sku == sku)
                    ).first()
                    
                    if existing_product:
                        skipped_products.append({
                            'row': row_num,
                            'name': producto_nombre,
                            'sku': sku,
                            'reason': f'Producto ya existe (ID: {existing_product.id})'
                        })
                        stats['products_skipped'] += 1
                        continue
                    
                    # Obtener o crear categoría
                    category_obj = None
                    if categoria:
                        category_obj = db_session.query(Category).filter(
                            Category.name == categoria,
                            Category.business_id == business.id
                        ).first()
                        
                        if not category_obj:
                            category_obj = Category(
                                business_id=business.id,
                                name=categoria,
                                code=categoria.upper().replace(' ', '_')[:50]
                            )
                            db_session.add(category_obj)
                            db_session.flush()
                    
                    # Obtener o crear marca
                    brand_obj = None
                    if marca:
                        brand_obj = db_session.query(Brand).filter(
                            Brand.name == marca,
                            Brand.business_id == business.id
                        ).first()
                        
                        if not brand_obj:
                            brand_obj = Brand(
                                business_id=business.id,
                                name=marca,
                                code=marca.upper().replace(' ', '_')[:50]
                            )
                            db_session.add(brand_obj)
                            db_session.flush()
                    
                    # Obtener unidad base por defecto
                    base_unit = db_session.query(Unit).filter(Unit.name == "pieza").first()
                    if not base_unit:
                        base_unit = db_session.query(Unit).first()  # Tomar cualquier unidad disponible
                    
                    # Crear producto
                    product = Product(
                        business_id=business.id,
                        name=producto_nombre,
                        description=f"Número similar: {numero_similar}" if numero_similar else "",
                        sku=sku,
                        category_id=category_obj.id if category_obj else None,
                        brand_id=brand_obj.id if brand_obj else None,
                        base_unit_id=base_unit.id if base_unit else None,
                        minimum_stock=0,
                        is_active=True
                    )
                    
                    db_session.add(product)
                    stats['products_created'] += 1
                    
                    # Log cada 100 productos procesados
                    if stats['total_rows'] % 100 == 0:
                        db_session.commit()
                        print(f"Procesadas {stats['total_rows']} filas... Creados: {stats['products_created']}, Omitidos: {stats['products_skipped']}")
                    
                except Exception as e:
                    error_msg = f"Fila {row_num}: Error procesando producto - {str(e)}"
                    errors.append(error_msg)
                    stats['errors'] += 1
                    logger.error(error_msg)
                    continue
        
        # Commit final
        db_session.commit()
        
        # Mostrar resumen
        print("\n" + "="*60)
        print("RESUMEN DE IMPORTACIÓN DE PRODUCTOS")
        print("="*60)
        print(f"Total de filas procesadas: {stats['total_rows']}")
        print(f"Productos creados: {stats['products_created']}")
        print(f"Productos omitidos: {stats['products_skipped']}")
        print(f"Errores: {stats['errors']}")
        
        if stats['total_rows'] > 0:
            success_rate = (stats['products_created'] / stats['total_rows']) * 100
            print(f"Tasa de éxito: {success_rate:.2f}%")
        
        # Mostrar algunos productos omitidos
        if skipped_products:
            print(f"\nPrimeros productos omitidos ({min(5, len(skipped_products))}):")
            for item in skipped_products[:5]:
                print(f"  Fila {item['row']}: {item['name']} - {item['reason']}")
            
            if len(skipped_products) > 5:
                print(f"  ... y {len(skipped_products) - 5} más")
        
        # Mostrar algunos errores
        if errors:
            print(f"\nPrimeros errores ({min(3, len(errors))}):")
            for error in errors[:3]:
                print(f"  {error}")
            
            if len(errors) > 3:
                print(f"  ... y {len(errors) - 3} más errores")
        
        print("="*60)
        
        # Guardar resumen detallado
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        summary_file = f"resumen_importacion_{timestamp}.txt"
        
        with open(summary_file, 'w', encoding='utf-8') as f:
            f.write("RESUMEN DETALLADO DE IMPORTACIÓN\n")
            f.write("="*50 + "\n")
            f.write(f"Fecha: {datetime.now()}\n")
            f.write(f"Archivo: productos.csv\n")
            f.write(f"Total filas: {stats['total_rows']}\n")
            f.write(f"Productos creados: {stats['products_created']}\n")
            f.write(f"Productos omitidos: {stats['products_skipped']}\n")
            f.write(f"Errores: {stats['errors']}\n\n")
            
            if skipped_products:
                f.write("PRODUCTOS OMITIDOS:\n")
                for item in skipped_products:
                    f.write(f"Fila {item['row']}: {item['name']} - {item['reason']}\n")
                f.write("\n")
            
            if errors:
                f.write("ERRORES:\n")
                for error in errors:
                    f.write(f"{error}\n")
        
        print(f"\n✅ Resumen detallado guardado en: {summary_file}")
        print("✅ Importación completada exitosamente!")
        
    except Exception as e:
        logger.error(f"Error durante la importación: {e}")
        print(f"❌ Error durante la importación: {e}")
        if 'db_session' in locals():
            db_session.rollback()
    
    finally:
        if 'db_session' in locals():
            db_session.close()


if __name__ == "__main__":
    read_productos_csv()
