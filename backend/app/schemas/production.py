from pydantic import BaseModel, EmailStr
from typing import Optional, List
from datetime import datetime
from enum import Enum

# Enums
class UserRole(str, Enum):
    ADMIN = "admin"
    MANAGER = "manager"
    EMPLOYEE = "employee"
    VIEWER = "viewer"

class MovementType(str, Enum):
    ENTRY = "entry"
    EXIT = "exit"
    ADJUSTMENT = "adjustment"
    TRANSFER = "transfer"

class PurchaseOrderStatus(str, Enum):
    DRAFT = "draft"
    PENDING = "pending"
    APPROVED = "approved"
    ORDERED = "ordered"
    PARTIALLY_RECEIVED = "partially_received"
    RECEIVED = "received"
    CANCELLED = "cancelled"

class PaymentTerms(str, Enum):
    CASH = "cash"
    NET_15 = "net_15"
    NET_30 = "net_30"
    NET_60 = "net_60"
    NET_90 = "net_90"

# Auth Schemas
class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"

class UserCreate(BaseModel):
    email: EmailStr
    password: str
    first_name: str
    last_name: str
    role: UserRole = UserRole.EMPLOYEE

class UserUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    role: Optional[UserRole] = None
    is_active: Optional[bool] = None

class UserResponse(BaseModel):
    id: int
    email: str
    first_name: str
    last_name: str
    role: UserRole
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

# Business Schemas
class BusinessCreate(BaseModel):
    name: str
    description: Optional[str] = None
    code: str
    tax_id: Optional[str] = None
    address: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[EmailStr] = None

class BusinessUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    code: Optional[str] = None
    tax_id: Optional[str] = None
    address: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[EmailStr] = None
    is_active: Optional[bool] = None

class BusinessResponse(BaseModel):
    id: int
    name: str
    description: Optional[str]
    code: str
    tax_id: Optional[str]
    address: Optional[str]
    phone: Optional[str]
    email: Optional[str]
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

# Category Schemas
class CategoryCreate(BaseModel):
    name: str
    description: Optional[str] = None
    code: Optional[str] = None
    parent_id: Optional[int] = None

class CategoryUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    code: Optional[str] = None
    parent_id: Optional[int] = None
    is_active: Optional[bool] = None

class CategoryResponse(BaseModel):
    id: int
    business_id: int
    name: str
    description: Optional[str]
    code: Optional[str]
    parent_id: Optional[int]
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

# Brand Schemas
class BrandCreate(BaseModel):
    name: str
    description: Optional[str] = None
    code: Optional[str] = None
    country: Optional[str] = None

class BrandUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    code: Optional[str] = None
    country: Optional[str] = None
    is_active: Optional[bool] = None

class BrandResponse(BaseModel):
    id: int
    business_id: int
    name: str
    description: Optional[str]
    code: Optional[str]
    country: Optional[str]
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

# Warehouse Schemas
class WarehouseCreate(BaseModel):
    name: str
    description: Optional[str] = None
    code: Optional[str] = None
    address: Optional[str] = None

class WarehouseUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    code: Optional[str] = None
    address: Optional[str] = None
    is_active: Optional[bool] = None

class WarehouseResponse(BaseModel):
    id: int
    business_id: int
    name: str
    description: Optional[str]
    code: Optional[str]
    address: Optional[str]
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

# Product Schemas
class ProductVariantCreate(BaseModel):
    name: Optional[str] = None
    sku: str
    barcode: Optional[str] = None
    attributes: Optional[str] = None  # JSON string
    cost_price: Optional[float] = None
    selling_price: Optional[float] = None

class ProductVariantResponse(BaseModel):
    id: int
    product_id: int
    name: Optional[str]
    sku: str
    barcode: Optional[str]
    attributes: Optional[str]
    cost_price: Optional[float]
    selling_price: Optional[float]
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

class ProductCreate(BaseModel):
    category_id: Optional[int] = None
    brand_id: Optional[int] = None
    name: str
    description: Optional[str] = None
    sku: str
    barcode: Optional[str] = None
    base_unit_id: int
    minimum_stock: float = 0
    maximum_stock: Optional[float] = None
    variants: List[ProductVariantCreate] = []

