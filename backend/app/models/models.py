from sqlalchemy import Column, Integer, String, Boolean, DateTime, Text, ForeignKey, Float, Enum
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum

Base = declarative_base()

class UserRole(enum.Enum):
    ADMIN = "ADMIN"
    MANAGER = "MANAGER"
    EMPLOYEE = "EMPLOYEE"
    VIEWER = "VIEWER"
    ALMACENISTA = "ALMACENISTA"
    CAPTURISTA = "CAPTURISTA"

class MovementType(enum.Enum):
    ENTRY = "entry"
    EXIT = "exit"
    ADJUSTMENT = "adjustment"
    TRANSFER = "transfer"

class PurchaseOrderStatus(enum.Enum):
    DRAFT = "draft"
    PENDING = "pending"
    APPROVED = "approved"
    ORDERED = "ordered"
    PARTIALLY_RECEIVED = "partially_received"
    RECEIVED = "received"
    CANCELLED = "cancelled"

class PaymentTerms(enum.Enum):
    CASH = "cash"
    NET_15 = "net_15"
    NET_30 = "net_30"
    NET_60 = "net_60"
    NET_90 = "net_90"

class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(255), unique=True, index=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    role = Column(Enum(UserRole), default=UserRole.EMPLOYEE)
    is_active = Column(Boolean, default=True)
    is_superuser = Column(Boolean, default=False)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    business_users = relationship("BusinessUser", back_populates="user")

class Business(Base):
    __tablename__ = "businesses"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(200), nullable=False)
    description = Column(Text) 
    code = Column(String(50), unique=True, index=True)
    tax_id = Column(String(50))
    rfc = Column(String(50))  # RFC field that the application expects
    address = Column(Text)
    phone = Column(String(20))
    email = Column(String(255))
    is_active = Column(Boolean, default=True)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    business_users = relationship("BusinessUser", back_populates="business")
    warehouses = relationship("Warehouse", back_populates="business")
    categories = relationship("Category", back_populates="business")
    brands = relationship("Brand", back_populates="business")
    suppliers = relationship("Supplier", back_populates="business")
    purchase_orders = relationship("PurchaseOrder", back_populates="business")

class BusinessUser(Base):
    __tablename__ = "business_users"
    
    id = Column(Integer, primary_key=True, index=True)
    business_id = Column(Integer, ForeignKey("businesses.id"), nullable=False)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    role = Column(Enum(UserRole), default=UserRole.EMPLOYEE)
    is_active = Column(Boolean, default=True)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relationships
    business = relationship("Business", back_populates="business_users")
    user = relationship("User", back_populates="business_users")

class Category(Base):
    __tablename__ = "categories"
    
    id = Column(Integer, primary_key=True, index=True)
    business_id = Column(Integer, ForeignKey("businesses.id"), nullable=False)
    name = Column(String(100), nullable=False)
    description = Column(Text)
    code = Column(String(50))
    parent_id = Column(Integer, ForeignKey("categories.id"))
    is_active = Column(Boolean, default=True)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    business = relationship("Business", back_populates="categories")
    parent = relationship("Category", remote_side=[id])
    products = relationship("Product", back_populates="category")

class Brand(Base):
    __tablename__ = "brands"
    
    id = Column(Integer, primary_key=True, index=True)
    business_id = Column(Integer, ForeignKey("businesses.id"), nullable=False)
    name = Column(String(100), nullable=False)
    description = Column(Text)
    code = Column(String(50))
    country = Column(String(100))
    is_active = Column(Boolean, default=True)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    business = relationship("Business", back_populates="brands")
    products = relationship("Product", back_populates="brand")

class Warehouse(Base):
    __tablename__ = "warehouses"
    
    id = Column(Integer, primary_key=True, index=True)
    business_id = Column(Integer, ForeignKey("businesses.id"), nullable=False)
    name = Column(String(100), nullable=False)
    description = Column(Text)
    code = Column(String(50))
    address = Column(Text)
    is_active = Column(Boolean, default=True)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    business = relationship("Business", back_populates="warehouses")
    inventory_movements = relationship("InventoryMovement", back_populates="warehouse", foreign_keys="InventoryMovement.warehouse_id")

class Supplier(Base):
    __tablename__ = "suppliers"
    
    id = Column(Integer, primary_key=True, index=True)
    business_id = Column(Integer, ForeignKey("businesses.id"), nullable=False)
    name = Column(String(200), nullable=False)
    company_name = Column(String(200))
    tax_id = Column(String(50))
    email = Column(String(255))
    phone = Column(String(20))
    mobile = Column(String(20))
    website = Column(String(255))
    
    # Address information
    address = Column(Text)
    city = Column(String(100))
    state = Column(String(100))
    postal_code = Column(String(20))
    country = Column(String(100))
    
    # Business terms
    payment_terms = Column(Enum(PaymentTerms), default=PaymentTerms.NET_30)
    credit_limit = Column(Float)
    discount_percentage = Column(Float, default=0.0)
    
    # Contact person
    contact_person = Column(String(200))
    contact_title = Column(String(100))
    contact_email = Column(String(255))
    contact_phone = Column(String(20))
    
    # Status and notes
    is_active = Column(Boolean, default=True)
    notes = Column(Text)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    business = relationship("Business", back_populates="suppliers")
    purchase_orders = relationship("PurchaseOrder", back_populates="supplier")
    supplier_products = relationship("SupplierProduct", back_populates="supplier")

