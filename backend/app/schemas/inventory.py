from typing import Optional, List, Dict, Any
from datetime import datetime
from pydantic import BaseModel, Field, validator
from enum import Enum


# Enums
class MovementType(str, Enum):
    ENTRY = "entry"
    EXIT = "exit"
    ADJUSTMENT = "adjustment"
    TRANSFER = "transfer"


class AlertType(str, Enum):
    LOW_STOCK = "low_stock"
    OUT_OF_STOCK = "out_of_stock"
    OVERSTOCK = "overstock"


class AdjustmentType(str, Enum):
    PHYSICAL_COUNT = "physical_count"
    LOSS = "loss"
    DAMAGE = "damage"
    CORRECTION = "correction"


class AdjustmentStatus(str, Enum):
    DRAFT = "draft"
    APPROVED = "approved"
    APPLIED = "applied"


# Product Schemas with Inventory Info
class ProductWithInventory(BaseModel):
    id: int
    name: str
    description: Optional[str] = None
    sku: Optional[str] = None
    barcode: Optional[str] = None
    category: Optional[str] = None
    brand: Optional[str] = None
    image_url: Optional[str] = None
    is_active: bool
    base_unit: dict
    current_stock: float = 0
    minimum_stock: float = 0
    maximum_stock: Optional[float] = None
    has_low_stock: bool = False
    variants: List[dict] = []
    
    class Config:
        from_attributes = True


# Inventory Movement Schemas
class InventoryMovementBase(BaseModel):
    warehouse_id: int = Field(..., description="ID del almacén donde se realiza el movimiento")
    product_variant_id: int = Field(..., description="ID de la variante del producto")
    unit_id: int = Field(..., description="ID de la unidad de medida")
    movement_type: MovementType
    quantity: float = Field(..., gt=0, description="Cantidad del movimiento (siempre positiva)")
    reference_type: Optional[str] = Field(None, description="Tipo de referencia (sale, purchase, adjustment)")
    reference_id: Optional[int] = Field(None, description="ID de la referencia")
    reason: Optional[str] = Field(None, description="Razón del movimiento")
    notes: Optional[str] = Field(None, description="Notas adicionales")


class InventoryMovementCreate(InventoryMovementBase):
    pass


# Single Item Entry/Exit Schemas


class InventoryEntryCreate(BaseModel):
    """Esquema específico para entradas de inventario individuales"""
    warehouse_id: int = Field(..., description="ID del almacén donde se registra la entrada")
    product_variant_id: int = Field(..., description="ID de la variante del producto")
    unit_id: int = Field(..., description="ID de la unidad de medida")
    quantity: float = Field(..., gt=0, description="Cantidad a ingresar")
    cost_per_unit: Optional[float] = Field(None, description="Costo por unidad")
    supplier_id: Optional[int] = Field(None, description="ID del proveedor")
    purchase_order_id: Optional[int] = Field(None, description="ID de la orden de compra")
    expiry_date: Optional[datetime] = Field(None, description="Fecha de vencimiento")
    batch_number: Optional[str] = Field(None, description="Número de lote")
    reason: Optional[str] = Field(None, description="Razón de la entrada")
    notes: Optional[str] = Field(None, description="Notas adicionales")


class InventoryExitCreate(BaseModel):
    """Esquema específico para salidas de inventario"""
    warehouse_id: int = Field(..., description="ID del almacén donde se registra la salida")
    product_variant_id: int = Field(..., description="ID de la variante del producto")
    unit_id: int = Field(..., description="ID de la unidad de medida")
    quantity: float = Field(..., gt=0, description="Cantidad a sacar")
    customer_id: Optional[int] = Field(None, description="ID del cliente")
    sale_id: Optional[int] = Field(None, description="ID de la venta")
    destination_warehouse_id: Optional[int] = Field(None, description="ID del almacén destino (para transferencias)")
    reason: Optional[str] = Field(None, description="Razón de la salida")
    notes: Optional[str] = Field(None, description="Notas adicionales")


