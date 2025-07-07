"""
Servidor HTTP simple para probar endpoints de inventario
"""
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

app = FastAPI(title="Maestro Inventario - Test API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Esquemas básicos
class InventoryEntryCreate(BaseModel):
    warehouse_id: int
    product_variant_id: int
    unit_id: int
    quantity: float
    cost_per_unit: Optional[float] = None
    batch_number: Optional[str] = None
    reason: Optional[str] = None
    notes: Optional[str] = None

class InventoryExitCreate(BaseModel):
    warehouse_id: int
    product_variant_id: int
    unit_id: int
    quantity: float
    customer_id: Optional[int] = None
    sale_id: Optional[int] = None
    reason: Optional[str] = None
    notes: Optional[str] = None

class InventoryAdjustmentCreate(BaseModel):
    warehouse_id: int
    product_variant_id: int
    unit_id: int
    current_quantity: float
    actual_quantity: float
    adjustment_type: str = "physical_count"
    unit_cost: Optional[float] = None
    reason: Optional[str] = None
    notes: Optional[str] = None

class InventoryTransferCreate(BaseModel):
    source_warehouse_id: int
    destination_warehouse_id: int
    product_variant_id: int
    unit_id: int
    quantity: float
    reason: Optional[str] = None
    notes: Optional[str] = None

# Multi-Item Schemas
class InventoryEntryItemCreate(BaseModel):
    product_variant_id: int
    unit_id: int
    quantity: float
    cost_per_unit: Optional[float] = None
    expiry_date: Optional[datetime] = None
    batch_number: Optional[str] = None
    notes: Optional[str] = None

class InventoryEntryMultiCreate(BaseModel):
    warehouse_id: int
    supplier_id: Optional[int] = None
    purchase_order_id: Optional[int] = None
    reference_number: Optional[str] = None
    reason: Optional[str] = None
    notes: Optional[str] = None
    items: List[InventoryEntryItemCreate]

class InventoryExitItemCreate(BaseModel):
    product_variant_id: int
    unit_id: int
    quantity: float
    unit_price: Optional[float] = None
    notes: Optional[str] = None

class InventoryExitMultiCreate(BaseModel):
    warehouse_id: int
    customer_id: Optional[int] = None
    sale_id: Optional[int] = None
    destination_warehouse_id: Optional[int] = None
    reference_number: Optional[str] = None
    reason: Optional[str] = None
    notes: Optional[str] = None
    items: List[InventoryExitItemCreate]

class InventoryAdjustmentItemCreate(BaseModel):
    product_variant_id: int
    unit_id: int
    quantity_adjustment: float
    reason: Optional[str] = None
    cost_adjustment: Optional[float] = None
    notes: Optional[str] = None

class InventoryAdjustmentMultiCreate(BaseModel):
    warehouse_id: int
    reference_number: Optional[str] = None
    reason: Optional[str] = None
    notes: Optional[str] = None
    items: List[InventoryAdjustmentItemCreate]

# Authentication Schemas
class LoginRequest(BaseModel):
    email: str
    password: str

class LoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: dict

class RegisterRequest(BaseModel):
    email: str
    password: str
    first_name: str
    last_name: str

# Mock data
mock_warehouses = [
    {"id": 1, "name": "Almacén Principal", "code": "ALM001", "is_active": True, "address": "Calle Principal 123"},
    {"id": 2, "name": "Almacén Secundario", "code": "ALM002", "is_active": True, "address": "Avenida Secundaria 456"},
    {"id": 3, "name": "Almacén de Terminados", "code": "ALM003", "is_active": True, "address": "Zona Industrial 789"}
]

mock_units = [
    {"id": 1, "name": "Unidad", "symbol": "UND", "type": "count", "conversion_factor": 1.0},
    {"id": 2, "name": "Kilogramo", "symbol": "KG", "type": "weight", "conversion_factor": 1000.0},
    {"id": 3, "name": "Metro", "symbol": "M", "type": "length", "conversion_factor": 100.0},
    {"id": 4, "name": "Litro", "symbol": "L", "type": "volume", "conversion_factor": 1000.0}
]

mock_products = [
    {
        "id": 1,
        "name": "Galaxy S24 Ultra",
        "description": "Smartphone Samsung Galaxy S24 Ultra 256GB",
        "sku": "SAM-S24U-256",
        "barcode": "1234567890123",
        "category_id": 2,
        "category": "Smartphones",
        "brand_id": 1,
        "brand": "Samsung",
        "image_url": None,
        "is_active": True,
        "base_unit": {"id": 1, "name": "Unidad", "symbol": "UND"},
        "current_stock": 150.0,
        "minimum_stock": 10.0,
        "maximum_stock": 500.0,
        "has_low_stock": False,
        "variants": [
            {
                "id": 1,
                "attributes": {"color": "Negro", "storage": "256GB"},
                "current_stock": 75.0
            },
            {
                "id": 2,
                "attributes": {"color": "Titanio", "storage": "256GB"},
                "current_stock": 75.0
            }
        ]
    },
    {
        "id": 2,
        "name": "iPhone 15 Pro",
        "description": "iPhone 15 Pro de Apple 128GB",
        "sku": "APL-IP15P-128",
        "barcode": "2345678901234",
        "category_id": 2,
        "category": "Smartphones",
        "brand_id": 2,
        "brand": "Apple",
        "image_url": None,
        "is_active": True,
        "base_unit": {"id": 1, "name": "Unidad", "symbol": "UND"},
        "current_stock": 8.0,
        "minimum_stock": 10.0,
        "maximum_stock": 100.0,
        "has_low_stock": True,
        "variants": [
            {
                "id": 3,
                "attributes": {"color": "Azul Titanio", "storage": "128GB"},
                "current_stock": 8.0
            }
        ]
    },
    {
        "id": 3,
        "name": "Air Jordan 1",
        "description": "Zapatillas Nike Air Jordan 1 Retro High",
        "sku": "NIKE-AJ1-RH",
        "barcode": "3456789012345",
        "category_id": 4,
        "category": "Calzado",
        "brand_id": 3,
        "brand": "Nike",
        "image_url": None,
        "is_active": True,
        "base_unit": {"id": 3, "name": "Par", "symbol": "PAR"},
        "current_stock": 25.0,
        "minimum_stock": 5.0,
        "maximum_stock": 100.0,
        "has_low_stock": False,
        "variants": [
            {
                "id": 4,
                "attributes": {"color": "Chicago", "size": "42"},
                "current_stock": 12.0
            },
            {
                "id": 5,
                "attributes": {"color": "Bred", "size": "42"},
                "current_stock": 13.0
            }
        ]
    }
]

# Mock users for testing
mock_users = [
    {
        "id": 1,
        "email": "admin@maestro.com",
        "password": "123456",  # En producción esto estaría hasheado
        "first_name": "Admin",
        "last_name": "Maestro",
        "is_active": True,
        "is_admin": True
    },
    {
        "id": 2,
        "email": "user@maestro.com", 
        "password": "123456",
        "first_name": "Usuario",
        "last_name": "Prueba",
        "is_active": True,
        "is_admin": False
    }
]

# Mock businesses
mock_businesses = [
    {
        "id": 1,
        "name": "Mi Negocio Principal",
        "description": "Negocio de prueba para el sistema",
        "code": "NEG001",
        "is_active": True,
        "created_at": "2024-01-01T00:00:00"
    }
]

# Mock categories
mock_categories = [
    {
        "id": 1,
        "name": "Electrónicos",
        "description": "Dispositivos electrónicos y tecnología",
        "code": "ELEC",
        "is_active": True,
        "parent_id": None
    },
    {
        "id": 2,
        "name": "Smartphones",
        "description": "Teléfonos inteligentes",
        "code": "PHONE",
        "is_active": True,
        "parent_id": 1
    },
    {
        "id": 3,
        "name": "Ropa",
        "description": "Prendas de vestir",
        "code": "CLOTH",
        "is_active": True,
        "parent_id": None
    },
    {
        "id": 4,
        "name": "Calzado",
        "description": "Zapatos y sandalias",
        "code": "SHOES",
        "is_active": True,
        "parent_id": None
    },
    {
        "id": 5,
        "name": "Alimentos",
        "description": "Productos alimenticios",
        "code": "FOOD",
        "is_active": True,
        "parent_id": None
    }
]

# Mock brands  
mock_brands = [
    {
        "id": 1,
        "name": "Samsung",
        "description": "Marca surcoreana de tecnología",
        "code": "SAMSUNG",
        "is_active": True,
        "country": "Corea del Sur"
    },
    {
        "id": 2,
        "name": "Apple",
        "description": "Marca estadounidense de tecnología",
        "code": "APPLE",
        "is_active": True,
        "country": "Estados Unidos"
    },
    {
        "id": 3,
        "name": "Nike",
        "description": "Marca de ropa deportiva",
        "code": "NIKE",
        "is_active": True,
        "country": "Estados Unidos"
    },
    {
        "id": 4,
        "name": "Adidas",
        "description": "Marca alemana de ropa deportiva",
        "code": "ADIDAS",
        "is_active": True,
        "country": "Alemania"
    },
    {
        "id": 5,
        "name": "Coca-Cola",
        "description": "Marca de bebidas",
        "code": "COCACOLA",
        "is_active": True,
        "country": "Estados Unidos"
    }
]

# Lista global para almacenar todos los movimientos
all_movements = []

# Datos de prueba para el historial
sample_movements = [
    {
        "id": 101,
        "warehouse_id": 1,
        "warehouse_name": "Almacén Principal",
        "product_variant_id": 1,
        "unit_id": 1,
        "unit_symbol": "UND",
        "movement_type": "entry",
        "quantity": 10.0,
        "cost_per_unit": 850.0,
        "previous_quantity": 65.0,
        "new_quantity": 75.0,
        "reason": "Compra de smartphones Samsung",
        "user_id": 1,
        "created_at": "2025-07-05T10:30:00"
    },
    {
        "id": 102,
        "warehouse_id": 1,
        "warehouse_name": "Almacén Principal",
        "product_variant_id": 3,
        "unit_id": 1,
        "unit_symbol": "UND",
        "movement_type": "exit",
        "quantity": 2.0,
        "previous_quantity": 10.0,
        "new_quantity": 8.0,
        "reason": "Venta de iPhone 15 Pro",
        "user_id": 1,
        "created_at": "2025-07-05T14:15:00"
    },
    {
        "id": 103,
        "warehouse_id": 1,
        "warehouse_name": "Almacén Principal",
        "product_variant_id": 4,
        "unit_id": 3,
        "unit_symbol": "PAR",
        "movement_type": "adjustment",
        "quantity": -1.0,
        "cost_per_unit": 180.0,
        "previous_quantity": 13.0,
        "new_quantity": 12.0,
        "reason": "Corrección de inventario físico - zapatos dañados",
        "user_id": 1,
        "created_at": "2025-07-05T16:45:00"
    }
]

# Inicializar movimientos con datos de prueba
all_movements.extend(sample_movements)

movement_counter = 104  # Continuar desde el siguiente ID

@app.get("/")
def read_root():
    return {
        "message": "🎯 Maestro Inventario - API de Pruebas para Movimientos con Almacén",
        "version": "1.0.0",
        "status": "✅ Operativo",
        "features": [
            "✓ Entradas de inventario con almacén específico",
            "✓ Salidas de inventario con almacén específico", 
            "✓ Ajustes de inventario con almacén específico",
            "✓ Transferencias entre almacenes",
            "✓ Validación de almacenes y stock"
        ],
        "endpoints": {
            "almacenes": "GET /api/v1/inventory/warehouses",
            "unidades": "GET /api/v1/inventory/units",
            "productos": "GET /api/v1/inventory/products",
            "entrada": "POST /api/v1/inventory/movements/entry",
            "salida": "POST /api/v1/inventory/movements/exit",
            "ajuste": "POST /api/v1/inventory/movements/adjustment", 
            "transferencia": "POST /api/v1/inventory/movements/transfer"
        }
    }

@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "timestamp": datetime.utcnow().isoformat(),
        "warehouse_system": "operational"
    }