class Unit(Base):
    __tablename__ = "units"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50), nullable=False)
    symbol = Column(String(10), nullable=False)
    unit_type = Column(String(20))  # weight, volume, length, count, etc.
    conversion_factor = Column(Float, default=1.0)
    is_active = Column(Boolean, default=True)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class Product(Base):
    __tablename__ = "products"
    
    id = Column(Integer, primary_key=True, index=True)
    business_id = Column(Integer, ForeignKey("businesses.id"), nullable=False)
    category_id = Column(Integer, ForeignKey("categories.id"))
    brand_id = Column(Integer, ForeignKey("brands.id"))
    name = Column(String(200), nullable=False)
    description = Column(Text)
    sku = Column(String(100), unique=True, index=True)
    barcode = Column(String(100))
    base_unit_id = Column(Integer, ForeignKey("units.id"))
    minimum_stock = Column(Float, default=0)
    maximum_stock = Column(Float)
    is_active = Column(Boolean, default=True)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    category = relationship("Category", back_populates="products")
    brand = relationship("Brand", back_populates="products")
    base_unit = relationship("Unit")
    variants = relationship("ProductVariant", back_populates="product")

class ProductVariant(Base):
    __tablename__ = "product_variants"
    
    id = Column(Integer, primary_key=True, index=True)
    product_id = Column(Integer, ForeignKey("products.id"), nullable=False)
    name = Column(String(200))
    sku = Column(String(100), unique=True, index=True)
    barcode = Column(String(100))
    attributes = Column(Text)  # JSON string for variant attributes
    cost_price = Column(Float)
    selling_price = Column(Float)
    is_active = Column(Boolean, default=True)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    product = relationship("Product", back_populates="variants")
    inventory_movements = relationship("InventoryMovement", back_populates="product_variant")

class InventoryMovement(Base):
    __tablename__ = "inventory_movements"
    
    id = Column(Integer, primary_key=True, index=True)
    warehouse_id = Column(Integer, ForeignKey("warehouses.id"), nullable=False)
    product_variant_id = Column(Integer, ForeignKey("product_variants.id"), nullable=False)
    unit_id = Column(Integer, ForeignKey("units.id"), nullable=False)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    
    movement_type = Column(Enum(MovementType), nullable=False)
    quantity = Column(Float, nullable=False)
    cost_per_unit = Column(Float)
    previous_quantity = Column(Float)
    new_quantity = Column(Float)
    
    batch_number = Column(String(100))
    expiry_date = Column(DateTime)
    reference_number = Column(String(100))
    reason = Column(String(500))
    notes = Column(Text)
    
    # For transfers
    destination_warehouse_id = Column(Integer, ForeignKey("warehouses.id"))
    
    # For purchase order receipts
    purchase_order_id = Column(Integer, ForeignKey("purchase_orders.id"))
    purchase_order_receipt_id = Column(Integer, ForeignKey("purchase_order_receipts.id"))
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relationships
    warehouse = relationship("Warehouse", back_populates="inventory_movements", foreign_keys=[warehouse_id])
    destination_warehouse = relationship("Warehouse", foreign_keys=[destination_warehouse_id])
    product_variant = relationship("ProductVariant", back_populates="inventory_movements")
    unit = relationship("Unit")
    user = relationship("User")
    purchase_order = relationship("PurchaseOrder")
    purchase_order_receipt = relationship("PurchaseOrderReceipt")

class SupplierProduct(Base):
    __tablename__ = "supplier_products"
    
    id = Column(Integer, primary_key=True, index=True)
    supplier_id = Column(Integer, ForeignKey("suppliers.id"), nullable=False)
    product_variant_id = Column(Integer, ForeignKey("product_variants.id"), nullable=False)
    
    # Supplier-specific product information
    supplier_sku = Column(String(100))  # SKU del proveedor
    supplier_product_name = Column(String(200))  # Nombre del producto según el proveedor
    cost_price = Column(Float, nullable=False)
    minimum_order_quantity = Column(Float, default=1.0)
    lead_time_days = Column(Integer, default=7)  # Tiempo de entrega en días
    
    # Status
    is_active = Column(Boolean, default=True)
    is_preferred = Column(Boolean, default=False)  # Proveedor preferido para este producto
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    supplier = relationship("Supplier", back_populates="supplier_products")
    product_variant = relationship("ProductVariant")

