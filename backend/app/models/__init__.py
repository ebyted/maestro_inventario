from sqlalchemy import Boolean, Column, Integer, String, DateTime, ForeignKey, Float, Text, JSON
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.db.database import Base


class Business(Base):
    __tablename__ = "businesses"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    rfc = Column(String, unique=True, nullable=False)
    address = Column(Text)
    phone = Column(String)
    email = Column(String)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    warehouses = relationship("Warehouse", back_populates="business")
    products = relationship("Product", back_populates="business")
    purchase_orders = relationship("PurchaseOrder", back_populates="business")
    user_roles = relationship("UserRole", back_populates="business")


class Warehouse(Base):
    __tablename__ = "warehouses"

    id = Column(Integer, primary_key=True, index=True)
    business_id = Column(Integer, ForeignKey("businesses.id"), nullable=False)
    name = Column(String, nullable=False)
    location = Column(String)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    business = relationship("Business", back_populates="warehouses")
    inventory = relationship("Inventory", back_populates="warehouse")
    sales = relationship("Sale", back_populates="warehouse")


class Unit(Base):
    __tablename__ = "units"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False, unique=True)
    abbreviation = Column(String, nullable=False, unique=True)
    conversion_to_base = Column(Float, default=1.0)  # Factor to convert to base unit
    is_base = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    products = relationship("Product", back_populates="base_unit")
    product_variants = relationship("ProductVariant", back_populates="unit")
    inventory = relationship("Inventory", back_populates="unit")
    purchase_order_items = relationship("PurchaseOrderItem", back_populates="unit")
    sale_items = relationship("SaleItem", back_populates="unit")


class Product(Base):
    __tablename__ = "products"

    id = Column(Integer, primary_key=True, index=True)
    business_id = Column(Integer, ForeignKey("businesses.id"), nullable=False)
    name = Column(String, nullable=False)
    description = Column(Text)
    sku = Column(String, unique=True)
    barcode = Column(String)
    category = Column(String)
    brand = Column(String)
    base_unit_id = Column(Integer, ForeignKey("units.id"), nullable=False)
    image_url = Column(String)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    business = relationship("Business", back_populates="products")
    base_unit = relationship("Unit", back_populates="products")
    variants = relationship("ProductVariant", back_populates="product")


class ProductVariant(Base):
    __tablename__ = "product_variants"

    id = Column(Integer, primary_key=True, index=True)
    product_id = Column(Integer, ForeignKey("products.id"), nullable=False)
    unit_id = Column(Integer, ForeignKey("units.id"), nullable=False)
    attributes = Column(JSON)  # {"size": "L", "color": "red", "flavor": "vanilla"}
    sku = Column(String, unique=True)
    barcode = Column(String)
    price = Column(Float)
    cost = Column(Float)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    product = relationship("Product", back_populates="variants")
    unit = relationship("Unit", back_populates="product_variants")
    inventory = relationship("Inventory", back_populates="product_variant")
    purchase_order_items = relationship("PurchaseOrderItem", back_populates="product_variant")
    sale_items = relationship("SaleItem", back_populates="product_variant")


class Inventory(Base):
    __tablename__ = "inventory"

    id = Column(Integer, primary_key=True, index=True)
    warehouse_id = Column(Integer, ForeignKey("warehouses.id"), nullable=False)
    product_variant_id = Column(Integer, ForeignKey("product_variants.id"), nullable=False)
    unit_id = Column(Integer, ForeignKey("units.id"), nullable=False)
    quantity = Column(Float, default=0.0)
    minimum_stock = Column(Float, default=0.0)
    maximum_stock = Column(Float)
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    warehouse = relationship("Warehouse", back_populates="inventory")
    product_variant = relationship("ProductVariant", back_populates="inventory")
    unit = relationship("Unit", back_populates="inventory")


class Supplier(Base):
    __tablename__ = "suppliers"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    rfc = Column(String)
    contact_name = Column(String)
    phones = Column(JSON)  # Array of phone numbers
    email = Column(String)
    addresses = Column(JSON)  # Array of addresses
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    purchase_orders = relationship("PurchaseOrder", back_populates="supplier")