@app.get("/api/v1/inventory/warehouses")
def get_warehouses():
    """📦 Obtener lista de almacenes activos"""
    return mock_warehouses

@app.get("/api/v1/inventory/units")
def get_units():
    """📏 Obtener unidades de medida disponibles"""
    return mock_units

@app.get("/api/v1/inventory/products")
def get_products():
    """📋 Obtener productos con información de inventario"""
    return mock_products

@app.get("/api/v1/inventory/categories")
def get_categories():
    """📂 Obtener lista de categorías"""
    return mock_categories

@app.get("/api/v1/inventory/brands")
def get_brands():
    """🏷️ Obtener lista de marcas"""
    return mock_brands

@app.post("/api/v1/inventory/movements/entry")
def create_inventory_entry(entry_data: InventoryEntryCreate):
    """📥 Crear entrada de inventario en almacén específico"""
    global movement_counter
    
    # Validar almacén existe
    warehouse = next((w for w in mock_warehouses if w["id"] == entry_data.warehouse_id), None)
    if not warehouse:
        raise HTTPException(status_code=404, detail=f"❌ Almacén ID {entry_data.warehouse_id} no encontrado")
    
    # Validar producto existe
    product_found = False
    for product in mock_products:
        for variant in product.get("variants", []):
            if variant["id"] == entry_data.product_variant_id:
                product_found = True
                break
        if product_found:
            break
    
    if not product_found:
        raise HTTPException(status_code=404, detail=f"❌ Producto variante ID {entry_data.product_variant_id} no encontrado")
    
    # Validar unidad existe
    unit = next((u for u in mock_units if u["id"] == entry_data.unit_id), None)
    if not unit:
        raise HTTPException(status_code=404, detail=f"❌ Unidad ID {entry_data.unit_id} no encontrada")
    
    # Simular inventario actual
    previous_quantity = 100.0
    new_quantity = previous_quantity + entry_data.quantity
    
    # Crear registro de movimiento
    movement = {
        "id": movement_counter,
        "warehouse_id": entry_data.warehouse_id,
        "warehouse_name": warehouse["name"],
        "product_variant_id": entry_data.product_variant_id,
        "unit_id": entry_data.unit_id,
        "unit_symbol": unit["symbol"],
        "movement_type": "entry",
        "quantity": entry_data.quantity,
        "previous_quantity": previous_quantity,
        "new_quantity": new_quantity,
        "cost_per_unit": entry_data.cost_per_unit,
        "batch_number": entry_data.batch_number,
        "reason": entry_data.reason or "Entrada de inventario",
        "notes": entry_data.notes,
        "user_id": 1,
        "created_at": datetime.utcnow().isoformat()
    }
    
    # Almacenar movimiento en lista global
    all_movements.append(movement)
    
    movement_counter += 1
    
    return {
        "message": f"✅ Entrada registrada en {warehouse['name']}",
        "movement": movement
    }

