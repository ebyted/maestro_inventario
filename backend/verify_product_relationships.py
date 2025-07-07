"""
Script de verificación de relaciones entre productos, categorías y marcas
Verifica que los productos importados estén correctamente ligados a sus categorías y marcas
"""

import sys
import os
from typing import List, Dict
from datetime import datetime

# Add the backend directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy.orm import Session
from sqlalchemy import func
from app.db.database import get_db
from app.models.models import Product, Category, Brand, Business

def verify_product_relationships(db: Session) -> Dict:
    """Verificar las relaciones de productos con categorías y marcas"""
    
    print("VERIFICACIÓN DE RELACIONES PRODUCTO-CATEGORÍA-MARCA")
    print("="*60)
    
    # Estadísticas generales
    total_products = db.query(Product).count()
    products_with_category = db.query(Product).filter(Product.category_id.isnot(None)).count()
    products_with_brand = db.query(Product).filter(Product.brand_id.isnot(None)).count()
    products_with_both = db.query(Product).filter(
        Product.category_id.isnot(None),
        Product.brand_id.isnot(None)
    ).count()
    
    print(f"Total de productos: {total_products}")
    print(f"Productos con categoría: {products_with_category} ({(products_with_category/total_products*100):.1f}%)")
    print(f"Productos con marca: {products_with_brand} ({(products_with_brand/total_products*100):.1f}%)")
    print(f"Productos con ambos: {products_with_both} ({(products_with_both/total_products*100):.1f}%)")
    print()
    
    # Productos sin categoría
    products_without_category = db.query(Product).filter(Product.category_id.is_(None)).all()
    if products_without_category:
        print(f"PRODUCTOS SIN CATEGORÍA ({len(products_without_category)}):")
        for product in products_without_category[:10]:  # Mostrar primeros 10
            print(f"  - {product.name} (SKU: {product.sku})")
        if len(products_without_category) > 10:
            print(f"  ... y {len(products_without_category) - 10} más")
        print()
    
    # Productos sin marca
    products_without_brand = db.query(Product).filter(Product.brand_id.is_(None)).all()
    if products_without_brand:
        print(f"PRODUCTOS SIN MARCA ({len(products_without_brand)}):")
        for product in products_without_brand[:10]:  # Mostrar primeros 10
            print(f"  - {product.name} (SKU: {product.sku})")
        if len(products_without_brand) > 10:
            print(f"  ... y {len(products_without_brand) - 10} más")
        print()
    
    # Top 10 categorías con más productos
    category_counts = db.query(
        Category.name,
        func.count(Product.id).label('product_count')
    ).join(Product).group_by(Category.id, Category.name).order_by(
        func.count(Product.id).desc()
    ).limit(10).all()
    
    if category_counts:
        print("TOP 10 CATEGORÍAS CON MÁS PRODUCTOS:")
        for i, (category_name, count) in enumerate(category_counts, 1):
            print(f"  {i:2}. {category_name:<30} ({count} productos)")
        print()
    
    # Top 10 marcas con más productos
    brand_counts = db.query(
        Brand.name,
        func.count(Product.id).label('product_count')
    ).join(Product).group_by(Brand.id, Brand.name).order_by(
        func.count(Product.id).desc()
    ).limit(10).all()
    
    if brand_counts:
        print("TOP 10 MARCAS CON MÁS PRODUCTOS:")
        for i, (brand_name, count) in enumerate(brand_counts, 1):
            print(f"  {i:2}. {brand_name:<30} ({count} productos)")
        print()
    
    # Ejemplos de productos con relaciones completas
    products_with_relations = db.query(Product).join(Category).join(Brand).limit(10).all()
    if products_with_relations:
        print("EJEMPLOS DE PRODUCTOS CON RELACIONES COMPLETAS:")
        for product in products_with_relations:
            print(f"  - {product.name}")
            print(f"    SKU: {product.sku}")
            print(f"    Categoría: {product.category.name if product.category else 'N/A'}")
            print(f"    Marca: {product.brand.name if product.brand else 'N/A'}")
            print()
    
    return {
        'total_products': total_products,
        'products_with_category': products_with_category,
        'products_with_brand': products_with_brand,
        'products_with_both': products_with_both,
        'products_without_category': len(products_without_category),
        'products_without_brand': len(products_without_brand),
        'category_counts': category_counts,
        'brand_counts': brand_counts
    }