class ProductUpdate(BaseModel):
    category_id: Optional[int] = None
    brand_id: Optional[int] = None
    name: Optional[str] = None
    description: Optional[str] = None
    sku: Optional[str] = None
    barcode: Optional[str] = None
    base_unit_id: Optional[int] = None
    minimum_stock: Optional[float] = None
    maximum_stock: Optional[float] = None
    is_active: Optional[bool] = None

class ProductResponse(BaseModel):
    id: int
    business_id: int
    category_id: Optional[int]
    brand_id: Optional[int]
    name: str
    description: Optional[str]
    sku: str
    barcode: Optional[str]
    base_unit_id: int
    minimum_stock: float
    maximum_stock: Optional[float]
    is_active: bool
    created_at: datetime
    variants: List[ProductVariantResponse] = []
    category: Optional[CategoryResponse] = None
    brand: Optional[BrandResponse] = None
    
    class Config:
        from_attributes = True

# Inventory Movement Schemas
class InventoryMovementCreate(BaseModel):
    warehouse_id: int
    product_variant_id: int
    unit_id: int
    movement_type: MovementType
    quantity: float
    cost_per_unit: Optional[float] = None
    batch_number: Optional[str] = None
    expiry_date: Optional[datetime] = None
    reference_number: Optional[str] = None
    reason: Optional[str] = None
    notes: Optional[str] = None
    destination_warehouse_id: Optional[int] = None  # For transfers

class InventoryMovementResponse(BaseModel):
    id: int
    warehouse_id: int
    product_variant_id: int
    unit_id: int
    user_id: int
    movement_type: MovementType
    quantity: float
    cost_per_unit: Optional[float]
    previous_quantity: Optional[float]
    new_quantity: Optional[float]
    batch_number: Optional[str]
    expiry_date: Optional[datetime]
    reference_number: Optional[str]
    reason: Optional[str]
    notes: Optional[str]
    destination_warehouse_id: Optional[int]
    created_at: datetime
    
    # Related data
    warehouse_name: Optional[str] = None
    product_name: Optional[str] = None
    category: Optional[str] = None
    brand: Optional[str] = None
    unit_symbol: Optional[str] = None
    user_name: Optional[str] = None
    
    class Config:
        from_attributes = True

# Multi-item Movement Schemas
class InventoryMovementItem(BaseModel):
    product_variant_id: int
    unit_id: int
    quantity: float
    cost_per_unit: Optional[float] = None
    batch_number: Optional[str] = None
    expiry_date: Optional[datetime] = None
    notes: Optional[str] = None

class InventoryMovementMultiCreate(BaseModel):
    warehouse_id: int
    movement_type: MovementType
    reference_number: Optional[str] = None
    reason: Optional[str] = None
    notes: Optional[str] = None
    items: List[InventoryMovementItem]
    destination_warehouse_id: Optional[int] = None  # For transfers

# Supplier Schemas
class SupplierCreate(BaseModel):
    name: str
    company_name: Optional[str] = None
    tax_id: Optional[str] = None
    email: Optional[EmailStr] = None
    phone: Optional[str] = None
    mobile: Optional[str] = None
    website: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    postal_code: Optional[str] = None
    country: Optional[str] = None
    payment_terms: PaymentTerms = PaymentTerms.NET_30
    credit_limit: Optional[float] = None
    discount_percentage: float = 0.0
    contact_person: Optional[str] = None
    contact_title: Optional[str] = None
    contact_email: Optional[EmailStr] = None
    contact_phone: Optional[str] = None
    notes: Optional[str] = None

class SupplierUpdate(BaseModel):
    name: Optional[str] = None
    company_name: Optional[str] = None
    tax_id: Optional[str] = None
    email: Optional[EmailStr] = None
    phone: Optional[str] = None
    mobile: Optional[str] = None
    website: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    state: Optional[str] = None
    postal_code: Optional[str] = None
    country: Optional[str] = None
    payment_terms: Optional[PaymentTerms] = None
    credit_limit: Optional[float] = None
    discount_percentage: Optional[float] = None
    contact_person: Optional[str] = None
    contact_title: Optional[str] = None
    contact_email: Optional[EmailStr] = None
    contact_phone: Optional[str] = None
    notes: Optional[str] = None
    is_active: Optional[bool] = None

