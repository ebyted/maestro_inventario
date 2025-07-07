// User types
export interface User {
  id: number;
  email: string;
  full_name: string;
  is_active: boolean;
  role: UserRole;
  created_at: string;
  updated_at: string;
}

export enum UserRole {
  ADMIN = 'admin',
  MANAGER = 'manager',
  EMPLOYEE = 'employee',
  VIEWER = 'viewer'
}

// Business types
export interface Business {
  id: number;
  name: string;
  description?: string;
  address?: string;
  phone?: string;
  email?: string;
  tax_id?: string;
  logo_url?: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface BusinessCreate {
  name: string;
  description?: string;
  address?: string;
  phone?: string;
  email?: string;
  tax_id?: string;
  logo_url?: string;
}

// Warehouse types
export interface Warehouse {
  id: number;
  business_id: number;
  name: string;
  description?: string;
  address?: string;
  manager_name?: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  business?: Business;
}

export interface WarehouseCreate {
  name: string;
  description?: string;
  address?: string;
  manager_name?: string;
}

// Category types
export interface Category {
  id: number;
  business_id: number;
  name: string;
  description?: string;
  parent_id?: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  business?: Business;
  parent?: Category;
  children?: Category[];
}

export interface CategoryCreate {
  name: string;
  description?: string;
  parent_id?: number;
}

// Brand types
export interface Brand {
  id: number;
  business_id: number;
  name: string;
  description?: string;
  logo_url?: string;
  website?: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  business?: Business;
}

export interface BrandCreate {
  name: string;
  description?: string;
  logo_url?: string;
  website?: string;
}

// Unit types
export interface Unit {
  id: number;
  business_id: number;
  name: string;
  symbol: string;
  description?: string;
  unit_type: UnitType;
  base_unit_id?: number;
  conversion_factor?: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  business?: Business;
  base_unit?: Unit;
}

export enum UnitType {
  WEIGHT = 'weight',
  VOLUME = 'volume',
  LENGTH = 'length',
  AREA = 'area',
  COUNT = 'count'
}

export interface UnitCreate {
  name: string;
  symbol: string;
  description?: string;
  unit_type: UnitType;
  base_unit_id?: number;
  conversion_factor?: number;
}

// Product types
export interface Product {
  id: number;
  business_id: number;
  name: string;
  description?: string;
  category_id?: number;
  brand_id?: number;
  base_unit_id?: number;
  default_cost?: number;
  default_price?: number;
  min_stock_level?: number;
  max_stock_level?: number;
  reorder_point?: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  business?: Business;
  category?: Category;
  brand?: Brand;
  base_unit?: Unit;
  variants?: ProductVariant[];
}

export interface ProductCreate {
  name: string;
  description?: string;
  category_id?: number;
  brand_id?: number;
  base_unit_id?: number;
  default_cost?: number;
  default_price?: number;
  min_stock_level?: number;
  max_stock_level?: number;
  reorder_point?: number;
}

export interface ProductVariant {
  id: number;
  product_id: number;
  name?: string;
  sku: string;
  barcode?: string;
  size?: string;
  color?: string;
  material?: string;
  weight?: number;
  dimensions?: string;
  cost?: number;
  price?: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  product?: Product;
}

export interface ProductVariantCreate {
  name?: string;
  sku: string;
  barcode?: string;
  size?: string;
  color?: string;
  material?: string;
  weight?: number;
  dimensions?: string;
  cost?: number;
  price?: number;
}

// Supplier types
export interface Supplier {
  id: number;
  business_id: number;
  name: string;
  contact_person?: string;
  email?: string;
  phone?: string;
  address?: string;
  city?: string;
  state?: string;
  country?: string;
  postal_code?: string;
  tax_id?: string;
  website?: string;
  payment_terms?: string;
  credit_limit?: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  business?: Business;
}

export interface SupplierCreate {
  name: string;
  contact_person?: string;
  email?: string;
  phone?: string;
  address?: string;
  city?: string;
  state?: string;
  country?: string;
  postal_code?: string;
  tax_id?: string;
  website?: string;
  payment_terms?: string;
  credit_limit?: number;
}

// Purchase Order types
export interface PurchaseOrder {
  id: number;
  business_id: number;
  supplier_id: number;
  warehouse_id: number;
  user_id: number;
  order_number: string;
  supplier_reference?: string;
  status: PurchaseOrderStatus;
  order_date: string;
  expected_delivery_date?: string;
  actual_delivery_date?: string;
  subtotal: number;
  tax_rate?: number;
  tax_amount?: number;
  shipping_cost?: number;
  discount_amount?: number;
  total_amount: number;
  notes?: string;
  terms_conditions?: string;
  approved_at?: string;
  approved_by_id?: number;
  created_at: string;
  updated_at: string;
  business?: Business;
  supplier?: Supplier;
  warehouse?: Warehouse;
  user?: User;
  approved_by?: User;
  items?: PurchaseOrderItem[];
}

export enum PurchaseOrderStatus {
  DRAFT = 'draft',
  PENDING = 'pending',
  APPROVED = 'approved',
  ORDERED = 'ordered',
  PARTIALLY_RECEIVED = 'partially_received',
  RECEIVED = 'received',
  CANCELLED = 'cancelled'
}

export interface PurchaseOrderCreate {
  supplier_id: number;
  warehouse_id: number;
  order_number?: string;
  supplier_reference?: string;
  order_date: string;
  expected_delivery_date?: string;
  tax_rate?: number;
  shipping_cost?: number;
  discount_amount?: number;
  notes?: string;
  terms_conditions?: string;
  items: PurchaseOrderItemCreate[];
}

export interface PurchaseOrderItem {
  id: number;
  purchase_order_id: number;
  product_variant_id: number;
  unit_id?: number;
  quantity_ordered: number;
  quantity_received: number;
  quantity_pending: number;
  unit_cost: number;
  total_cost: number;
  product_name: string;
  product_sku: string;
  supplier_sku?: string;
  notes?: string;
  created_at: string;
  updated_at: string;
  product_variant?: ProductVariant;
  unit?: Unit;
}

export interface PurchaseOrderItemCreate {
  product_variant_id: number;
  unit_id?: number;
  quantity_ordered: number;
  unit_cost: number;
  supplier_sku?: string;
  notes?: string;
}

// Purchase Order Receipt types
export interface PurchaseOrderReceipt {
  id: number;
  purchase_order_id: number;
  warehouse_id: number;
  user_id: number;
  receipt_number: string;
  supplier_invoice_number?: string;
  supplier_delivery_note?: string;
  notes?: string;
  quality_notes?: string;
  created_at: string;
  updated_at: string;
  purchase_order?: PurchaseOrder;
  warehouse?: Warehouse;
  user?: User;
  items?: PurchaseOrderReceiptItem[];
}

export interface PurchaseOrderReceiptCreate {
  warehouse_id: number;
  receipt_number?: string;
  supplier_invoice_number?: string;
  supplier_delivery_note?: string;
  notes?: string;
  quality_notes?: string;
  items: PurchaseOrderReceiptItemCreate[];
}

export interface PurchaseOrderReceiptItem {
  id: number;
  receipt_id: number;
  purchase_order_item_id: number;
  quantity_received: number;
  quantity_accepted?: number;
  quantity_rejected?: number;
  batch_number?: string;
  expiry_date?: string;
  quality_status?: string;
  notes?: string;
  rejection_reason?: string;
  created_at: string;
  updated_at: string;
  purchase_order_item?: PurchaseOrderItem;
}

export interface PurchaseOrderReceiptItemCreate {
  purchase_order_item_id: number;
  quantity_received: number;
  quantity_accepted?: number;
  quantity_rejected?: number;
  batch_number?: string;
  expiry_date?: string;
  quality_status?: string;
  notes?: string;
  rejection_reason?: string;
}

// Inventory types
export interface InventoryMovement {
  id: number;
  warehouse_id: number;
  product_variant_id: number;
  unit_id?: number;
  user_id: number;
  movement_type: MovementType;
  quantity: number;
  cost_per_unit?: number;
  batch_number?: string;
  expiry_date?: string;
  reference_number?: string;
  reason?: string;
  notes?: string;
  purchase_order_id?: number;
  sale_id?: number;
  purchase_order_receipt_id?: number;
  created_at: string;
  updated_at: string;
  warehouse?: Warehouse;
  product_variant?: ProductVariant;
  unit?: Unit;
  user?: User;
  purchase_order?: PurchaseOrder;
  purchase_order_receipt?: PurchaseOrderReceipt;
}

export enum MovementType {
  ENTRY = 'entry',
  EXIT = 'exit',
  ADJUSTMENT = 'adjustment',
  TRANSFER = 'transfer'
}

export interface InventoryMovementCreate {
  warehouse_id: number;
  product_variant_id: number;
  unit_id?: number;
  movement_type: MovementType;
  quantity: number;
  cost_per_unit?: number;
  batch_number?: string;
  expiry_date?: string;
  reference_number?: string;
  reason?: string;
  notes?: string;
}

// Inventory Level types
export interface InventoryLevel {
  id: number;
  warehouse_id: number;
  product_variant_id: number;
  current_stock: number;
  reserved_stock: number;
  available_stock: number;
  average_cost: number;
  last_movement_date?: string;
  warehouse?: Warehouse;
  product_variant?: ProductVariant;
}

// API Response types
export interface ApiResponse<T> {
  data: T;
  message?: string;
  success: boolean;
}

export interface PaginatedResponse<T> {
  items: T[];
  total: number;
  page: number;
  size: number;
  pages: number;
}