class PurchaseOrder(Base):
    __tablename__ = "purchase_orders"
    
    id = Column(Integer, primary_key=True, index=True)
    business_id = Column(Integer, ForeignKey("businesses.id"), nullable=False)
    supplier_id = Column(Integer, ForeignKey("suppliers.id"), nullable=False)
    warehouse_id = Column(Integer, ForeignKey("warehouses.id"), nullable=False)  # Almacén de destino
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)  # Usuario que creó la orden
    
    # Order identification
    order_number = Column(String(100), unique=True, index=True, nullable=False)
    supplier_reference = Column(String(100))  # Referencia del proveedor
    
    # Order details
    status = Column(Enum(PurchaseOrderStatus), default=PurchaseOrderStatus.DRAFT)
    order_date = Column(DateTime(timezone=True), server_default=func.now())
    expected_delivery_date = Column(DateTime)
    actual_delivery_date = Column(DateTime)
    
    # Financial information
    subtotal = Column(Float, default=0.0)
    tax_amount = Column(Float, default=0.0)
    shipping_cost = Column(Float, default=0.0)
    discount_amount = Column(Float, default=0.0)
    total_amount = Column(Float, default=0.0)
    
    # Payment information
    payment_terms = Column(Enum(PaymentTerms))
    payment_status = Column(String(50), default="pending")  # pending, partial, paid
    
    # Additional information
    notes = Column(Text)
    internal_notes = Column(Text)  # Notas internas no visibles al proveedor
    
    # Tracking
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    approved_at = Column(DateTime)
    approved_by_id = Column(Integer, ForeignKey("users.id"))
    
    # Relationships
    business = relationship("Business", back_populates="purchase_orders")
    supplier = relationship("Supplier", back_populates="purchase_orders")
    warehouse = relationship("Warehouse")
    user = relationship("User", foreign_keys=[user_id])
    approved_by = relationship("User", foreign_keys=[approved_by_id])
    items = relationship("PurchaseOrderItem", back_populates="purchase_order", cascade="all, delete-orphan")

class PurchaseOrderItem(Base):
    __tablename__ = "purchase_order_items"
    
    id = Column(Integer, primary_key=True, index=True)
    purchase_order_id = Column(Integer, ForeignKey("purchase_orders.id"), nullable=False)
    product_variant_id = Column(Integer, ForeignKey("product_variants.id"), nullable=False)
    unit_id = Column(Integer, ForeignKey("units.id"), nullable=False)
    
    # Order quantities
    quantity_ordered = Column(Float, nullable=False)
    quantity_received = Column(Float, default=0.0)
    quantity_pending = Column(Float)  # Se calcula: ordered - received
    
    # Pricing
    unit_cost = Column(Float, nullable=False)
    total_cost = Column(Float)  # Se calcula: quantity_ordered * unit_cost
    
    # Product information at time of order (para mantener historial)
    product_name = Column(String(200))
    product_sku = Column(String(100))
    supplier_sku = Column(String(100))
    
    # Additional information
    notes = Column(Text)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    purchase_order = relationship("PurchaseOrder", back_populates="items")
    product_variant = relationship("ProductVariant")
    unit = relationship("Unit")

class PurchaseOrderReceipt(Base):
    __tablename__ = "purchase_order_receipts"
    
    id = Column(Integer, primary_key=True, index=True)
    purchase_order_id = Column(Integer, ForeignKey("purchase_orders.id"), nullable=False)
    warehouse_id = Column(Integer, ForeignKey("warehouses.id"), nullable=False)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)  # Usuario que recibió
    
    # Receipt information
    receipt_number = Column(String(100), unique=True, index=True)
    receipt_date = Column(DateTime(timezone=True), server_default=func.now())
    supplier_invoice_number = Column(String(100))
    supplier_delivery_note = Column(String(100))
    
    # Status
    status = Column(String(50), default="received")  # received, pending_inspection, accepted, rejected
    
    # Notes
    notes = Column(Text)
    quality_notes = Column(Text)  # Notas sobre calidad de los productos recibidos
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relationships
    purchase_order = relationship("PurchaseOrder")
    warehouse = relationship("Warehouse")
    user = relationship("User")
    items = relationship("PurchaseOrderReceiptItem", back_populates="receipt", cascade="all, delete-orphan")

class PurchaseOrderReceiptItem(Base):
    __tablename__ = "purchase_order_receipt_items"
    
    id = Column(Integer, primary_key=True, index=True)
    receipt_id = Column(Integer, ForeignKey("purchase_order_receipts.id"), nullable=False)
    purchase_order_item_id = Column(Integer, ForeignKey("purchase_order_items.id"), nullable=False)
    
    # Received quantities
    quantity_received = Column(Float, nullable=False)
    quantity_accepted = Column(Float)  # Cantidad aceptada después de inspección
    quantity_rejected = Column(Float, default=0.0)  # Cantidad rechazada
    
    # Quality control
    batch_number = Column(String(100))
    expiry_date = Column(DateTime)
    quality_status = Column(String(50), default="pending")  # pending, passed, failed
    
    # Notes
    notes = Column(Text)
    rejection_reason = Column(Text)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Relationships
    receipt = relationship("PurchaseOrderReceipt", back_populates="items")
    purchase_order_item = relationship("PurchaseOrderItem")