# Multi-Item Entry Schemas
class InventoryEntryItemCreate(BaseModel):
    """Item individual para entrada multi-producto"""
    product_variant_id: int = Field(..., description="ID de la variante del producto")
    unit_id: int = Field(..., description="ID de la unidad de medida")
    quantity: float = Field(..., gt=0, description="Cantidad a ingresar")
    cost_per_unit: Optional[float] = Field(None, description="Costo por unidad")
    expiry_date: Optional[datetime] = Field(None, description="Fecha de vencimiento")
    batch_number: Optional[str] = Field(None, description="Número de lote")
    notes: Optional[str] = Field(None, description="Notas del item")


class InventoryEntryMultiCreate(BaseModel):
    """Esquema para entradas de inventario con múltiples productos"""
    warehouse_id: int = Field(..., description="ID del almacén donde se registra la entrada")
    supplier_id: Optional[int] = Field(None, description="ID del proveedor")
    purchase_order_id: Optional[int] = Field(None, description="ID de la orden de compra")
    reference_number: Optional[str] = Field(None, description="Número de referencia del documento")
    reason: Optional[str] = Field(None, description="Razón de la entrada")
    notes: Optional[str] = Field(None, description="Notas generales")
    items: List[InventoryEntryItemCreate] = Field(..., min_items=1, description="Lista de productos a ingresar")


# Multi-Item Exit Schemas
class InventoryExitItemCreate(BaseModel):
    """Item individual para salida multi-producto"""
    product_variant_id: int = Field(..., description="ID de la variante del producto")
    unit_id: int = Field(..., description="ID de la unidad de medida")
    quantity: float = Field(..., gt=0, description="Cantidad a sacar")
    unit_price: Optional[float] = Field(None, description="Precio unitario de venta")
    notes: Optional[str] = Field(None, description="Notas del item")


class InventoryExitMultiCreate(BaseModel):
    """Esquema para salidas de inventario con múltiples productos"""
    warehouse_id: int = Field(..., description="ID del almacén donde se registra la salida")
    customer_id: Optional[int] = Field(None, description="ID del cliente")
    sale_id: Optional[int] = Field(None, description="ID de la venta")
    destination_warehouse_id: Optional[int] = Field(None, description="ID del almacén destino (para transferencias)")
    reference_number: Optional[str] = Field(None, description="Número de referencia del documento")
    reason: Optional[str] = Field(None, description="Razón de la salida")
    notes: Optional[str] = Field(None, description="Notas generales")
    items: List[InventoryExitItemCreate] = Field(..., min_items=1, description="Lista de productos a sacar")


class InventoryMovement(InventoryMovementBase):
    id: int
    previous_quantity: float
    new_quantity: float
    user_id: int
    created_at: datetime
    
    # Optional related data (will be included if loaded with joinedload)
    warehouse: Optional[dict] = None
    product_variant: Optional[dict] = None
    unit: Optional[dict] = None
    user: Optional[dict] = None

    class Config:
        from_attributes = True


# Stock Alert Schemas
class StockAlertBase(BaseModel):
    warehouse_id: int
    product_variant_id: int
    alert_type: AlertType
    current_quantity: float
    minimum_quantity: Optional[float] = None
    maximum_quantity: Optional[float] = None


class StockAlert(StockAlertBase):
    id: int
    is_resolved: bool
    resolved_at: Optional[datetime] = None
    created_at: datetime
    product_variant: dict
    warehouse: dict

    class Config:
        from_attributes = True


# Inventory Adjustment Schemas
class InventoryAdjustmentItemBase(BaseModel):
    product_variant_id: int
    unit_id: int
    expected_quantity: float
    actual_quantity: float
    unit_cost: Optional[float] = None


class InventoryAdjustmentItemCreate(InventoryAdjustmentItemBase):
    pass


class InventoryAdjustmentItem(InventoryAdjustmentItemBase):
    id: int
    adjustment_id: int
    difference: float
    total_cost_impact: Optional[float] = None
    product_variant: dict
    unit: dict

    class Config:
        from_attributes = True


