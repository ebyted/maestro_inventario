from typing import Optional, List, Dict, Any
from datetime import datetime
from pydantic import BaseModel, EmailStr


# Business Schemas
class BusinessBase(BaseModel):
    name: str
    rfc: Optional[str] = None
    address: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[EmailStr] = None


class BusinessCreate(BusinessBase):
    pass


class BusinessUpdate(BusinessBase):
    name: Optional[str] = None
    rfc: Optional[str] = None


class Business(BusinessBase):
    id: int
    is_active: bool
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# Warehouse Schemas
class WarehouseBase(BaseModel):
    name: str
    location: Optional[str] = None


class WarehouseCreate(WarehouseBase):
    business_id: int


class WarehouseUpdate(WarehouseBase):
    name: Optional[str] = None


class Warehouse(WarehouseBase):
    id: int
    business_id: int
    is_active: bool
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# Unit Schemas
class UnitBase(BaseModel):
    name: str
    abbreviation: str
    conversion_to_base: float = 1.0
    is_base: bool = False


class UnitCreate(UnitBase):
    pass


class UnitUpdate(UnitBase):
    name: Optional[str] = None
    abbreviation: Optional[str] = None
    conversion_to_base: Optional[float] = None
    is_base: Optional[bool] = None


class Unit(UnitBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True


# Product Schemas
class ProductBase(BaseModel):
    name: str
    description: Optional[str] = None
    sku: Optional[str] = None
    barcode: Optional[str] = None
    minimum_stock: Optional[float] = None
    maximum_stock: Optional[float] = None


class ProductCreate(ProductBase):
    business_id: int
    category_id: Optional[int] = None
    brand_id: Optional[int] = None
    base_unit_id: Optional[int] = None


class ProductUpdate(ProductBase):
    name: Optional[str] = None
    category_id: Optional[int] = None
    brand_id: Optional[int] = None
    base_unit_id: Optional[int] = None


class Product(ProductBase):
    id: int
    business_id: int
    category_id: Optional[int] = None
    brand_id: Optional[int] = None
    base_unit_id: Optional[int] = None
    is_active: bool
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# Product Variant Schemas
class ProductVariantBase(BaseModel):
    attributes: Optional[Dict[str, Any]] = None
    sku: Optional[str] = None
    barcode: Optional[str] = None
    price: Optional[float] = None
    cost: Optional[float] = None


class ProductVariantCreate(ProductVariantBase):
    product_id: int
    unit_id: int


class ProductVariantUpdate(ProductVariantBase):
    unit_id: Optional[int] = None


class ProductVariant(ProductVariantBase):
    id: int
    product_id: int
    unit_id: int
    is_active: bool
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# Inventory Schemas
class InventoryBase(BaseModel):
    quantity: float = 0.0
    minimum_stock: float = 0.0
    maximum_stock: Optional[float] = None


class InventoryCreate(InventoryBase):
    warehouse_id: int
    product_variant_id: int
    unit_id: int


class InventoryUpdate(InventoryBase):
    quantity: Optional[float] = None
    minimum_stock: Optional[float] = None
    maximum_stock: Optional[float] = None


class Inventory(InventoryBase):
    id: int
    warehouse_id: int
    product_variant_id: int
    unit_id: int
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# Supplier Schemas
class SupplierBase(BaseModel):
    name: str
    rfc: Optional[str] = None
    contact_name: Optional[str] = None
    phones: Optional[List[str]] = None
    email: Optional[EmailStr] = None
    addresses: Optional[List[Dict[str, str]]] = None


class SupplierCreate(SupplierBase):
    pass


class SupplierUpdate(SupplierBase):
    name: Optional[str] = None


class Supplier(SupplierBase):
    id: int
    is_active: bool
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# Purchase Order Schemas
class PurchaseOrderItemBase(BaseModel):
    product_variant_id: int
    unit_id: int
    quantity: float
    unit_price: float
    total_price: float


class PurchaseOrderItemCreate(PurchaseOrderItemBase):
    pass


class PurchaseOrderItem(PurchaseOrderItemBase):
    id: int
    purchase_order_id: int

    class Config:
        from_attributes = True


class PurchaseOrderBase(BaseModel):
    supplier_id: int
    order_number: str
    notes: Optional[str] = None


class PurchaseOrderCreate(PurchaseOrderBase):
    business_id: int
    items: List[PurchaseOrderItemCreate]


class PurchaseOrderUpdate(BaseModel):
    status: Optional[str] = None
    notes: Optional[str] = None


class PurchaseOrder(PurchaseOrderBase):
    id: int
    business_id: int
    date: datetime
    status: str
    subtotal: float
    tax: float
    total: float
    created_at: datetime
    updated_at: Optional[datetime] = None
    items: List[PurchaseOrderItem] = []

    class Config:
        from_attributes = True


# User Schemas
class UserBase(BaseModel):
    email: EmailStr
    first_name: str
    last_name: str


class UserCreate(UserBase):
    password: str


class UserUpdate(UserBase):
    email: Optional[EmailStr] = None
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    password: Optional[str] = None


class User(UserBase):
    id: int
    is_active: bool
    is_superuser: bool
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# User Role Schemas
class UserRoleBase(BaseModel):
    role: str
    permissions: Optional[List[str]] = None


class UserRoleCreate(UserRoleBase):
    user_id: int
    business_id: int


class UserRoleUpdate(UserRoleBase):
    role: Optional[str] = None


class UserRole(UserRoleBase):
    id: int
    user_id: int
    business_id: int
    created_at: datetime

    class Config:
        from_attributes = True


# Sale Schemas
class SaleItemBase(BaseModel):
    product_variant_id: int
    unit_id: int
    quantity: float
    unit_price: float
    total_price: float


class SaleItemCreate(SaleItemBase):
    pass


class SaleItem(SaleItemBase):
    id: int
    sale_id: int

    class Config:
        from_attributes = True


class SaleBase(BaseModel):
    payment_method: str
    customer_name: Optional[str] = None
    customer_email: Optional[EmailStr] = None
    notes: Optional[str] = None


class SaleCreate(SaleBase):
    warehouse_id: int
    items: List[SaleItemCreate]


class Sale(SaleBase):
    id: int
    warehouse_id: int
    user_id: int
    sale_number: str
    date: datetime
    subtotal: float
    tax: float
    discount: float
    total: float
    created_at: datetime
    items: List[SaleItem] = []

    class Config:
        from_attributes = True


# Auth Schemas
class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    email: Optional[str] = None


class UserLoginRequest(BaseModel):
    email: EmailStr
    password: str


# Import inventory schemas
from .inventory import (
    MovementType, AlertType, AdjustmentType, AdjustmentStatus,
    ProductWithInventory, 
    InventoryMovementBase, InventoryMovementCreate, InventoryMovement,
    StockAlertBase, StockAlert,
    InventoryAdjustmentItemBase, InventoryAdjustmentItemCreate, InventoryAdjustmentItem,
    InventoryAdjustmentBase, InventoryAdjustmentCreate, InventoryAdjustmentUpdate, InventoryAdjustment,
    PurchaseOrderItemReceive, PurchaseOrderReceive,
    LowStockReport, InventoryMovementReport, InventoryValueReport,
    ProductSearchFilters, InventoryMovementFilters,
    BulkStockUpdate, BulkPriceUpdate,
    InventoryDashboard
)
