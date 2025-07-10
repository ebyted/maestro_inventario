"""
Script para inicializar la base de datos con datos por defecto
"""
from sqlalchemy.orm import Session
from app.db.database import SessionLocal, engine
from app.models.models import (
    Base, User, Business, BusinessUser, Category, Brand, Warehouse, Unit, 
    UserRole, Supplier, PaymentTerms, Product, ProductVariant, SupplierProduct
)
from app.core.security import get_password_hash
from datetime import datetime

def init_db():
    """Inicializar base de datos con datos por defecto"""
    
    # Crear tablas (solo para desarrollo, comentar en producción)
    # Base.metadata.create_all(bind=engine)
    
    db = SessionLocal()
    
    try:
        # Verificar si ya hay datos
        if db.query(User).first():
            print("✅ Base de datos ya inicializada")
            return
        
        print("🔄 Inicializando base de datos...")
        
        # 1. Crear usuario administrador
        admin_user = User(
            email="admin@maestro.com",
            password_hash=get_password_hash("123456"),
            first_name="Admin",
            last_name="Maestro",
            is_active=True,
            is_superuser=True
        )
        db.add(admin_user)
        db.commit()
        db.refresh(admin_user)
        print(f"✅ Usuario administrador creado: {admin_user.email}")
        
        # 2. Crear negocio por defecto
        business = Business(
            name="Mi Negocio Principal",
            description="Negocio principal del sistema de inventario",
            code="NEG001",
            tax_id="123456789",
            address="Dirección de ejemplo",
            phone="123-456-7890",
            email="negocio@maestro.com",
            is_active=True
        )
        db.add(business)
        db.commit()
        db.refresh(business)
        print(f"✅ Negocio creado: {business.name}")
        
        # 3. Relacionar usuario con negocio
        business_user = BusinessUser(
            business_id=business.id,
            user_id=admin_user.id,
            role=UserRole.ADMIN,
            is_active=True
        )
        db.add(business_user)
        db.commit()
        print("✅ Usuario relacionado con negocio")
        
        # 4. Crear unidades de medida
        units = [
            {"name": "Unidad", "symbol": "UND", "unit_type": "count", "conversion_factor": 1.0},
            {"name": "Kilogramo", "symbol": "KG", "unit_type": "weight", "conversion_factor": 1000.0},
            {"name": "Metro", "symbol": "M", "unit_type": "length", "conversion_factor": 100.0},
            {"name": "Litro", "symbol": "L", "unit_type": "volume", "conversion_factor": 1000.0},
            {"name": "Par", "symbol": "PAR", "unit_type": "count", "conversion_factor": 1.0},
            {"name": "Caja", "symbol": "CAJ", "unit_type": "package", "conversion_factor": 1.0},
        ]
        
        for unit_data in units:
            unit = Unit(**unit_data)
            db.add(unit)
        
        db.commit()
        print(f"✅ Unidades de medida creadas: {len(units)}")
        
        # 5. Crear categorías
        categories = [
            {"name": "Electrónicos", "description": "Dispositivos electrónicos y tecnología", "code": "ELEC"},
            {"name": "Smartphones", "description": "Teléfonos inteligentes", "code": "PHONE"},
            {"name": "Ropa", "description": "Prendas de vestir", "code": "CLOTH"},
            {"name": "Calzado", "description": "Zapatos y sandalias", "code": "SHOES"},
            {"name": "Alimentos", "description": "Productos alimenticios", "code": "FOOD"},
            {"name": "Bebidas", "description": "Bebidas y líquidos", "code": "DRINKS"},
            {"name": "Hogar", "description": "Artículos para el hogar", "code": "HOME"},
        ]
        
        for cat_data in categories:
            category = Category(
                business_id=business.id,
                **cat_data
            )
            db.add(category)
        
        db.commit()
        print(f"✅ Categorías creadas: {len(categories)}")
        
        # 6. Crear marcas
        brands = [
            {"name": "Samsung", "description": "Marca surcoreana de tecnología", "code": "SAMSUNG", "country": "Corea del Sur"},
            {"name": "Apple", "description": "Marca estadounidense de tecnología", "code": "APPLE", "country": "Estados Unidos"},
            {"name": "Nike", "description": "Marca de ropa deportiva", "code": "NIKE", "country": "Estados Unidos"},
            {"name": "Adidas", "description": "Marca alemana de ropa deportiva", "code": "ADIDAS", "country": "Alemania"},
            {"name": "Coca-Cola", "description": "Marca de bebidas", "code": "COCACOLA", "country": "Estados Unidos"},
            {"name": "Generic", "description": "Marca genérica", "code": "GENERIC", "country": "Global"},
        ]
        
        for brand_data in brands:
            brand = Brand(
                business_id=business.id,
                **brand_data
            )
            db.add(brand)
        
        db.commit()
        print(f"✅ Marcas creadas: {len(brands)}")
        
        # 7. Crear almacenes
        warehouses = [
            {"name": "Almacén Principal", "description": "Almacén principal del negocio", "code": "ALM001", "address": "Dirección almacén principal"},
            {"name": "Almacén Secundario", "description": "Almacén secundario", "code": "ALM002", "address": "Dirección almacén secundario"},
            {"name": "Tienda", "description": "Almacén de la tienda", "code": "TIENDA", "address": "Dirección de la tienda"},
        ]
        
        for wh_data in warehouses:
            warehouse = Warehouse(
                business_id=business.id,
                **wh_data
            )
            db.add(warehouse)
        
        db.commit()
        print(f"✅ Almacenes creados: {len(warehouses)}")
        
        # 8. Crear proveedores
        suppliers = [
            {
                "name": "Proveedor Tecnología S.A.",
                "company_name": "Proveedor Tecnología S.A. de C.V.",
                "tax_id": "PTE123456789",
                "email": "ventas@provtech.com",
                "phone": "555-0101",
                "mobile": "555-0102",
                "website": "www.provtech.com",
                "address": "Av. Tecnología 123, Ciudad de México",
                "city": "Ciudad de México",
                "state": "CDMX",
                "postal_code": "01000",
                "country": "México",
                "payment_terms": PaymentTerms.NET_30,
                "credit_limit": 100000.0,
                "discount_percentage": 5.0,
                "contact_person": "Juan Pérez",
                "contact_title": "Gerente de Ventas",
                "contact_email": "juan.perez@provtech.com",
                "contact_phone": "555-0103",
                "notes": "Proveedor especializado en productos tecnológicos"
            },
            {
                "name": "Distribuidora Deportiva",
                "company_name": "Distribuidora Deportiva del Norte S.A.",
                "tax_id": "DDN987654321",
                "email": "contacto@distdeportiva.com",
                "phone": "555-0201",
                "mobile": "555-0202",
                "address": "Blvd. Deportivo 456, Monterrey",
                "city": "Monterrey",
                "state": "Nuevo León",
                "postal_code": "64000",
                "country": "México",
                "payment_terms": PaymentTerms.NET_15,
                "credit_limit": 75000.0,
                "discount_percentage": 3.0,
                "contact_person": "María González",
                "contact_title": "Coordinadora de Ventas",
                "contact_email": "maria.gonzalez@distdeportiva.com",
                "contact_phone": "555-0203",
                "notes": "Especializada en artículos deportivos y ropa"
            },
            {
                "name": "Bebidas y Más",
                "company_name": "Bebidas y Más Distribuidora",
                "tax_id": "BYM456789123",
                "email": "pedidos@bebidasmas.com",
                "phone": "555-0301",
                "address": "Calle Bebidas 789, Guadalajara",
                "city": "Guadalajara",
                "state": "Jalisco",
                "postal_code": "44100",
                "country": "México",
                "payment_terms": PaymentTerms.NET_30,
                "credit_limit": 50000.0,
                "discount_percentage": 2.0,
                "contact_person": "Carlos López",
                "contact_title": "Ejecutivo de Ventas",
                "contact_email": "carlos.lopez@bebidasmas.com",
                "contact_phone": "555-0302",
                "notes": "Distribuidora de bebidas y productos de consumo"
            }
        ]
        
        created_suppliers = []
        for supplier_data in suppliers:
            supplier = Supplier(
                business_id=business.id,
                **supplier_data
            )
            db.add(supplier)
            created_suppliers.append(supplier)
        
        db.commit()
        print(f"✅ Proveedores creados: {len(suppliers)}")
        
        # 9. Crear productos de ejemplo con variantes
        
        # Obtener las primeras categorías, marcas y unidades creadas
        electronics_category = db.query(Category).filter_by(name="Electrónicos").first()
        clothing_category = db.query(Category).filter_by(name="Ropa").first()
        food_category = db.query(Category).filter_by(name="Alimentos").first()
        
        samsung_brand = db.query(Brand).filter_by(name="Samsung").first()
        apple_brand = db.query(Brand).filter_by(name="Apple").first()
        nike_brand = db.query(Brand).filter_by(name="Nike").first()
        
        unit_piece = db.query(Unit).filter_by(symbol="pza").first()
        
        products_data = [
            {
                "name": "Smartphone Galaxy",
                "description": "Smartphone Samsung Galaxy con 128GB de almacenamiento",
                "sku": "SAMS-GAL-128",
                "barcode": "1234567890123",
                "category_id": electronics_category.id if electronics_category else None,
                "brand_id": samsung_brand.id if samsung_brand else None,
                "base_unit_id": unit_piece.id if unit_piece else None,
                "minimum_stock": 5.0,
                "maximum_stock": 50.0,
                "variants": [
                    {
                        "name": "Galaxy S21 128GB Negro",
                        "sku": "SAMS-GAL-S21-128-BLK",
                        "barcode": "1234567890124",
                        "attributes": '{"color": "Negro", "storage": "128GB", "model": "Galaxy S21"}',
                        "cost_price": 8000.0,
                        "selling_price": 12000.0
                    },
                    {
                        "name": "Galaxy S21 256GB Blanco",
                        "sku": "SAMS-GAL-S21-256-WHT",
                        "barcode": "1234567890125",
                        "attributes": '{"color": "Blanco", "storage": "256GB", "model": "Galaxy S21"}',
                        "cost_price": 9000.0,
                        "selling_price": 13500.0
                    }
                ]
            },
            {
                "name": "iPhone",
                "description": "iPhone Apple con diferentes capacidades de almacenamiento",
                "sku": "APPL-IPH",
                "barcode": "2345678901234",
                "category_id": electronics_category.id if electronics_category else None,
                "brand_id": apple_brand.id if apple_brand else None,
                "base_unit_id": unit_piece.id if unit_piece else None,
                "minimum_stock": 3.0,
                "maximum_stock": 30.0,
                "variants": [
                    {
                        "name": "iPhone 14 128GB Azul",
                        "sku": "APPL-IPH-14-128-BLU",
                        "barcode": "2345678901235",
                        "attributes": '{"color": "Azul", "storage": "128GB", "model": "iPhone 14"}',
                        "cost_price": 15000.0,
                        "selling_price": 22000.0
                    }
                ]
            },
            {
                "name": "Tenis Deportivos",
                "description": "Tenis deportivos Nike para correr",
                "sku": "NIKE-RUN",
                "barcode": "3456789012345",
                "category_id": clothing_category.id if clothing_category else None,
                "brand_id": nike_brand.id if nike_brand else None,
                "base_unit_id": unit_piece.id if unit_piece else None,
                "minimum_stock": 10.0,
                "maximum_stock": 100.0,
                "variants": [
                    {
                        "name": "Nike Air Max 42 Negro",
                        "sku": "NIKE-AIR-42-BLK",
                        "barcode": "3456789012346",
                        "attributes": '{"size": "42", "color": "Negro", "model": "Air Max"}',
                        "cost_price": 1200.0,
                        "selling_price": 2000.0
                    },
                    {
                        "name": "Nike Air Max 43 Blanco",
                        "sku": "NIKE-AIR-43-WHT",
                        "barcode": "3456789012347",
                        "attributes": '{"size": "43", "color": "Blanco", "model": "Air Max"}',
                        "cost_price": 1200.0,
                        "selling_price": 2000.0
                    }
                ]
            }
        ]
        
        created_product_variants = []
        for product_data in products_data:
            variants_data = product_data.pop("variants", [])
            
            product = Product(
                business_id=business.id,
                **product_data
            )
            db.add(product)
            db.flush()  # Para obtener el ID del producto
            
            # Crear variantes del producto
            for variant_data in variants_data:
                variant = ProductVariant(
                    product_id=product.id,
                    **variant_data
                )
                db.add(variant)
                created_product_variants.append(variant)
        
        db.commit()
        print(f"✅ Productos creados: {len(products_data)}")
        print(f"✅ Variantes de productos creadas: {len(created_product_variants)}")
        
        # 10. Crear relaciones proveedor-producto
        
        # Asociar productos con proveedores
        supplier_products = [
            {
                "supplier": created_suppliers[0],  # Proveedor Tecnología
                "variant_sku": "SAMS-GAL-S21-128-BLK",
                "supplier_sku": "PROV-SAMS-001",
                "supplier_product_name": "Samsung Galaxy S21 128GB Negro",
                "cost_price": 7500.0,
                "minimum_order_quantity": 5.0,
                "lead_time_days": 7,
                "is_preferred": True
            },
            {
                "supplier": created_suppliers[0],  # Proveedor Tecnología
                "variant_sku": "APPL-IPH-14-128-BLU",
                "supplier_sku": "PROV-APPL-001",
                "supplier_product_name": "iPhone 14 128GB Azul",
                "cost_price": 14500.0,
                "minimum_order_quantity": 2.0,
                "lead_time_days": 10,
                "is_preferred": True
            },
            {
                "supplier": created_suppliers[1],  # Distribuidora Deportiva
                "variant_sku": "NIKE-AIR-42-BLK",
                "supplier_sku": "DIST-NIKE-001",
                "supplier_product_name": "Nike Air Max 42 Negro",
                "cost_price": 1100.0,
                "minimum_order_quantity": 10.0,
                "lead_time_days": 5,
                "is_preferred": True
            }
        ]
        
        for sp_data in supplier_products:
            # Buscar la variante del producto por SKU
            variant = db.query(ProductVariant).filter_by(sku=sp_data["variant_sku"]).first()
            if variant:
                supplier_product = SupplierProduct(
                    supplier_id=sp_data["supplier"].id,
                    product_variant_id=variant.id,
                    supplier_sku=sp_data["supplier_sku"],
                    supplier_product_name=sp_data["supplier_product_name"],
                    cost_price=sp_data["cost_price"],
                    minimum_order_quantity=sp_data["minimum_order_quantity"],
                    lead_time_days=sp_data["lead_time_days"],
                    is_preferred=sp_data["is_preferred"]
                )
                db.add(supplier_product)
        
        db.commit()
        print(f"✅ Relaciones proveedor-producto creadas: {len(supplier_products)}")
        
        print("\n🎉 Base de datos inicializada exitosamente!")
        print("\n📝 Credenciales de acceso:")
        print(f"   📧 Email: {admin_user.email}")
        print(f"   🔑 Password: 123456")
        print(f"\n🏢 Negocio: {business.name}")
        print(f"📦 Almacenes: {len(warehouses)}")
        print(f"🏷️ Categorías: {len(categories)}")
        print(f"🔖 Marcas: {len(brands)}")
        print(f"📏 Unidades: {len(units)}")
        print(f"🏭 Proveedores: {len(suppliers)}")
        print(f"📱 Productos: {len(products_data)}")
        print(f"🎯 Variantes de productos: {len(created_product_variants)}")
        print(f"🔗 Relaciones proveedor-producto: {len(supplier_products)}")
        print("\n🚀 Sistema listo para usar!")
        
    except Exception as e:
        print(f"❌ Error inicializando base de datos: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    init_db()