@app.post("/api/v1/inventory/movements/exit")
def create_inventory_exit(exit_data: InventoryExitCreate):
    """📤 Crear salida de inventario de almacén específico"""
    global movement_counter
    
    # Validar almacén existe
    warehouse = next((w for w in mock_warehouses if w["id"] == exit_data.warehouse_id), None)
    if not warehouse:
        raise HTTPException(status_code=404, detail=f"❌ Almacén ID {exit_data.warehouse_id} no encontrado")
    
    # Validar producto existe
    product_found = False
    for product in mock_products:
        for variant in product.get("variants", []):
            if variant["id"] == exit_data.product_variant_id:
                product_found = True
                break
        if product_found:
            break
    
    if not product_found:
        raise HTTPException(status_code=404, detail=f"❌ Producto variante ID {exit_data.product_variant_id} no encontrado")
    
    # Validar unidad existe
    unit = next((u for u in mock_units if u["id"] == exit_data.unit_id), None)
    if not unit:
        raise HTTPException(status_code=404, detail=f"❌ Unidad ID {exit_data.unit_id} no encontrada")
    
    # Simular inventario actual y validar stock
    previous_quantity = 100.0
    if exit_data.quantity > previous_quantity:
        raise HTTPException(
            status_code=400, 
            detail=f"❌ Stock insuficiente en {warehouse['name']}. Disponible: {previous_quantity}, Solicitado: {exit_data.quantity}"
        )
    
    new_quantity = previous_quantity - exit_data.quantity
    
    # Crear registro de movimiento
    movement = {
        "id": movement_counter,
        "warehouse_id": exit_data.warehouse_id,
        "warehouse_name": warehouse["name"],
        "product_variant_id": exit_data.product_variant_id,
        "unit_id": exit_data.unit_id,
        "unit_symbol": unit["symbol"],
        "movement_type": "exit",
        "quantity": exit_data.quantity,
        "previous_quantity": previous_quantity,
        "new_quantity": new_quantity,
        "customer_id": exit_data.customer_id,
        "sale_id": exit_data.sale_id,
        "reason": exit_data.reason or "Salida de inventario",
        "notes": exit_data.notes,
        "user_id": 1,
        "created_at": datetime.utcnow().isoformat()
    }
    
    # Almacenar movimiento en lista global
    all_movements.append(movement)
    
    movement_counter += 1
    
    return {
        "message": f"✅ Salida registrada de {warehouse['name']}",
        "movement": movement
    }