def check_specific_products(db: Session, product_names: List[str] = None):
    """Verificar productos específicos y sus relaciones"""
    if not product_names:
        # Tomar algunos productos de muestra
        sample_products = db.query(Product).limit(5).all()
        product_names = [p.name for p in sample_products]
    
    print("VERIFICACIÓN DE PRODUCTOS ESPECÍFICOS:")
    print("-" * 40)
    
    for product_name in product_names:
        product = db.query(Product).filter(Product.name.ilike(f"%{product_name}%")).first()
        if product:
            print(f"Producto: {product.name}")
            print(f"  ID: {product.id}")
            print(f"  SKU: {product.sku}")
            print(f"  Business ID: {product.business_id}")
            print(f"  Category ID: {product.category_id}")
            if product.category:
                print(f"  Categoría: {product.category.name}")
            print(f"  Brand ID: {product.brand_id}")
            if product.brand:
                print(f"  Marca: {product.brand.name}")
            print()
        else:
            print(f"No se encontró producto: {product_name}")
            print()

def check_orphan_categories_brands(db: Session):
    """Verificar categorías y marcas huérfanas (sin productos)"""
    print("CATEGORÍAS Y MARCAS HUÉRFANAS:")
    print("-" * 40)
    
    # Categorías sin productos
    orphan_categories = db.query(Category).outerjoin(Product).filter(Product.id.is_(None)).all()
    if orphan_categories:
        print(f"Categorías sin productos ({len(orphan_categories)}):")
        for cat in orphan_categories[:10]:
            print(f"  - {cat.name} (ID: {cat.id})")
        if len(orphan_categories) > 10:
            print(f"  ... y {len(orphan_categories) - 10} más")
    else:
        print("✅ Todas las categorías tienen productos asignados")
    print()
    
    # Marcas sin productos
    orphan_brands = db.query(Brand).outerjoin(Product).filter(Product.id.is_(None)).all()
    if orphan_brands:
        print(f"Marcas sin productos ({len(orphan_brands)}):")
        for brand in orphan_brands[:10]:
            print(f"  - {brand.name} (ID: {brand.id})")
        if len(orphan_brands) > 10:
            print(f"  ... y {len(orphan_brands) - 10} más")
    else:
        print("✅ Todas las marcas tienen productos asignados")
    print()

def main():
    """Función principal"""
    print(f"Iniciando verificación de relaciones - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print()
    
    # Obtener sesión de base de datos
    db_session = next(get_db())
    
    try:
        # Verificar relaciones generales
        stats = verify_product_relationships(db_session)
        
        # Verificar productos específicos
        check_specific_products(db_session)
        
        # Verificar categorías y marcas huérfanas
        check_orphan_categories_brands(db_session)
        
        print("="*60)
        print("RESUMEN FINAL:")
        print(f"✅ Verificación completada")
        print(f"📊 {stats['total_products']} productos verificados")
        print(f"🏷️  {stats['products_with_category']} productos con categoría")
        print(f"🏭  {stats['products_with_brand']} productos con marca")
        print(f"✅  {stats['products_with_both']} productos con ambos")
        
        if stats['products_without_category'] > 0 or stats['products_without_brand'] > 0:
            print(f"⚠️  Productos incompletos encontrados")
        else:
            print(f"✅  Todos los productos tienen relaciones completas")
        
    except Exception as e:
        print(f"❌ Error durante la verificación: {e}")
    
    finally:
        db_session.close()

if __name__ == "__main__":
    main()