class SupplierResponse(BaseModel):
    id: int
    business_id: int
    name: str
    company_name: Optional[str]
    tax_id: Optional[str]
    email: Optional[str]
    phone: Optional[str]
    mobile: Optional[str]
    website: Optional[str]
    address: Optional[str]
    city: Optional[str]
    state: Optional[str]
    postal_code: Optional[str]
    country: Optional[str]
    payment_terms: PaymentTerms
    credit_limit: Optional[float]
    discount_percentage: float
    contact_person: Optional[str]
    contact_title: Optional[str]
    contact_email: Optional[str]
    contact_phone: Optional[str]
    is_active: bool
    notes: Optional[str]
    created_at: datetime
    
    class Config:
        from_attributes = True

# Purchase Order Item Schemas
class PurchaseOrderItemCreate(BaseModel):
    product_variant_id: int
    unit_id: int
    quantity_ordered: float
    unit_cost: float
    notes: Optional[str] = None

class PurchaseOrderItemResponse(BaseModel):
    id: int
    purchase_order_id: int
    product_variant_id: int
    unit_id: int
    quantity_ordered: float
    quantity_received: float
    quantity_pending: Optional[float]
    unit_cost: float
    total_cost: Optional[float]
    product_name: Optional[str]
    product_sku: Optional[str]
    supplier_sku: Optional[str]
    notes: Optional[str]
    created_at: datetime
    
    class Config:
        from_attributes = True

# Purchase Order Schemas
class PurchaseOrderCreate(BaseModel):
    supplier_id: int
    warehouse_id: int
    order_number: str
    supplier_reference: Optional[str] = None
    expected_delivery_date: Optional[datetime] = None
    payment_terms: Optional[PaymentTerms] = None
    notes: Optional[str] = None
    internal_notes: Optional[str] = None
    items: List[PurchaseOrderItemCreate]

class PurchaseOrderUpdate(BaseModel):
    supplier_id: Optional[int] = None
    warehouse_id: Optional[int] = None
    supplier_reference: Optional[str] = None
    status: Optional[PurchaseOrderStatus] = None
    expected_delivery_date: Optional[datetime] = None
    actual_delivery_date: Optional[datetime] = None
    payment_terms: Optional[PaymentTerms] = None
    payment_status: Optional[str] = None
    notes: Optional[str] = None
    internal_notes: Optional[str] = None

class PurchaseOrderResponse(BaseModel):
    id: int
    business_id: int
    supplier_id: int
    warehouse_id: int
    user_id: int
    order_number: str
    supplier_reference: Optional[str]
    status: PurchaseOrderStatus
    order_date: datetime
    expected_delivery_date: Optional[datetime]
    actual_delivery_date: Optional[datetime]
    subtotal: float
    tax_amount: float
    shipping_cost: float
    discount_amount: float
    total_amount: float
    payment_terms: Optional[PaymentTerms]
    payment_status: str
    notes: Optional[str]
    internal_notes: Optional[str]
    created_at: datetime
    approved_at: Optional[datetime]
    approved_by_id: Optional[int]
    
    # Related data
    supplier: Optional[SupplierResponse] = None
    warehouse: Optional[WarehouseResponse] = None
    items: List[PurchaseOrderItemResponse] = []
    
    class Config:
        from_attributes = True

# Purchase Order Receipt Schemas
class PurchaseOrderReceiptItemCreate(BaseModel):
    purchase_order_item_id: int
    quantity_received: float
    quantity_accepted: Optional[float] = None
    quantity_rejected: float = 0.0
    batch_number: Optional[str] = None
    expiry_date: Optional[datetime] = None
    quality_status: str = "pending"
    notes: Optional[str] = None
    rejection_reason: Optional[str] = None

class PurchaseOrderReceiptCreate(BaseModel):
    purchase_order_id: int
    warehouse_id: int
    receipt_number: str
    supplier_invoice_number: Optional[str] = None
    supplier_delivery_note: Optional[str] = None
    notes: Optional[str] = None
    quality_notes: Optional[str] = None
    items: List[PurchaseOrderReceiptItemCreate]

class PurchaseOrderReceiptResponse(BaseModel):
    id: int
    purchase_order_id: int
    warehouse_id: int
    user_id: int
    receipt_number: str
    receipt_date: datetime
    supplier_invoice_number: Optional[str]
    supplier_delivery_note: Optional[str]
    status: str
    notes: Optional[str]
    quality_notes: Optional[str]
    created_at: datetime
    
    class Config:
        from_attributes = True