@app.post("/api/v1/inventory/movements/adjustment")
def create_inventory_adjustment(adjustment_data: InventoryAdjustmentCreate):
    """⚖️ Crear ajuste de inventario en almacén específico"""
    global movement_counter
    
    # Validar almacén existe
    warehouse = next((w for w in mock_warehouses if w["id"] == adjustment_data.warehouse_id), None)
    if not warehouse:
        raise HTTPException(status_code=404, detail=f"❌ Almacén ID {adjustment_data.warehouse_id} no encontrado")
    
    # Validar producto existe
    product_found = False
    for product in mock_products:
        for variant in product.get("variants", []):
            if variant["id"] == adjustment_data.product_variant_id:
                product_found = True
                break
        if product_found:
            break
    
    if not product_found:
        raise HTTPException(status_code=404, detail=f"❌ Producto variante ID {adjustment_data.product_variant_id} no encontrado")
    
    # Validar unidad existe
    unit = next((u for u in mock_units if u["id"] == adjustment_data.unit_id), None)
    if not unit:
        raise HTTPException(status_code=404, detail=f"❌ Unidad ID {adjustment_data.unit_id} no encontrada")
    
    # Calcular diferencia
    difference = adjustment_data.actual_quantity - adjustment_data.current_quantity
    
    # Crear registro de movimiento
    movement = {
        "id": movement_counter,
        "warehouse_id": adjustment_data.warehouse_id,
        "warehouse_name": warehouse["name"],
        "product_variant_id": adjustment_data.product_variant_id,
        "unit_id": adjustment_data.unit_id,
        "unit_symbol": unit["symbol"],
        "movement_type": "adjustment",
        "quantity": abs(difference),
        "previous_quantity": adjustment_data.current_quantity,
        "new_quantity": adjustment_data.actual_quantity,
        "adjustment_type": adjustment_data.adjustment_type,
        "difference": difference,
        "unit_cost": adjustment_data.unit_cost,
        "reason": adjustment_data.reason or "Ajuste de inventario",
        "notes": adjustment_data.notes,
        "user_id": 1,
        "created_at": datetime.utcnow().isoformat()
    }
    
    # Almacenar movimiento en lista global
    all_movements.append(movement)
    
    movement_counter += 1
    
    adjustment_type_text = "📈 Incremento" if difference > 0 else "📉 Reducción" if difference < 0 else "➡️ Sin cambio"
    
    return {
        "message": f"✅ Ajuste registrado en {warehouse['name']} - {adjustment_type_text} de {abs(difference)} {unit['symbol']}",
        "movement": movement
    }