class PurchaseOrder(Base):
    __tablename__ = "purchase_orders"

    id = Column(Integer, primary_key=True, index=True)
    business_id = Column(Integer, ForeignKey("businesses.id"), nullable=False)
    supplier_id = Column(Integer, ForeignKey("suppliers.id"), nullable=False)
    order_number = Column(String, unique=True, nullable=False)
    date = Column(DateTime(timezone=True), server_default=func.now())
    status = Column(String, default="pending")  # pending, received, cancelled
    subtotal = Column(Float, default=0.0)
    tax = Column(Float, default=0.0)
    total = Column(Float, default=0.0)
    notes = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    business = relationship("Business", back_populates="purchase_orders")
    supplier = relationship("Supplier", back_populates="purchase_orders")
    items = relationship("PurchaseOrderItem", back_populates="purchase_order")


class PurchaseOrderItem(Base):
    __tablename__ = "purchase_order_items"

    id = Column(Integer, primary_key=True, index=True)
    purchase_order_id = Column(Integer, ForeignKey("purchase_orders.id"), nullable=False)
    product_variant_id = Column(Integer, ForeignKey("product_variants.id"), nullable=False)
    unit_id = Column(Integer, ForeignKey("units.id"), nullable=False)
    quantity = Column(Float, nullable=False)
    unit_price = Column(Float, nullable=False)
    total_price = Column(Float, nullable=False)

    # Relationships
    purchase_order = relationship("PurchaseOrder", back_populates="items")
    product_variant = relationship("ProductVariant", back_populates="purchase_order_items")
    unit = relationship("Unit", back_populates="purchase_order_items")


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, nullable=False, index=True)
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    password_hash = Column(String, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    is_active = Column(Boolean, default=True)
    is_superuser = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    # Relationships
    roles = relationship("UserRole", back_populates="user")
    sales = relationship("Sale", back_populates="user")


class UserRole(Base):
    __tablename__ = "user_roles"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    business_id = Column(Integer, ForeignKey("businesses.id"), nullable=False)
    role = Column(String, nullable=False)  # admin, manager, cashier, stock_keeper
    permissions = Column(JSON)  # Custom permissions array
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    user = relationship("User", back_populates="roles")
    business = relationship("Business", back_populates="user_roles")


class Sale(Base):
    __tablename__ = "sales"

    id = Column(Integer, primary_key=True, index=True)
    warehouse_id = Column(Integer, ForeignKey("warehouses.id"), nullable=False)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    sale_number = Column(String, unique=True, nullable=False)
    date = Column(DateTime(timezone=True), server_default=func.now())
    payment_method = Column(String, nullable=False)  # cash, card, transfer
    subtotal = Column(Float, default=0.0)
    tax = Column(Float, default=0.0)
    discount = Column(Float, default=0.0)
    total = Column(Float, default=0.0)
    customer_name = Column(String)
    customer_email = Column(String)
    notes = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    warehouse = relationship("Warehouse", back_populates="sales")
    user = relationship("User", back_populates="sales")
    items = relationship("SaleItem", back_populates="sale")


class SaleItem(Base):
    __tablename__ = "sale_items"

    id = Column(Integer, primary_key=True, index=True)
    sale_id = Column(Integer, ForeignKey("sales.id"), nullable=False)
    product_variant_id = Column(Integer, ForeignKey("product_variants.id"), nullable=False)
    unit_id = Column(Integer, ForeignKey("units.id"), nullable=False)
    quantity = Column(Float, nullable=False)
    unit_price = Column(Float, nullable=False)
    total_price = Column(Float, nullable=False)

    # Relationships
    sale = relationship("Sale", back_populates="items")
    product_variant = relationship("ProductVariant", back_populates="sale_items")
    unit = relationship("Unit", back_populates="sale_items")


class InventoryMovement(Base):
    __tablename__ = "inventory_movements"

    id = Column(Integer, primary_key=True, index=True)
    warehouse_id = Column(Integer, ForeignKey("warehouses.id"), nullable=False)
    product_variant_id = Column(Integer, ForeignKey("product_variants.id"), nullable=False)
    unit_id = Column(Integer, ForeignKey("units.id"), nullable=False)
    movement_type = Column(String, nullable=False)  # 'entry', 'exit', 'adjustment', 'transfer'
    quantity = Column(Float, nullable=False)
    previous_quantity = Column(Float, nullable=False)
    new_quantity = Column(Float, nullable=False)
    reference_type = Column(String)  # 'purchase_order', 'sale', 'adjustment', 'transfer'
    reference_id = Column(Integer)  # ID of the related document
    reason = Column(String)
    notes = Column(Text)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    warehouse = relationship("Warehouse")
    product_variant = relationship("ProductVariant")
    unit = relationship("Unit")
    user = relationship("User")


class StockAlert(Base):
    __tablename__ = "stock_alerts"

    id = Column(Integer, primary_key=True, index=True)
    warehouse_id = Column(Integer, ForeignKey("warehouses.id"), nullable=False)
    product_variant_id = Column(Integer, ForeignKey("product_variants.id"), nullable=False)
    alert_type = Column(String, nullable=False)  # 'low_stock', 'out_of_stock', 'overstock'
    current_quantity = Column(Float, nullable=False)
    minimum_quantity = Column(Float)
    maximum_quantity = Column(Float)
    is_resolved = Column(Boolean, default=False)
    resolved_at = Column(DateTime(timezone=True))
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    warehouse = relationship("Warehouse")
    product_variant = relationship("ProductVariant")


class InventoryAdjustment(Base):
    __tablename__ = "inventory_adjustments"

    id = Column(Integer, primary_key=True, index=True)
    warehouse_id = Column(Integer, ForeignKey("warehouses.id"), nullable=False)
    adjustment_number = Column(String, unique=True, nullable=False)
    adjustment_type = Column(String, nullable=False)  # 'physical_count', 'loss', 'damage', 'correction'
    reason = Column(String, nullable=False)
    notes = Column(Text)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    status = Column(String, default='draft')  # 'draft', 'approved', 'applied'
    approved_by = Column(Integer, ForeignKey("users.id"))
    approved_at = Column(DateTime(timezone=True))
    applied_at = Column(DateTime(timezone=True))
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    warehouse = relationship("Warehouse")
    user = relationship("User", foreign_keys=[user_id])
    approver = relationship("User", foreign_keys=[approved_by])
    items = relationship("InventoryAdjustmentItem", back_populates="adjustment")


class InventoryAdjustmentItem(Base):
    __tablename__ = "inventory_adjustment_items"

    id = Column(Integer, primary_key=True, index=True)
    adjustment_id = Column(Integer, ForeignKey("inventory_adjustments.id"), nullable=False)
    product_variant_id = Column(Integer, ForeignKey("product_variants.id"), nullable=False)
    unit_id = Column(Integer, ForeignKey("units.id"), nullable=False)
    expected_quantity = Column(Float, nullable=False)
    actual_quantity = Column(Float, nullable=False)
    difference = Column(Float, nullable=False)
    unit_cost = Column(Float)
    total_cost_impact = Column(Float)

    # Relationships
    adjustment = relationship("InventoryAdjustment", back_populates="items")
    product_variant = relationship("ProductVariant")
    unit = relationship("Unit")


# Export all models
__all__ = [
    "Base",
    "Business", 
    "Warehouse",
    "User",
    "UserRole",
    "Unit",
    "Product", 
    "ProductVariant",
    "Inventory",
    "InventoryMovement",
    "StockAlert",
    "InventoryAdjustment",
    "InventoryAdjustmentItem",
    "Supplier",
    "PurchaseOrder", 
    "PurchaseOrderItem",
    "Sale",
    "SaleItem"
]
