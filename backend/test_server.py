"""
Servidor simple para probar los endpoints de inventario
"""
from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime
import uvicorn

# Importar los esquemas de inventario
try:
    from app.schemas.inventory import (
        InventoryEntryCreate, InventoryExitCreate, 
        InventoryTransferCreate, InventoryAdjustmentSimpleCreate,
        MovementType
    )
    print("✅ Esquemas de inventario importados correctamente")
except ImportError as e:
    print(f"❌ Error importando esquemas: {e}")
    # Esquemas básicos como fallback
    class InventoryEntryCreate(BaseModel):
        warehouse_id: int
        product_variant_id: int
        unit_id: int
        quantity: float
        cost_per_unit: Optional[float] = None
        reason: Optional[str] = None
        notes: Optional[str] = None

app = FastAPI(title="Maestro Inventario - Test API", version="1.0.0")

# Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mock data para pruebas
mock_warehouses = [
    {"id": 1, "name": "Almacén Principal", "code": "ALM001", "is_active": True},
    {"id": 2, "name": "Almacén Secundario", "code": "ALM002", "is_active": True},
    {"id": 3, "name": "Almacén de Productos Terminados", "code": "ALM003", "is_active": True}
]

mock_units = [
    {"id": 1, "name": "Unidad", "symbol": "UND", "type": "count"},
    {"id": 2, "name": "Kilogramo", "symbol": "KG", "type": "weight"},
    {"id": 3, "name": "Metro", "symbol": "M", "type": "length"},
    {"id": 4, "name": "Litro", "symbol": "L", "type": "volume"}
]

mock_products = [
    {
        "id": 1,
        "name": "Producto Ejemplo 1",
        "sku": "PROD001",
        "current_stock": 100,
        "variants": [{"id": 1, "current_stock": 100}]
    },
    {
        "id": 2,
        "name": "Producto Ejemplo 2",
        "sku": "PROD002",
        "current_stock": 50,
        "variants": [{"id": 2, "current_stock": 50}]
    }
]

# Contador para IDs de movimientos
movement_counter = 1

@app.get("/")
def read_root():
    return {
        "message": "Maestro Inventario - API de Pruebas",
        "status": "running",
        "endpoints": {
            "warehouses": "/api/v1/inventory/warehouses",
            "units": "/api/v1/inventory/units",
            "products": "/api/v1/inventory/products",
            "entry": "/api/v1/inventory/movements/entry",
            "exit": "/api/v1/inventory/movements/exit",
            "adjustment": "/api/v1/inventory/movements/adjustment",
            "transfer": "/api/v1/inventory/movements/transfer"
        }
    }

@app.get("/api/v1/inventory/warehouses")
def get_warehouses():
    """Obtener almacenes activos"""
    return mock_warehouses

@app.get("/api/v1/inventory/units")
def get_units():
    """Obtener unidades de medida"""
    return mock_units

@app.get("/api/v1/inventory/products")
def get_products():
    """Obtener productos con inventario"""
    return mock_products

@app.post("/api/v1/inventory/movements/entry")
def create_entry(entry_data: InventoryEntryCreate):
    """Crear entrada de inventario"""
    global movement_counter
    
    # Validar almacén
    warehouse = next((w for w in mock_warehouses if w["id"] == entry_data.warehouse_id), None)
    if not warehouse:
        raise HTTPException(status_code=404, detail="Almacén no encontrado")
    
    # Simular creación de movimiento
    movement = {
        "id": movement_counter,
        "warehouse_id": entry_data.warehouse_id,
        "product_variant_id": entry_data.product_variant_id,
        "unit_id": entry_data.unit_id,
        "movement_type": "entry",
        "quantity": entry_data.quantity,
        "previous_quantity": 100.0,  # Mock
        "new_quantity": 100.0 + entry_data.quantity,
        "reason": entry_data.reason,
        "notes": entry_data.notes,
        "user_id": 1,
        "created_at": datetime.utcnow().isoformat()
    }
    
    movement_counter += 1
    return movement