@app.post("/api/v1/inventory/movements/transfer")
def create_inventory_transfer(transfer_data: InventoryTransferCreate):
    """🔄 Crear transferencia entre almacenes específicos"""
    global movement_counter
    
    # Validar almacenes existen
    source_warehouse = next((w for w in mock_warehouses if w["id"] == transfer_data.source_warehouse_id), None)
    dest_warehouse = next((w for w in mock_warehouses if w["id"] == transfer_data.destination_warehouse_id), None)
    
    if not source_warehouse:
        raise HTTPException(status_code=404, detail=f"❌ Almacén origen ID {transfer_data.source_warehouse_id} no encontrado")
    
    if not dest_warehouse:
        raise HTTPException(status_code=404, detail=f"❌ Almacén destino ID {transfer_data.destination_warehouse_id} no encontrado")
    
    # Validar que son diferentes
    if transfer_data.source_warehouse_id == transfer_data.destination_warehouse_id:
        raise HTTPException(status_code=400, detail="❌ El almacén origen y destino deben ser diferentes")
    
    # Validar producto existe
    product_found = False
    for product in mock_products:
        for variant in product.get("variants", []):
            if variant["id"] == transfer_data.product_variant_id:
                product_found = True
                break
        if product_found:
            break
    
    if not product_found:
        raise HTTPException(status_code=404, detail=f"❌ Producto variante ID {transfer_data.product_variant_id} no encontrado")
    
    # Validar unidad existe
    unit = next((u for u in mock_units if u["id"] == transfer_data.unit_id), None)
    if not unit:
        raise HTTPException(status_code=404, detail=f"❌ Unidad ID {transfer_data.unit_id} no encontrada")
    
    # Simular stock en almacén origen
    source_stock = 100.0
    if transfer_data.quantity > source_stock:
        raise HTTPException(
            status_code=400,
            detail=f"❌ Stock insuficiente en {source_warehouse['name']}. Disponible: {source_stock}, Solicitado: {transfer_data.quantity}"
        )
    
    # Crear movimiento de salida (almacén origen)
    exit_movement = {
        "id": movement_counter,
        "warehouse_id": transfer_data.source_warehouse_id,
        "warehouse_name": source_warehouse["name"],
        "product_variant_id": transfer_data.product_variant_id,
        "unit_id": transfer_data.unit_id,
        "unit_symbol": unit["symbol"],
        "movement_type": "transfer",
        "quantity": transfer_data.quantity,
        "previous_quantity": source_stock,
        "new_quantity": source_stock - transfer_data.quantity,
        "reference_type": "transfer_out",
        "reference_id": transfer_data.destination_warehouse_id,
        "reason": transfer_data.reason or f"Transferencia a {dest_warehouse['name']}",
        "notes": transfer_data.notes,
        "user_id": 1,
        "created_at": datetime.utcnow().isoformat()
    }
    
    # Almacenar movimiento en lista global
    all_movements.append(exit_movement)
    
    movement_counter += 1
    
    # Crear movimiento de entrada (almacén destino)
    dest_stock = 50.0  # Stock inicial simulado
    entry_movement = {
        "id": movement_counter,
        "warehouse_id": transfer_data.destination_warehouse_id,
        "warehouse_name": dest_warehouse["name"],
        "product_variant_id": transfer_data.product_variant_id,
        "unit_id": transfer_data.unit_id,
        "unit_symbol": unit["symbol"],
        "movement_type": "transfer",
        "quantity": transfer_data.quantity,
        "previous_quantity": dest_stock,
        "new_quantity": dest_stock + transfer_data.quantity,
        "reference_type": "transfer_in",
        "reference_id": transfer_data.source_warehouse_id,
        "reason": transfer_data.reason or f"Transferencia desde {source_warehouse['name']}",
        "notes": transfer_data.notes,
        "user_id": 1,
        "created_at": datetime.utcnow().isoformat()
    }
    
    # Almacenar movimiento en lista global
    all_movements.append(entry_movement)
    
    movement_counter += 1
    
    return {
        "message": f"✅ Transferencia completada: {source_warehouse['name']} → {dest_warehouse['name']} ({transfer_data.quantity} {unit['symbol']})",
        "movements": [exit_movement, entry_movement]
    }

# ============================================================================
# ENDPOINTS MULTI-ITEM
# ============================================================================

@app.post("/api/v1/inventory/entries/multi")
def create_inventory_entry_multi(entry_data: InventoryEntryMultiCreate):
    """📥 Crear entrada de inventario con múltiples productos"""
    global movement_counter
    
    # Validar almacén existe
    warehouse = next((w for w in mock_warehouses if w["id"] == entry_data.warehouse_id), None)
    if not warehouse:
        raise HTTPException(status_code=404, detail=f"❌ Almacén ID {entry_data.warehouse_id} no encontrado")
    
    if not entry_data.items:
        raise HTTPException(status_code=400, detail="❌ Debe incluir al menos un producto")
    
    movements = []
    total_value = 0.0
    
    for item in entry_data.items:
        # Validar producto existe
        product_found = False
        for product in mock_products:
            for variant in product.get("variants", []):
                if variant["id"] == item.product_variant_id:
                    product_found = True
                    break
            if product_found:
                break
        
        if not product_found:
            raise HTTPException(status_code=404, detail=f"❌ Producto variante ID {item.product_variant_id} no encontrado")
        
        # Validar unidad existe
        unit = next((u for u in mock_units if u["id"] == item.unit_id), None)
        if not unit:
            raise HTTPException(status_code=404, detail=f"❌ Unidad ID {item.unit_id} no encontrada")
        
        # Simular stock actual
        current_stock = 100.0
        item_value = (item.cost_per_unit or 0.0) * item.quantity
        total_value += item_value
        
        # Crear movimiento
        movement = {
            "id": movement_counter,
            "warehouse_id": entry_data.warehouse_id,
            "warehouse_name": warehouse["name"],
            "product_variant_id": item.product_variant_id,
            "unit_id": item.unit_id,
            "unit_symbol": unit["symbol"],
            "movement_type": "entry",
            "quantity": item.quantity,
            "cost_per_unit": item.cost_per_unit,
            "previous_quantity": current_stock,
            "new_quantity": current_stock + item.quantity,
            "batch_number": item.batch_number,
            "expiry_date": item.expiry_date.isoformat() if item.expiry_date else None,
            "reference_number": entry_data.reference_number,
            "reason": item.notes or entry_data.reason,
            "notes": entry_data.notes,
            "user_id": 1,
            "created_at": datetime.utcnow().isoformat()
        }
        
        # Almacenar movimiento en lista global
        all_movements.append(movement)
        
        movements.append(movement)
        movement_counter += 1
    
    return {
        "message": f"✅ Entrada multi-item completada en {warehouse['name']} ({len(movements)} productos)",
        "movement_id": movements[0]["id"] if movements else None,
        "total_items": len(movements),
        "total_value": total_value,
        "movements": movements
    }