class InventoryAdjustmentBase(BaseModel):
    warehouse_id: int
    adjustment_type: AdjustmentType
    reason: str
    notes: Optional[str] = None


class InventoryAdjustmentCreate(InventoryAdjustmentBase):
    items: List[InventoryAdjustmentItemCreate]


class InventoryAdjustmentSimpleCreate(BaseModel):
    """Esquema específico para ajustes de inventario individuales"""
    warehouse_id: int = Field(..., description="ID del almacén donde se realiza el ajuste")
    product_variant_id: int = Field(..., description="ID de la variante del producto")
    unit_id: int = Field(..., description="ID de la unidad de medida")
    current_quantity: float = Field(..., description="Cantidad actual en sistema")
    actual_quantity: float = Field(..., description="Cantidad real contada")
    adjustment_type: AdjustmentType = Field(..., description="Tipo de ajuste")
    unit_cost: Optional[float] = Field(None, description="Costo unitario")
    reason: Optional[str] = Field(None, description="Razón del ajuste")
    notes: Optional[str] = Field(None, description="Notas adicionales")
    
    @property
    def adjustment_quantity(self) -> float:
        """Calcula la cantidad del ajuste (diferencia)"""
        return self.actual_quantity - self.current_quantity


class InventoryAdjustmentUpdate(BaseModel):
    reason: Optional[str] = None
    notes: Optional[str] = None
    items: Optional[List[InventoryAdjustmentItemCreate]] = None


class InventoryAdjustment(InventoryAdjustmentBase):
    id: int
    adjustment_number: str
    status: AdjustmentStatus
    user_id: int
    approved_by: Optional[int] = None
    approved_at: Optional[datetime] = None
    applied_at: Optional[datetime] = None
    created_at: datetime
    items: List[InventoryAdjustmentItem] = []
    warehouse: dict
    user: dict
    approver: Optional[dict] = None

    class Config:
        from_attributes = True


# Purchase Order Schemas (Enhanced)
class PurchaseOrderItemReceive(BaseModel):
    purchase_order_item_id: int
    received_quantity: float
    notes: Optional[str] = None


class PurchaseOrderReceive(BaseModel):
    purchase_order_id: int
    warehouse_id: int
    items: List[PurchaseOrderItemReceive]
    notes: Optional[str] = None


# Inventory Reports Schemas
class LowStockReport(BaseModel):
    warehouse_id: Optional[int] = None
    category: Optional[str] = None
    products: List[ProductWithInventory]
    total_products: int
    generated_at: datetime


class InventoryMovementReport(BaseModel):
    warehouse_id: Optional[int] = None
    product_id: Optional[int] = None
    start_date: datetime
    end_date: datetime
    movements: List[InventoryMovement]
    total_entries: int
    total_exits: int
    total_adjustments: int


class InventoryValueReport(BaseModel):
    warehouse_id: Optional[int] = None
    total_items: int
    total_value: float
    products: List[dict]
    generated_at: datetime


# Search and Filter Schemas
class ProductSearchFilters(BaseModel):
    search: Optional[str] = None
    category: Optional[str] = None
    brand: Optional[str] = None
    has_stock: Optional[bool] = None
    low_stock_only: Optional[bool] = None
    warehouse_id: Optional[int] = None
    is_active: Optional[bool] = True
    skip: int = 0
    limit: int = 50


class InventoryMovementFilters(BaseModel):
    warehouse_id: Optional[int] = None
    product_variant_id: Optional[int] = None
    movement_type: Optional[MovementType] = None
    start_date: Optional[datetime] = None
    end_date: Optional[datetime] = None
    skip: int = 0
    limit: int = 50


# Bulk Operations Schemas
class BulkStockUpdate(BaseModel):
    updates: List[dict] = Field(..., description="List of {product_variant_id, warehouse_id, quantity}")
    reason: str
    notes: Optional[str] = None


