#!/usr/bin/env python3
"""
Script para poblar la base de datos con datos de ejemplo
"""
import sys
import os

# Agregar el directorio padre al path para importar los módulos
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy.orm import sessionmaker
from app.db.database import engine
from app.models.models import *
from app.core.security import get_password_hash
from datetime import datetime, timedelta
import random

# Crear sesión
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()

def create_sample_data():
    """Crear datos de ejemplo en la base de datos"""
    
    print("🚀 Iniciando creación de datos de ejemplo...")
    
    # 1. Crear unidades de medida
    print("📏 Creando unidades de medida...")
    units = [
        Unit(name="Kilogramo", symbol="kg", unit_type="weight"),
        Unit(name="Gramo", symbol="g", unit_type="weight", conversion_factor=0.001),
        Unit(name="Litro", symbol="L", unit_type="volume"),
        Unit(name="Mililitro", symbol="ml", unit_type="volume", conversion_factor=0.001),
        Unit(name="Metro", symbol="m", unit_type="length"),
        Unit(name="Centímetro", symbol="cm", unit_type="length", conversion_factor=0.01),
        Unit(name="Pieza", symbol="pza", unit_type="count"),
        Unit(name="Caja", symbol="caja", unit_type="count"),
        Unit(name="Paquete", symbol="paq", unit_type="count"),
    ]
    
    for unit in units:
        db.add(unit)
    db.commit()
    
    # 2. Crear usuarios
    print("👥 Creando usuarios...")
    users = [
        User(
            email="admin@maestroinventario.com",
            password_hash=get_password_hash("admin123"),
            first_name="Administrador",
            last_name="Sistema",
            role=UserRole.ADMIN,
            is_superuser=True
        ),
        User(
            email="manager@maestroinventario.com",
            password_hash=get_password_hash("manager123"),
            first_name="Maria",
            last_name="Gonzalez",
            role=UserRole.MANAGER
        ),
        User(
            email="employee@maestroinventario.com",
            password_hash=get_password_hash("employee123"),
            first_name="Juan",
            last_name="Perez",
            role=UserRole.EMPLOYEE
        ),
    ]
    
    for user in users:
        db.add(user)
    db.commit()
    
    # 3. Crear negocio
    print("🏢 Creando negocio...")
    business = Business(
        name="Tienda Maestro",
        description="Tienda de abarrotes y productos diversos",
        code="TM001",
        tax_id="RFC123456789",
        address="Av. Principal 123, Ciudad, Estado",
        phone="555-0123",
        email="info@maestroinventario.com"
    )
    db.add(business)
    db.commit()
    
    # 4. Crear relaciones usuario-negocio
    print("🔗 Creando relaciones usuario-negocio...")
    business_users = [
        BusinessUser(business_id=business.id, user_id=users[0].id, role=UserRole.ADMIN),
        BusinessUser(business_id=business.id, user_id=users[1].id, role=UserRole.MANAGER),
        BusinessUser(business_id=business.id, user_id=users[2].id, role=UserRole.EMPLOYEE),
    ]
    
    for bu in business_users:
        db.add(bu)
    db.commit()
    
    # 5. Crear categorías
    print("🏷️ Creando categorías...")
    categories = [
        Category(business_id=business.id, name="Abarrotes", description="Productos básicos de despensa", code="ABR"),
        Category(business_id=business.id, name="Bebidas", description="Bebidas alcohólicas y no alcohólicas", code="BEB"),
        Category(business_id=business.id, name="Lácteos", description="Productos lácteos y derivados", code="LAC"),
        Category(business_id=business.id, name="Carnes", description="Carnes rojas, blancas y embutidos", code="CAR"),
        Category(business_id=business.id, name="Frutas y Verduras", description="Productos frescos", code="FYV"),
        Category(business_id=business.id, name="Limpieza", description="Productos de limpieza e higiene", code="LIM"),
    ]
    
    for category in categories:
        db.add(category)
    db.commit()
    
    # 6. Crear marcas
    print("🏷️ Creando marcas...")
    brands = [
        Brand(business_id=business.id, name="Coca-Cola", description="Bebidas refrescantes", code="CC", country="México"),
        Brand(business_id=business.id, name="Bimbo", description="Productos de panadería", code="BIM", country="México"),
        Brand(business_id=business.id, name="Nestlé", description="Alimentos y bebidas", code="NES", country="Suiza"),
        Brand(business_id=business.id, name="Lala", description="Productos lácteos", code="LAL", country="México"),
        Brand(business_id=business.id, name="Maseca", description="Harinas y tortillas", code="MAS", country="México"),
        Brand(business_id=business.id, name="Fabuloso", description="Productos de limpieza", code="FAB", country="México"),
    ]
    
    for brand in brands:
        db.add(brand)
    db.commit()
    
    # 7. Crear almacenes
    print("🏬 Creando almacenes...")
    warehouses = [
        Warehouse(
            business_id=business.id,
            name="Almacén Principal",
            description="Almacén principal de la tienda",
            code="AP001",
            address="Av. Principal 123, Bodega A"
        ),
        Warehouse(
            business_id=business.id,
            name="Almacén Secundario",
            description="Almacén para productos no perecederos",
            code="AS001",
            address="Calle Secundaria 456, Bodega B"
        ),
    ]
    
    for warehouse in warehouses:
        db.add(warehouse)
    db.commit()
    
    # 8. Crear proveedores
    print("🚚 Creando proveedores...")
    suppliers = [
        Supplier(
            business_id=business.id,
            name="Distribuidora Central",
            company_name="Distribuidora Central S.A. de C.V.",
            tax_id="DCE120415AB1",
            email="ventas@distcentral.com",
            phone="555-1001",
            address="Zona Industrial Norte 100",
            city="Ciudad",
            payment_terms=PaymentTerms.NET_30,
            credit_limit=50000.0,
            contact_person="Roberto Martinez",
            contact_email="roberto@distcentral.com"
        ),
        Supplier(
            business_id=business.id,
            name="Comercializadora del Valle",
            company_name="Comercializadora del Valle S.A.",
            tax_id="CDV091205XY2",
            email="contacto@comvalle.com",
            phone="555-2002",
            address="Av. del Valle 250",
            city="Ciudad",
            payment_terms=PaymentTerms.NET_15,
            credit_limit=25000.0,
            contact_person="Ana Gutierrez",
            contact_email="ana@comvalle.com"
        ),
        Supplier(
            business_id=business.id,
            name="Abarrotes El Mayorista",
            company_name="Abarrotes El Mayorista S.C.",
            tax_id="AEM150820ZW3",
            email="ventas@mayorista.com",
            phone="555-3003",
            address="Mercado Central Local 45",
            city="Ciudad",
            payment_terms=PaymentTerms.CASH,
            credit_limit=15000.0,
            contact_person="Carlos Lopez",
            contact_email="carlos@mayorista.com"
        ),
    ]
    
    for supplier in suppliers:
        db.add(supplier)
    db.commit()
    
    # 9. Crear productos y variantes
    print("📦 Creando productos...")
    
    # Obtener IDs para referencias
    kg_unit = db.query(Unit).filter(Unit.symbol == "kg").first()
    l_unit = db.query(Unit).filter(Unit.symbol == "L").first()
    pza_unit = db.query(Unit).filter(Unit.symbol == "pza").first()
    
    products_data = [
        {
            "name": "Coca-Cola",
            "category": "Bebidas",
            "brand": "Coca-Cola",
            "variants": [
                {"name": "Coca-Cola 600ml", "sku": "CC-600", "cost": 12.00, "price": 18.00, "unit": pza_unit},
                {"name": "Coca-Cola 2L", "sku": "CC-2L", "cost": 25.00, "price": 35.00, "unit": pza_unit},
            ]
        },
        {
            "name": "Leche Lala",
            "category": "Lácteos", 
            "brand": "Lala",
            "variants": [
                {"name": "Leche Lala Entera 1L", "sku": "LL-1L", "cost": 18.00, "price": 25.00, "unit": pza_unit},
                {"name": "Leche Lala Deslactosada 1L", "sku": "LL-DL-1L", "cost": 22.00, "price": 30.00, "unit": pza_unit},
            ]
        },
        {
            "name": "Pan Bimbo",
            "category": "Abarrotes",
            "brand": "Bimbo", 
            "variants": [
                {"name": "Pan Blanco Grande", "sku": "PB-BG", "cost": 28.00, "price": 38.00, "unit": pza_unit},
                {"name": "Pan Integral", "sku": "PB-INT", "cost": 32.00, "price": 42.00, "unit": pza_unit},
            ]
        },
        {
            "name": "Harina Maseca",
            "category": "Abarrotes",
            "brand": "Maseca",
            "variants": [
                {"name": "Harina Maseca 1kg", "sku": "HM-1K", "cost": 18.00, "price": 25.00, "unit": pza_unit},
                {"name": "Harina Maseca 4kg", "sku": "HM-4K", "cost": 65.00, "price": 85.00, "unit": pza_unit},
            ]
        },
    ]
    
    products = []
    variants = []
    
    for prod_data in products_data:
        category = db.query(Category).filter(
            Category.business_id == business.id,
            Category.name == prod_data["category"]
        ).first()
        
        brand = db.query(Brand).filter(
            Brand.business_id == business.id,
            Brand.name == prod_data["brand"]
        ).first()
        
        product = Product(
            business_id=business.id,
            category_id=category.id if category else None,
            brand_id=brand.id if brand else None,
            name=prod_data["name"],
            description=f"Producto {prod_data['name']}",
            sku=f"PROD-{len(products)+1:03d}",
            base_unit_id=pza_unit.id,
            minimum_stock=5.0,
            maximum_stock=100.0
        )
        db.add(product)
        db.flush()  # Para obtener el ID
        products.append(product)
        
        for var_data in prod_data["variants"]:
            variant = ProductVariant(
                product_id=product.id,
                name=var_data["name"],
                sku=var_data["sku"],
                cost_price=var_data["cost"],
                selling_price=var_data["price"]
            )
            db.add(variant)
            db.flush()
            variants.append(variant)
    
    db.commit()
    
    # 10. Crear productos del proveedor
    print("🔗 Creando relaciones proveedor-producto...")
    supplier_products = []
    
    for i, variant in enumerate(variants):
        supplier = suppliers[i % len(suppliers)]
        sp = SupplierProduct(
            supplier_id=supplier.id,
            product_variant_id=variant.id,
            supplier_sku=f"SUP-{variant.sku}",
            supplier_product_name=variant.name,
            cost_price=variant.cost_price * 0.9,  # 10% descuento del proveedor
            minimum_order_quantity=10.0,
            lead_time_days=random.randint(3, 15),
            is_preferred=i < 3  # Los primeros 3 son preferidos
        )
        db.add(sp)
        supplier_products.append(sp)
    
    db.commit()
    
    # 11. Crear órdenes de compra de ejemplo
    print("📋 Creando órdenes de compra...")
    
    # Orden 1: Pendiente
    po1 = PurchaseOrder(
        business_id=business.id,
        supplier_id=suppliers[0].id,
        warehouse_id=warehouses[0].id,
        user_id=users[1].id,
        order_number="PO-20250106-001",
        status=PurchaseOrderStatus.PENDING,
        order_date=datetime.now() - timedelta(days=2),
        expected_delivery_date=datetime.now() + timedelta(days=5),
        payment_terms=PaymentTerms.NET_30,
        subtotal=1000.00,
        tax_amount=160.00,
        total_amount=1160.00,
        notes="Orden urgente para restock"
    )
    db.add(po1)
    db.flush()
    
    # Items para la orden 1
    po1_items = [
        PurchaseOrderItem(
            purchase_order_id=po1.id,
            product_variant_id=variants[0].id,
            unit_id=pza_unit.id,
            quantity_ordered=50.0,
            quantity_received=0.0,
            quantity_pending=50.0,
            unit_cost=variants[0].cost_price,
            total_cost=50.0 * variants[0].cost_price,
            product_name=variants[0].name,
            product_sku=variants[0].sku,
            supplier_sku=f"SUP-{variants[0].sku}"
        ),
        PurchaseOrderItem(
            purchase_order_id=po1.id,
            product_variant_id=variants[1].id,
            unit_id=pza_unit.id,
            quantity_ordered=30.0,
            quantity_received=0.0,
            quantity_pending=30.0,
            unit_cost=variants[1].cost_price,
            total_cost=30.0 * variants[1].cost_price,
            product_name=variants[1].name,
            product_sku=variants[1].sku,
            supplier_sku=f"SUP-{variants[1].sku}"
        ),
    ]
    
    for item in po1_items:
        db.add(item)
    
    # Orden 2: Aprobada
    po2 = PurchaseOrder(
        business_id=business.id,
        supplier_id=suppliers[1].id,
        warehouse_id=warehouses[0].id,
        user_id=users[1].id,
        order_number="PO-20250105-002",
        status=PurchaseOrderStatus.APPROVED,
        order_date=datetime.now() - timedelta(days=3),
        expected_delivery_date=datetime.now() + timedelta(days=3),
        approved_at=datetime.now() - timedelta(days=1),
        approved_by_id=users[0].id,
        payment_terms=PaymentTerms.NET_15,
        subtotal=750.00,
        tax_amount=120.00,
        total_amount=870.00,
        notes="Productos lácteos y abarrotes"
    )
    db.add(po2)
    db.flush()
    
    # Items para la orden 2
    po2_items = [
        PurchaseOrderItem(
            purchase_order_id=po2.id,
            product_variant_id=variants[2].id,
            unit_id=pza_unit.id,
            quantity_ordered=40.0,
            quantity_received=0.0,
            quantity_pending=40.0,
            unit_cost=variants[2].cost_price,
            total_cost=40.0 * variants[2].cost_price,
            product_name=variants[2].name,
            product_sku=variants[2].sku,
            supplier_sku=f"SUP-{variants[2].sku}"
        ),
    ]
    
    for item in po2_items:
        db.add(item)
    
    db.commit()
    
    # 12. Crear algunos movimientos de inventario
    print("📊 Creando movimientos de inventario...")
    
    movements = [
        InventoryMovement(
            warehouse_id=warehouses[0].id,
            product_variant_id=variants[0].id,
            unit_id=pza_unit.id,
            user_id=users[2].id,
            movement_type=MovementType.ENTRY,
            quantity=100.0,
            cost_per_unit=variants[0].cost_price,
            previous_quantity=0.0,
            new_quantity=100.0,
            reference_number="INIT-001",
            reason="Stock inicial",
            notes="Inventario inicial del sistema"
        ),
        InventoryMovement(
            warehouse_id=warehouses[0].id,
            product_variant_id=variants[1].id,
            unit_id=pza_unit.id,
            user_id=users[2].id,
            movement_type=MovementType.ENTRY,
            quantity=75.0,
            cost_per_unit=variants[1].cost_price,
            previous_quantity=0.0,
            new_quantity=75.0,
            reference_number="INIT-002",
            reason="Stock inicial",
            notes="Inventario inicial del sistema"
        ),
        InventoryMovement(
            warehouse_id=warehouses[0].id,
            product_variant_id=variants[0].id,
            unit_id=pza_unit.id,
            user_id=users[2].id,
            movement_type=MovementType.EXIT,
            quantity=15.0,
            cost_per_unit=variants[0].cost_price,
            previous_quantity=100.0,
            new_quantity=85.0,
            reference_number="SALE-001",
            reason="Venta",
            notes="Venta a cliente"
        ),
    ]
    
    for movement in movements:
        db.add(movement)
    
    db.commit()
    
    print("✅ Datos de ejemplo creados exitosamente!")
    print("\n📊 Resumen de datos creados:")
    print(f"   👥 Usuarios: {len(users)}")
    print(f"   🏢 Negocios: 1")
    print(f"   🏬 Almacenes: {len(warehouses)}")
    print(f"   🚚 Proveedores: {len(suppliers)}")
    print(f"   🏷️ Categorías: {len(categories)}")
    print(f"   🏷️ Marcas: {len(brands)}")
    print(f"   📦 Productos: {len(products)}")
    print(f"   📦 Variantes: {len(variants)}")
    print(f"   📋 Órdenes de compra: 2")
    print(f"   📊 Movimientos de inventario: {len(movements)}")
    print(f"   📏 Unidades de medida: {len(units)}")
    
    print("\n🔐 Credenciales de acceso:")
    print("   Admin: admin@maestroinventario.com / admin123")
    print("   Manager: manager@maestroinventario.com / manager123")
    print("   Employee: employee@maestroinventario.com / employee123")

if __name__ == "__main__":
    try:
        create_sample_data()
    except Exception as e:
        print(f"❌ Error al crear datos: {e}")
        db.rollback()
    finally:
        db.close()