@app.post("/api/v1/inventory/exits/multi")
def create_inventory_exit_multi(exit_data: InventoryExitMultiCreate):
    """📤 Crear salida de inventario con múltiples productos"""
    global movement_counter
    
    # Validar almacén existe
    warehouse = next((w for w in mock_warehouses if w["id"] == exit_data.warehouse_id), None)
    if not warehouse:
        raise HTTPException(status_code=404, detail=f"❌ Almacén ID {exit_data.warehouse_id} no encontrado")
    
    if not exit_data.items:
        raise HTTPException(status_code=400, detail="❌ Debe incluir al menos un producto")
    
    movements = []
    total_value = 0.0
    
    for item in exit_data.items:
        # Validar producto existe
        product_found = False
        for product in mock_products:
            for variant in product.get("variants", []):
                if variant["id"] == item.product_variant_id:
                    product_found = True
                    break
            if product_found:
                break
        
        if not product_found:
            raise HTTPException(status_code=404, detail=f"❌ Producto variante ID {item.product_variant_id} no encontrado")
        
        # Validar unidad existe
        unit = next((u for u in mock_units if u["id"] == item.unit_id), None)
        if not unit:
            raise HTTPException(status_code=404, detail=f"❌ Unidad ID {item.unit_id} no encontrada")
        
        # Simular stock actual
        current_stock = 100.0
        if item.quantity > current_stock:
            raise HTTPException(
                status_code=400,
                detail=f"❌ Stock insuficiente para producto {item.product_variant_id}. Disponible: {current_stock}, Solicitado: {item.quantity}"
            )
        
        item_value = (item.unit_price or 0.0) * item.quantity
        total_value += item_value
        
        # Crear movimiento
        movement = {
            "id": movement_counter,
            "warehouse_id": exit_data.warehouse_id,
            "warehouse_name": warehouse["name"],
            "product_variant_id": item.product_variant_id,
            "unit_id": item.unit_id,
            "unit_symbol": unit["symbol"],
            "movement_type": "exit",
            "quantity": item.quantity,
            "unit_price": item.unit_price,
            "previous_quantity": current_stock,
            "new_quantity": current_stock - item.quantity,
            "reference_number": exit_data.reference_number,
            "reason": item.notes or exit_data.reason,
            "notes": exit_data.notes,
            "user_id": 1,
            "created_at": datetime.utcnow().isoformat()
        }
        
        # Almacenar movimiento en lista global
        all_movements.append(movement)
        
        movements.append(movement)
        movement_counter += 1
    
    return {
        "message": f"✅ Salida multi-item completada en {warehouse['name']} ({len(movements)} productos)",
        "movement_id": movements[0]["id"] if movements else None,
        "total_items": len(movements),
        "total_value": total_value,
        "movements": movements
    }


@app.post("/api/v1/inventory/adjustments/multi")
def create_inventory_adjustment_multi(adjustment_data: InventoryAdjustmentMultiCreate):
    """⚖️ Crear ajuste de inventario con múltiples productos"""
    global movement_counter
    
    # Validar almacén existe
    warehouse = next((w for w in mock_warehouses if w["id"] == adjustment_data.warehouse_id), None)
    if not warehouse:
        raise HTTPException(status_code=404, detail=f"❌ Almacén ID {adjustment_data.warehouse_id} no encontrado")
    
    if not adjustment_data.items:
        raise HTTPException(status_code=400, detail="❌ Debe incluir al menos un producto")
    
    movements = []
    total_value = 0.0
    
    for item in adjustment_data.items:
        # Validar producto existe
        product_found = False
        for product in mock_products:
            for variant in product.get("variants", []):
                if variant["id"] == item.product_variant_id:
                    product_found = True
                    break
            if product_found:
                break
        
        if not product_found:
            raise HTTPException(status_code=404, detail=f"❌ Producto variante ID {item.product_variant_id} no encontrado")
        
        # Validar unidad existe
        unit = next((u for u in mock_units if u["id"] == item.unit_id), None)
        if not unit:
            raise HTTPException(status_code=404, detail=f"❌ Unidad ID {item.unit_id} no encontrada")
        
        # Simular stock actual
        current_stock = 100.0
        new_stock = current_stock + item.quantity_adjustment
        
        if new_stock < 0:
            raise HTTPException(
                status_code=400,
                detail=f"❌ El ajuste resultaría en stock negativo para producto {item.product_variant_id}. Stock actual: {current_stock}, Ajuste: {item.quantity_adjustment}"
            )
        
        item_value = (item.cost_adjustment or 0.0) * abs(item.quantity_adjustment)
        total_value += item_value
        
        # Crear movimiento
        movement = {
            "id": movement_counter,
            "warehouse_id": adjustment_data.warehouse_id,
            "warehouse_name": warehouse["name"],
            "product_variant_id": item.product_variant_id,
            "unit_id": item.unit_id,
            "unit_symbol": unit["symbol"],
            "movement_type": "adjustment",
            "quantity": abs(item.quantity_adjustment),
            "quantity_adjustment": item.quantity_adjustment,
            "cost_adjustment": item.cost_adjustment,
            "previous_quantity": current_stock,
            "new_quantity": new_stock,
            "reference_number": adjustment_data.reference_number,
            "reason": item.notes or item.reason or adjustment_data.reason,
            "notes": adjustment_data.notes,
            "user_id": 1,
            "created_at": datetime.utcnow().isoformat()
        }
        
        # Almacenar movimiento en lista global
        all_movements.append(movement)
        
        movements.append(movement)
        movement_counter += 1
    
    return {
        "message": f"✅ Ajuste multi-item completado en {warehouse['name']} ({len(movements)} productos)",
        "movement_id": movements[0]["id"] if movements else None,
        "total_items": len(movements),
        "total_value": total_value,
        "movements": movements
    }