@app.post("/api/v1/inventory/movements/exit")
def create_exit(exit_data: dict):
    """Crear salida de inventario"""
    global movement_counter
    
    # Validar almacén
    warehouse = next((w for w in mock_warehouses if w["id"] == exit_data.get("warehouse_id")), None)
    if not warehouse:
        raise HTTPException(status_code=404, detail="Almacén no encontrado")
    
    # Validar stock suficiente
    if exit_data.get("quantity", 0) > 100:  # Mock validation
        raise HTTPException(status_code=400, detail="Stock insuficiente")
    
    # Simular creación de movimiento
    movement = {
        "id": movement_counter,
        "warehouse_id": exit_data.get("warehouse_id"),
        "product_variant_id": exit_data.get("product_variant_id"),
        "unit_id": exit_data.get("unit_id"),
        "movement_type": "exit",
        "quantity": exit_data.get("quantity"),
        "previous_quantity": 100.0,  # Mock
        "new_quantity": 100.0 - exit_data.get("quantity", 0),
        "reason": exit_data.get("reason"),
        "notes": exit_data.get("notes"),
        "user_id": 1,
        "created_at": datetime.utcnow().isoformat()
    }
    
    movement_counter += 1
    return movement

@app.post("/api/v1/inventory/movements/adjustment")
def create_adjustment(adjustment_data: dict):
    """Crear ajuste de inventario"""
    global movement_counter
    
    # Validar almacén
    warehouse = next((w for w in mock_warehouses if w["id"] == adjustment_data.get("warehouse_id")), None)
    if not warehouse:
        raise HTTPException(status_code=404, detail="Almacén no encontrado")
    
    # Simular creación de movimiento
    current_qty = adjustment_data.get("current_quantity", 100)
    actual_qty = adjustment_data.get("actual_quantity", 95)
    
    movement = {
        "id": movement_counter,
        "warehouse_id": adjustment_data.get("warehouse_id"),
        "product_variant_id": adjustment_data.get("product_variant_id"),
        "unit_id": adjustment_data.get("unit_id"),
        "movement_type": "adjustment",
        "quantity": abs(actual_qty - current_qty),
        "previous_quantity": current_qty,
        "new_quantity": actual_qty,
        "reason": adjustment_data.get("reason"),
        "notes": adjustment_data.get("notes"),
        "user_id": 1,
        "created_at": datetime.utcnow().isoformat()
    }
    
    movement_counter += 1
    return movement

@app.post("/api/v1/inventory/movements/transfer")
def create_transfer(transfer_data: dict):
    """Crear transferencia entre almacenes"""
    global movement_counter
    
    source_id = transfer_data.get("source_warehouse_id")
    dest_id = transfer_data.get("destination_warehouse_id")
    
    # Validar almacenes
    source_warehouse = next((w for w in mock_warehouses if w["id"] == source_id), None)
    dest_warehouse = next((w for w in mock_warehouses if w["id"] == dest_id), None)
    
    if not source_warehouse:
        raise HTTPException(status_code=404, detail="Almacén origen no encontrado")
    if not dest_warehouse:
        raise HTTPException(status_code=404, detail="Almacén destino no encontrado")
    if source_id == dest_id:
        raise HTTPException(status_code=400, detail="Los almacenes deben ser diferentes")
    
    quantity = transfer_data.get("quantity", 0)
    
    # Crear dos movimientos: salida y entrada
    exit_movement = {
        "id": movement_counter,
        "warehouse_id": source_id,
        "product_variant_id": transfer_data.get("product_variant_id"),
        "unit_id": transfer_data.get("unit_id"),
        "movement_type": "transfer",
        "quantity": quantity,
        "previous_quantity": 100.0,
        "new_quantity": 100.0 - quantity,
        "reason": transfer_data.get("reason"),
        "notes": transfer_data.get("notes"),
        "user_id": 1,
        "created_at": datetime.utcnow().isoformat()
    }
    
    movement_counter += 1
    
    entry_movement = {
        "id": movement_counter,
        "warehouse_id": dest_id,
        "product_variant_id": transfer_data.get("product_variant_id"),
        "unit_id": transfer_data.get("unit_id"),
        "movement_type": "transfer",
        "quantity": quantity,
        "previous_quantity": 50.0,
        "new_quantity": 50.0 + quantity,
        "reason": transfer_data.get("reason"),
        "notes": transfer_data.get("notes"),
        "user_id": 1,
        "created_at": datetime.utcnow().isoformat()
    }
    
    movement_counter += 1
    
    return [exit_movement, entry_movement]

@app.get("/health")
def health_check():
    return {"status": "healthy", "timestamp": datetime.utcnow().isoformat()}

if __name__ == "__main__":
    print("🚀 Iniciando servidor de pruebas de inventario...")
    print("📡 Servidor disponible en: http://localhost:8000")
    print("📋 Documentación API en: http://localhost:8000/docs")
    uvicorn.run(app, host="0.0.0.0", port=8000, reload=True)