class BulkPriceUpdate(BaseModel):
    updates: List[dict] = Field(..., description="List of {product_variant_id, price, cost}")
    reason: str


# Dashboard Schemas
class InventoryDashboard(BaseModel):
    total_products: int
    total_variants: int
    low_stock_alerts: int
    out_of_stock_alerts: int
    recent_movements: List[InventoryMovement]
    top_selling_products: List[dict]
    inventory_value: float
    warehouses_summary: List[dict]


class InventoryTransferCreate(BaseModel):
    """Esquema específico para transferencias entre almacenes"""
    source_warehouse_id: int = Field(..., description="ID del almacén origen")
    destination_warehouse_id: int = Field(..., description="ID del almacén destino")
    product_variant_id: int = Field(..., description="ID de la variante del producto")
    unit_id: int = Field(..., description="ID de la unidad de medida")
    quantity: float = Field(..., gt=0, description="Cantidad a transferir")
    reason: Optional[str] = Field(None, description="Razón de la transferencia")
    notes: Optional[str] = Field(None, description="Notas adicionales")
    
    @validator('destination_warehouse_id')
    def validate_different_warehouses(cls, v, values):
        if 'source_warehouse_id' in values and v == values['source_warehouse_id']:
            raise ValueError('El almacén destino debe ser diferente al almacén origen')
        return v


# Multi-Item Adjustment Schemas
class InventoryAdjustmentItemCreate(BaseModel):
    """Item individual para ajuste multi-producto"""
    product_variant_id: int = Field(..., description="ID de la variante del producto")
    unit_id: int = Field(..., description="ID de la unidad de medida")
    quantity_adjustment: float = Field(..., description="Cantidad del ajuste (+ para agregar, - para quitar)")
    reason: Optional[str] = Field(None, description="Razón específica del ajuste para este item")
    cost_adjustment: Optional[float] = Field(None, description="Ajuste del costo")
    notes: Optional[str] = Field(None, description="Notas del item")


class InventoryAdjustmentMultiCreate(BaseModel):
    """Esquema para ajustes de inventario con múltiples productos"""
    warehouse_id: int = Field(..., description="ID del almacén donde se registra el ajuste")
    reference_number: Optional[str] = Field(None, description="Número de referencia del documento")
    reason: Optional[str] = Field(None, description="Razón general del ajuste")
    notes: Optional[str] = Field(None, description="Notas generales")
    items: List[InventoryAdjustmentItemCreate] = Field(..., min_items=1, description="Lista de productos a ajustar")


# Response Schemas for Multi-Item Operations
class InventoryMovementItemResponse(BaseModel):
    """Respuesta de un item de movimiento procesado"""
    id: int
    product_variant_id: int
    unit_id: int
    quantity: float
    cost_per_unit: Optional[float] = None
    unit_price: Optional[float] = None
    expiry_date: Optional[datetime] = None
    batch_number: Optional[str] = None
    notes: Optional[str] = None
    created_at: datetime
    
    class Config:
        from_attributes = True


class InventoryMovementMultiResponse(BaseModel):
    """Respuesta de un movimiento multi-item procesado"""
    id: int
    warehouse_id: int
    movement_type: str  # Cambiado de InventoryMovementType a str
    reference_number: Optional[str] = None
    supplier_id: Optional[int] = None
    customer_id: Optional[int] = None
    purchase_order_id: Optional[int] = None
    sale_id: Optional[int] = None
    destination_warehouse_id: Optional[int] = None
    reason: Optional[str] = None
    notes: Optional[str] = None
    total_items: int
    total_value: Optional[float] = None
    status: str = "completed"
    items: List[InventoryMovementItemResponse]
    created_at: datetime
    created_by: int
    
    class Config:
        from_attributes = True


class InventoryBatchOperationSummary(BaseModel):
    """Resumen de una operación en lote"""
    total_items: int
    successful_items: int
    failed_items: int
    total_value: Optional[float] = None
    warnings: List[str] = []
    errors: List[str] = []
    movement_id: Optional[int] = None