@app.get("/api/v1/inventory/movements")
def get_all_movements():
    """📋 Obtener lista de todos los movimientos de inventario"""
    try:
        # Retornar todos los movimientos ordenados por fecha más reciente
        sorted_movements = sorted(all_movements, key=lambda x: x.get("created_at", ""), reverse=True)
        
        # Enriquecer datos para el frontend
        enriched_movements = []
        for movement in sorted_movements:
            # Buscar información del producto, categoría y marca
            product_name = "Producto desconocido"
            category_name = "Sin categoría"
            brand_name = "Sin marca"
            
            for product in mock_products:
                for variant in product.get("variants", []):
                    if variant["id"] == movement.get("product_variant_id"):
                        # Construir nombre usando el producto y los atributos de la variante
                        attributes_str = ", ".join([f"{k}: {v}" for k, v in variant.get("attributes", {}).items()])
                        product_name = f"{product['name']} ({attributes_str})" if attributes_str else product['name']
                        category_name = product.get("category", "Sin categoría")
                        brand_name = product.get("brand", "Sin marca")
                        break
                if product_name != "Producto desconocido":
                    break
            
            enriched_movement = {
                "id": movement["id"],
                "movement_type": movement["movement_type"],
                "warehouse_name": movement["warehouse_name"],
                "product_name": product_name,
                "category": category_name,
                "brand": brand_name,
                "quantity": movement["quantity"],
                "unit_symbol": movement.get("unit_symbol", "UND"),
                "reference_number": f"MOV-{movement['id']:06d}",
                "reason": movement.get("reason", "Sin razón especificada"),
                "created_at": movement["created_at"],
                "user_name": "Admin Maestro",
                "total_value": movement.get("cost_per_unit", 0) * movement.get("quantity", 0) if movement.get("cost_per_unit") else 0
            }
            enriched_movements.append(enriched_movement)
        
        print(f"📋 Retornando {len(enriched_movements)} movimientos")
        return enriched_movements
        
    except Exception as e:
        print(f"❌ Error al obtener movimientos: {e}")
        return []

@app.get("/api/v1/inventory/movements/multi/{movement_id}")
def get_multi_movement_details(movement_id: int):
    """📋 Obtener detalles de un movimiento multi-item"""
    # Simular datos del movimiento
    movement_details = {
        "id": movement_id,
        "warehouse_id": 1,
        "warehouse_name": "Almacén Principal",
        "movement_type": "entry",
        "reference_number": f"REF-{movement_id:06d}",
        "total_items": 3,
        "total_value": 1500.50,
        "status": "completed",
        "created_at": datetime.utcnow().isoformat(),
        "created_by": 1,
        "items": [
            {
                "id": movement_id * 100 + 1,
                "product_variant_id": 1,
                "product_name": "Producto A - Variante 1",
                "unit_id": 1,
                "unit_symbol": "UND",
                "quantity": 10.0,
                "cost_per_unit": 50.0,
                "notes": "Item de prueba 1"
            },
            {
                "id": movement_id * 100 + 2,
                "product_variant_id": 2,
                "product_name": "Producto A - Variante 2",
                "unit_id": 1,
                "unit_symbol": "UND",
                "quantity": 15.0,
                "cost_per_unit": 45.0,
                "notes": "Item de prueba 2"
            },
            {
                "id": movement_id * 100 + 3,
                "product_variant_id": 3,
                "product_name": "Producto B - Variante 1",
                "unit_id": 2,
                "unit_symbol": "KG",
                "quantity": 5.0,
                "cost_per_unit": 75.10,
                "notes": "Item de prueba 3"
            }
        ]
    }
    
    return movement_details


# ============================================================================
# AUTHENTICATION ENDPOINTS
# ============================================================================

@app.post("/api/v1/auth/login")
def login(login_data: LoginRequest):
    """🔐 Iniciar sesión con email y contraseña"""
    print(f"🔍 LOGIN REQUEST:")
    print(f"  📧 Email recibido: '{login_data.email}'")
    print(f"  🔑 Password recibido: '{login_data.password}'")
    
    # Buscar usuario
    user = next((u for u in mock_users if u["email"] == login_data.email), None)
    
    print(f"  👤 Usuario encontrado: {user is not None}")
    if user:
        print(f"  ✅ Email coincide: {user['email'] == login_data.email}")
        print(f"  🔐 Password coincide: {user['password'] == login_data.password}")
    
    if not user or user["password"] != login_data.password:
        print(f"  ❌ CREDENCIALES INCORRECTAS")
        raise HTTPException(
            status_code=401, 
            detail="❌ Credenciales incorrectas"
        )
    
    if not user["is_active"]:
        print(f"  ❌ USUARIO DESACTIVADO")
        raise HTTPException(
            status_code=401,
            detail="❌ Usuario desactivado"
        )
    
    print(f"  ✅ LOGIN EXITOSO")
    
    # Generar token simple (en producción usar JWT real)
    token = f"mock_token_user_{user['id']}"
    
    # Datos del usuario sin contraseña
    user_data = {
        "id": user["id"],
        "email": user["email"],
        "first_name": user["first_name"],
        "last_name": user["last_name"],
        "is_active": user["is_active"]
    }
    
    return {
        "access_token": token,
        "token_type": "bearer",
        "user": user_data
    }

@app.post("/api/v1/auth/register")
def register(register_data: RegisterRequest):
    """📝 Registrar nuevo usuario"""
    # Verificar si el email ya existe
    existing_user = next((u for u in mock_users if u["email"] == register_data.email), None)
    if existing_user:
        raise HTTPException(
            status_code=400,
            detail="❌ El email ya está registrado"
        )
    
    # Crear nuevo usuario
    new_user = {
        "id": len(mock_users) + 1,
        "email": register_data.email,
        "password": register_data.password,
        "first_name": register_data.first_name,
        "last_name": register_data.last_name,
        "is_active": True,
        "is_admin": False
    }
    
    mock_users.append(new_user)
    
    # Datos del usuario sin contraseña
    user_data = {
        "id": new_user["id"],
        "email": new_user["email"],
        "first_name": new_user["first_name"],
        "last_name": new_user["last_name"],
        "is_active": new_user["is_active"]
    }
    
    return user_data

@app.get("/api/v1/auth/me")
def get_current_user():
    """👤 Obtener información del usuario actual"""
    # En un servidor real verificaríamos el token
    # Por simplicidad, devolvemos el usuario admin
    user_data = {
        "id": 1,
        "email": "admin@maestro.com",
        "first_name": "Admin",
        "last_name": "Maestro",
        "is_active": True
    }
    
    return user_data

@app.post("/api/v1/auth/logout")
def logout():
    """🚪 Cerrar sesión"""
    return {"message": "✅ Sesión cerrada exitosamente"}

@app.get("/api/v1/auth/test")
def auth_test():
    """🧪 Test de autenticación"""
    return {
        "message": "✅ Endpoints de autenticación funcionando",
        "test_users": [
            {"email": "admin@maestro.com", "password": "123456", "role": "admin"},
            {"email": "user@maestro.com", "password": "123456", "role": "user"}
        ]
    }


# ============================================================================
# BUSINESS ENDPOINTS
# ============================================================================

@app.get("/api/v1/businesses")
def get_businesses():
    """🏢 Obtener lista de negocios"""
    return mock_businesses

@app.post("/api/v1/businesses")
def create_business(business_data: dict):
    """🏢 Crear nuevo negocio"""
    new_business = {
        "id": len(mock_businesses) + 1,
        "name": business_data.get("name", "Nuevo Negocio"),
        "description": business_data.get("description", ""),
        "code": business_data.get("code", f"NEG{len(mock_businesses) + 1:03d}"),
        "is_active": True,
        "created_at": datetime.utcnow().isoformat()
    }
    mock_businesses.append(new_business)
    return new_business

@app.get("/api/v1/warehouses")
def get_all_warehouses():
    """📦 Obtener todos los almacenes (alias para compatibilidad)"""
    return mock_warehouses

@app.get("/api/v1/products")
def get_all_products():
    """📋 Obtener todos los productos (alias para compatibilidad)"""
    return mock_products

@app.get("/api/v1/units")
def get_all_units():
    """📏 Obtener todas las unidades (alias para compatibilidad)"""
    return mock_units


if __name__ == "__main__":
    import uvicorn
    import socket
    import sys
    
    def is_port_in_use(port):
        """Verificar si un puerto está en uso"""
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            return s.connect_ex(('localhost', port)) == 0
    
    def find_available_port(start_port=8000):
        """Encontrar un puerto disponible"""
        port = start_port
        while port < start_port + 10:
            if not is_port_in_use(port):
                return port
            port += 1
        return None
    
    # Verificar puerto disponible
    desired_port = 8000
    if is_port_in_use(desired_port):
        print(f"⚠️  Puerto {desired_port} está ocupado, buscando puerto disponible...")
        available_port = find_available_port(8001)
        if available_port:
            print(f"✅ Usando puerto alternativo: {available_port}")
            desired_port = available_port
        else:
            print("❌ No se encontraron puertos disponibles en el rango 8001-8010")
            print("💡 Intenta cerrar otros servidores o usar: taskkill /F /IM python.exe")
            sys.exit(1)
    
    print("🚀 Iniciando servidor de pruebas Maestro Inventario...")
    print(f"📖 Documentación disponible en: http://localhost:{desired_port}/docs")
    print(f"🌐 API Base URL: http://localhost:{desired_port}/api/v1")
    print("🧪 Endpoints multi-item listos para pruebas")
    print("🔐 Autenticación habilitada - Usuarios de prueba:")
    print("   📧 admin@maestro.com | 🔑 123456 (Administrador)")
    print("   📧 user@maestro.com  | 🔑 123456 (Usuario)")
    print("=" * 60)
    
    try:
        uvicorn.run(app, host="0.0.0.0", port=desired_port, log_level="info")
    except Exception as e:
        print(f"❌ Error al iniciar servidor: {e}")
        print("💡 Sugerencias:")
        print("   - Verifica que no haya otros servidores corriendo")
        print("   - Ejecuta: taskkill /F /IM python.exe")
        print("   - Usa un puerto diferente: python simple_server.py --port 8001")
        sys.exit(1)
