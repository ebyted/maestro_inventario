from typing import List, Optional
from datetime import datetime, timedelta
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import and_, or_, func, desc
from app.db.database import get_db
from app.models import (
    Inventory, Product, ProductVariant, Warehouse, Unit,
    InventoryMovement, StockAlert, InventoryAdjustment, 
    InventoryAdjustmentItem, PurchaseOrder, PurchaseOrderItem, User
)
from app.schemas.inventory import (
    ProductWithInventory, ProductSearchFilters,
    InventoryMovementCreate, InventoryMovement as InventoryMovementSchema,
    InventoryEntryCreate, InventoryExitCreate, InventoryAdjustmentSimpleCreate, InventoryTransferCreate,
    InventoryMovementFilters, MovementType,
    StockAlert as StockAlertSchema, AlertType,
    InventoryAdjustmentCreate, InventoryAdjustment as InventoryAdjustmentSchema,
    InventoryAdjustmentUpdate, AdjustmentStatus,
    PurchaseOrderReceive, BulkStockUpdate, InventoryDashboard,
    LowStockReport, InventoryMovementReport,
    InventoryEntryMultiCreate, InventoryExitMultiCreate, InventoryAdjustmentMultiCreate,
    InventoryMovementMultiResponse, InventoryBatchOperationSummary
)
from app.api.v1.endpoints.auth import get_current_user

router = APIRouter()


# Product Catalog with Inventory
@router.get("/products", response_model=List[ProductWithInventory])
def get_products_with_inventory(
    filters: ProductSearchFilters = Depends(),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Catálogo de productos con información de inventario"""
    
    query = db.query(Product).options(
        joinedload(Product.base_unit),
        joinedload(Product.variants).joinedload(ProductVariant.inventory),
        joinedload(Product.variants).joinedload(ProductVariant.unit)
    ).filter(Product.business_id == 1)  # TODO: Get from current user's business
    
    # Apply filters
    if filters.search:
        search_term = f"%{filters.search}%"
        query = query.filter(
            or_(
                Product.name.ilike(search_term),
                Product.description.ilike(search_term),
                Product.sku.ilike(search_term),
                Product.barcode.ilike(search_term)
            )
        )
    
    if filters.category:
        query = query.filter(Product.category == filters.category)
    
    if filters.brand:
        query = query.filter(Product.brand == filters.brand)
    
    if filters.is_active is not None:
        query = query.filter(Product.is_active == filters.is_active)
    
    products = query.offset(filters.skip).limit(filters.limit).all()
    
    # Transform to ProductWithInventory
    result = []
    for product in products:
        # Calculate total stock across all variants and warehouses
        total_stock = 0
        min_stock = 0
        has_low_stock = False
        
        for variant in product.variants:
            for inventory in variant.inventory:
                if not filters.warehouse_id or inventory.warehouse_id == filters.warehouse_id:
                    total_stock += inventory.quantity
                    min_stock += inventory.minimum_stock
                    if inventory.quantity <= inventory.minimum_stock:
                        has_low_stock = True
        
        # Apply stock filters
        if filters.has_stock is not None:
            if filters.has_stock and total_stock <= 0:
                continue
            if not filters.has_stock and total_stock > 0:
                continue
        
        if filters.low_stock_only and not has_low_stock:
            continue
        
        product_data = ProductWithInventory(
            id=product.id,
            name=product.name,
            description=product.description,
            sku=product.sku,
            barcode=product.barcode,
            category=product.category,
            brand=product.brand,
            image_url=product.image_url,
            is_active=product.is_active,
            base_unit={"id": product.base_unit.id, "name": product.base_unit.name},
            current_stock=total_stock,
            minimum_stock=min_stock,
            has_low_stock=has_low_stock,
            variants=[{
                "id": v.id,
                "attributes": v.attributes,
                "price": v.price,
                "cost": v.cost,
                "inventory": [{
                    "warehouse_id": inv.warehouse_id,
                    "quantity": inv.quantity,
                    "minimum_stock": inv.minimum_stock
                } for inv in v.inventory]
            } for v in product.variants]
        )
        result.append(product_data)
    
    return result


# Inventory Movements
@router.post("/movements", response_model=InventoryMovementSchema)
def create_inventory_movement(
    movement: InventoryMovementCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Crear movimiento de inventario"""
    
    # Get current inventory
    inventory = db.query(Inventory).filter(
        and_(
            Inventory.warehouse_id == movement.warehouse_id,
            Inventory.product_variant_id == movement.product_variant_id,
            Inventory.unit_id == movement.unit_id
        )
    ).first()
    
    if not inventory:
        # Create new inventory record if doesn't exist
        inventory = Inventory(
            warehouse_id=movement.warehouse_id,
            product_variant_id=movement.product_variant_id,
            unit_id=movement.unit_id,
            quantity=0,
            minimum_stock=0
        )
        db.add(inventory)
        db.flush()
    
    previous_quantity = inventory.quantity
    
    # Calculate new quantity based on movement type
    if movement.movement_type == MovementType.ENTRY:
        new_quantity = previous_quantity + movement.quantity
    elif movement.movement_type == MovementType.EXIT:
        new_quantity = previous_quantity - movement.quantity
        if new_quantity < 0:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Insufficient stock for exit movement"
            )
    else:  # ADJUSTMENT
        new_quantity = movement.quantity
    
    # Update inventory
    inventory.quantity = new_quantity
    
    # Create movement record
    db_movement = InventoryMovement(
        warehouse_id=movement.warehouse_id,
        product_variant_id=movement.product_variant_id,
        unit_id=movement.unit_id,
        movement_type=movement.movement_type,
        quantity=movement.quantity,
        previous_quantity=previous_quantity,
        new_quantity=new_quantity,
        reference_type=movement.reference_type,
        reference_id=movement.reference_id,
        reason=movement.reason,
        notes=movement.notes,
        user_id=current_user.id
    )
    db.add(db_movement)
    
    db.commit()
    db.refresh(db_movement)
    
    return db_movement


# Endpoints específicos para movimientos de inventario

@router.post("/movements/entry", response_model=InventoryMovementSchema)
def create_inventory_entry(
    entry_data: InventoryEntryCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Registrar entrada de inventario con almacén específico"""
    
    # Validar que el almacén existe y pertenece al negocio del usuario
    warehouse = db.query(Warehouse).filter(
        Warehouse.id == entry_data.warehouse_id,
        Warehouse.business_id == 1  # TODO: Get from current user's business
    ).first()
    
    if not warehouse:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Almacén no encontrado"
        )
    
    # Validar que la variante del producto existe
    product_variant = db.query(ProductVariant).filter(
        ProductVariant.id == entry_data.product_variant_id
    ).first()
    
    if not product_variant:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Variante de producto no encontrada"
        )
    
    # Validar que la unidad existe
    unit = db.query(Unit).filter(Unit.id == entry_data.unit_id).first()
    if not unit:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Unidad no encontrada"
        )
    
    # Obtener inventario actual o crear uno nuevo
    inventory = db.query(Inventory).filter(
        Inventory.warehouse_id == entry_data.warehouse_id,
        Inventory.product_variant_id == entry_data.product_variant_id
    ).first()
    
    previous_quantity = 0
    if inventory:
        previous_quantity = inventory.quantity
        inventory.quantity += entry_data.quantity
        inventory.updated_at = datetime.utcnow()
    else:
        inventory = Inventory(
            warehouse_id=entry_data.warehouse_id,
            product_variant_id=entry_data.product_variant_id,
            quantity=entry_data.quantity,
            minimum_stock=0,
            created_at=datetime.utcnow(),
            updated_at=datetime.utcnow()
        )
        db.add(inventory)
    
    # Crear registro de movimiento
    movement = InventoryMovement(
        warehouse_id=entry_data.warehouse_id,
        product_variant_id=entry_data.product_variant_id,
        unit_id=entry_data.unit_id,
        movement_type=MovementType.ENTRY,
        quantity=entry_data.quantity,
        previous_quantity=previous_quantity,
        new_quantity=previous_quantity + entry_data.quantity,
        reference_type="entry",
        reason=entry_data.reason,
        notes=entry_data.notes,
        user_id=current_user.id,
        created_at=datetime.utcnow()
    )
    
    db.add(movement)
    db.commit()
    db.refresh(movement)
    
    return movement


@router.post("/movements/exit", response_model=InventoryMovementSchema)
def create_inventory_exit(
    exit_data: InventoryExitCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Registrar salida de inventario con almacén específico"""
    
    # Validar que el almacén existe y pertenece al negocio del usuario
    warehouse = db.query(Warehouse).filter(
        Warehouse.id == exit_data.warehouse_id,
        Warehouse.business_id == 1  # TODO: Get from current user's business
    ).first()
    
    if not warehouse:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Almacén no encontrado"
        )
    
    # Validar que la variante del producto existe
    product_variant = db.query(ProductVariant).filter(
        ProductVariant.id == exit_data.product_variant_id
    ).first()
    
    if not product_variant:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Variante de producto no encontrada"
        )
    
    # Validar que la unidad existe
    unit = db.query(Unit).filter(Unit.id == exit_data.unit_id).first()
    if not unit:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Unidad no encontrada"
        )
    
    # Obtener inventario actual
    inventory = db.query(Inventory).filter(
        Inventory.warehouse_id == exit_data.warehouse_id,
        Inventory.product_variant_id == exit_data.product_variant_id
    ).first()
    
    if not inventory:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No hay inventario disponible para este producto en el almacén"
        )
    
    if inventory.quantity < exit_data.quantity:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Stock insuficiente. Disponible: {inventory.quantity}, Solicitado: {exit_data.quantity}"
        )
    
    previous_quantity = inventory.quantity
    inventory.quantity -= exit_data.quantity
    inventory.updated_at = datetime.utcnow()
    
    # Crear registro de movimiento
    movement = InventoryMovement(
        warehouse_id=exit_data.warehouse_id,
        product_variant_id=exit_data.product_variant_id,
        unit_id=exit_data.unit_id,
        movement_type=MovementType.EXIT,
        quantity=exit_data.quantity,
        previous_quantity=previous_quantity,
        new_quantity=previous_quantity - exit_data.quantity,
        reference_type="exit",
        reference_id=exit_data.sale_id,
        reason=exit_data.reason,
        notes=exit_data.notes,
        user_id=current_user.id,
        created_at=datetime.utcnow()
    )
    
    db.add(movement)
    db.commit()
    db.refresh(movement)
    
    return movement


@router.post("/movements/adjustment", response_model=InventoryMovementSchema)
def create_inventory_adjustment(
    adjustment_data: InventoryAdjustmentSimpleCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Registrar ajuste de inventario con almacén específico"""
    
    # Validar que el almacén existe y pertenece al negocio del usuario
    warehouse = db.query(Warehouse).filter(
        Warehouse.id == adjustment_data.warehouse_id,
        Warehouse.business_id == 1  # TODO: Get from current user's business
    ).first()
    
    if not warehouse:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Almacén no encontrado"
        )
    
    # Validar que la variante del producto existe
    product_variant = db.query(ProductVariant).filter(
        ProductVariant.id == adjustment_data.product_variant_id
    ).first()
    
    if not product_variant:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Variante de producto no encontrada"
        )
    
    # Validar que la unidad existe
    unit = db.query(Unit).filter(Unit.id == adjustment_data.unit_id).first()
    if not unit:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Unidad no encontrada"
        )
    
    # Obtener o crear inventario
    inventory = db.query(Inventory).filter(
        Inventory.warehouse_id == adjustment_data.warehouse_id,
        Inventory.product_variant_id == adjustment_data.product_variant_id
    ).first()
    
    previous_quantity = adjustment_data.current_quantity
    if inventory:
        previous_quantity = inventory.quantity
        inventory.quantity = adjustment_data.actual_quantity
        inventory.updated_at = datetime.utcnow()
    else:
        inventory = Inventory(
            warehouse_id=adjustment_data.warehouse_id,
            product_variant_id=adjustment_data.product_variant_id,
            quantity=adjustment_data.actual_quantity,
            minimum_stock=0,
            created_at=datetime.utcnow(),
            updated_at=datetime.utcnow()
        )
        db.add(inventory)
    
    # Determinar tipo de movimiento según el ajuste
    adjustment_quantity = adjustment_data.adjustment_quantity
    movement_type = MovementType.ADJUSTMENT
    
    # Crear registro de movimiento
    movement = InventoryMovement(
        warehouse_id=adjustment_data.warehouse_id,
        product_variant_id=adjustment_data.product_variant_id,
        unit_id=adjustment_data.unit_id,
        movement_type=movement_type,
        quantity=abs(adjustment_quantity),
        previous_quantity=previous_quantity,
        new_quantity=adjustment_data.actual_quantity,
        reference_type="adjustment",
        reason=adjustment_data.reason,
        notes=adjustment_data.notes,
        user_id=current_user.id,
        created_at=datetime.utcnow()
    )
    
    db.add(movement)
    db.commit()
    db.refresh(movement)
    
    return movement


@router.post("/movements/transfer", response_model=List[InventoryMovementSchema])
def create_inventory_transfer(
    transfer_data: InventoryTransferCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Registrar transferencia entre almacenes"""
    
    # Validar que ambos almacenes existen y pertenecen al negocio del usuario
    source_warehouse = db.query(Warehouse).filter(
        Warehouse.id == transfer_data.source_warehouse_id,
        Warehouse.business_id == 1  # TODO: Get from current user's business
    ).first()
    
    destination_warehouse = db.query(Warehouse).filter(
        Warehouse.id == transfer_data.destination_warehouse_id,
        Warehouse.business_id == 1  # TODO: Get from current user's business
    ).first()
    
    if not source_warehouse:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Almacén origen no encontrado"
        )
    
    if not destination_warehouse:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Almacén destino no encontrado"
        )
    
    # Validar que la variante del producto existe
    product_variant = db.query(ProductVariant).filter(
        ProductVariant.id == transfer_data.product_variant_id
    ).first()
    
    if not product_variant:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Variante de producto no encontrada"
        )
    
    # Validar que la unidad existe
    unit = db.query(Unit).filter(Unit.id == transfer_data.unit_id).first()
    if not unit:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Unidad no encontrada"
        )
    
    # Verificar stock en almacén origen
    source_inventory = db.query(Inventory).filter(
        Inventory.warehouse_id == transfer_data.source_warehouse_id,
        Inventory.product_variant_id == transfer_data.product_variant_id
    ).first()
    
    if not source_inventory or source_inventory.quantity < transfer_data.quantity:
        available = source_inventory.quantity if source_inventory else 0
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Stock insuficiente en almacén origen. Disponible: {available}, Solicitado: {transfer_data.quantity}"
        )
    
    movements = []
    
    # Salida del almacén origen
    source_previous = source_inventory.quantity
    source_inventory.quantity -= transfer_data.quantity
    source_inventory.updated_at = datetime.utcnow()
    
    exit_movement = InventoryMovement(
        warehouse_id=transfer_data.source_warehouse_id,
        product_variant_id=transfer_data.product_variant_id,
        unit_id=transfer_data.unit_id,
        movement_type=MovementType.TRANSFER,
        quantity=transfer_data.quantity,
        previous_quantity=source_previous,
        new_quantity=source_previous - transfer_data.quantity,
        reference_type="transfer_out",
        reference_id=transfer_data.destination_warehouse_id,
        reason=transfer_data.reason,
        notes=transfer_data.notes,
        user_id=current_user.id,
        created_at=datetime.utcnow()
    )
    
    db.add(exit_movement)
    movements.append(exit_movement)
    
    # Entrada al almacén destino
    dest_inventory = db.query(Inventory).filter(
        Inventory.warehouse_id == transfer_data.destination_warehouse_id,
        Inventory.product_variant_id == transfer_data.product_variant_id
    ).first()
    
    dest_previous = 0
    if dest_inventory:
        dest_previous = dest_inventory.quantity
        dest_inventory.quantity += transfer_data.quantity
        dest_inventory.updated_at = datetime.utcnow()
    else:
        dest_inventory = Inventory(
            warehouse_id=transfer_data.destination_warehouse_id,
            product_variant_id=transfer_data.product_variant_id,
            quantity=transfer_data.quantity,
            minimum_stock=0,
            created_at=datetime.utcnow(),
            updated_at=datetime.utcnow()
        )
        db.add(dest_inventory)
    
    entry_movement = InventoryMovement(
        warehouse_id=transfer_data.destination_warehouse_id,
        product_variant_id=transfer_data.product_variant_id,
        unit_id=transfer_data.unit_id,
        movement_type=MovementType.TRANSFER,
        quantity=transfer_data.quantity,
        previous_quantity=dest_previous,
        new_quantity=dest_previous + transfer_data.quantity,
        reference_type="transfer_in",
        reference_id=transfer_data.source_warehouse_id,
        reason=transfer_data.reason,
        notes=transfer_data.notes,
        user_id=current_user.id,
        created_at=datetime.utcnow()
    )
    
    db.add(entry_movement)
    movements.append(entry_movement)
    
    db.commit()
    
    for movement in movements:
        db.refresh(movement)
    
    return movements


# Stock Alerts
@router.get("/alerts", response_model=List[StockAlertSchema])
def get_stock_alerts(
    warehouse_id: Optional[int] = Query(None),
    alert_type: Optional[AlertType] = Query(None),
    unresolved_only: bool = Query(True),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Obtener alertas de stock"""
    
    query = db.query(StockAlert).options(
        joinedload(StockAlert.warehouse),
        joinedload(StockAlert.product_variant).joinedload(ProductVariant.product)
    )
    
    if warehouse_id:
        query = query.filter(StockAlert.warehouse_id == warehouse_id)
    
    if alert_type:
        query = query.filter(StockAlert.alert_type == alert_type)
    
    if unresolved_only:
        query = query.filter(StockAlert.is_resolved == False)
    
    alerts = query.order_by(desc(StockAlert.created_at)).all()
    
    return alerts


# Low Stock Report
@router.get("/reports/low-stock", response_model=LowStockReport)
def get_low_stock_report(
    warehouse_id: Optional[int] = Query(None),
    category: Optional[str] = Query(None),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Reporte de productos con stock bajo"""
    
    # Query for products with low stock
    query = db.query(Inventory).options(
        joinedload(Inventory.product_variant).joinedload(ProductVariant.product),
        joinedload(Inventory.warehouse),
        joinedload(Inventory.unit)
    ).filter(Inventory.quantity <= Inventory.minimum_stock)
    
    if warehouse_id:
        query = query.filter(Inventory.warehouse_id == warehouse_id)
    
    if category:
        query = query.join(ProductVariant).join(Product).filter(Product.category == category)
    
    low_stock_items = query.all()
    
    # Group by product and transform to ProductWithInventory
    products_dict = {}
    for item in low_stock_items:
        product = item.product_variant.product
        if product.id not in products_dict:
            products_dict[product.id] = ProductWithInventory(
                id=product.id,
                name=product.name,
                description=product.description,
                sku=product.sku,
                barcode=product.barcode,
                category=product.category,
                brand=product.brand,
                image_url=product.image_url,
                is_active=product.is_active,
                base_unit={"id": product.base_unit.id, "name": product.base_unit.name},
                current_stock=item.quantity,
                minimum_stock=item.minimum_stock,
                has_low_stock=True,
                variants=[]
            )
    
    return LowStockReport(
        warehouse_id=warehouse_id,
        category=category,
        products=list(products_dict.values()),
        total_products=len(products_dict),
        generated_at=datetime.utcnow()
    )


# Warehouse utilities for inventory
@router.get("/warehouses", response_model=List[dict])
def get_active_warehouses(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Obtener lista de almacenes activos para el inventario"""
    
    warehouses = db.query(Warehouse).filter(
        Warehouse.business_id == 1,  # TODO: Get from current user's business
        Warehouse.is_active == True
    ).all()
    
    return [
        {
            "id": w.id,
            "name": w.name,
            "code": w.code,
            "is_active": w.is_active,
            "address": w.address
        }
        for w in warehouses
    ]


# Units utilities for inventory
@router.get("/units", response_model=List[dict])
def get_units(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Obtener lista de unidades de medida"""
    
    units = db.query(Unit).filter(Unit.is_active == True).all()
    
    return [
        {
            "id": u.id,
            "name": u.name,
            "symbol": u.symbol,
            "type": u.type,
            "conversion_factor": u.conversion_factor
        }
        for u in units
    ]


# Multi-Item Inventory Operations
@router.post("/entries/multi", response_model=InventoryMovementMultiResponse)
def create_multi_entry(
    entry_data: InventoryEntryMultiCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Crear entrada de inventario con múltiples productos"""
    
    try:
        # Validate warehouse exists
        warehouse = db.query(Warehouse).filter(Warehouse.id == entry_data.warehouse_id).first()
        if not warehouse:
            raise HTTPException(status_code=404, detail="Warehouse not found")
        
        # Create main movement record
        main_movement = InventoryMovement(
            warehouse_id=entry_data.warehouse_id,
            movement_type="entry",
            supplier_id=entry_data.supplier_id,
            purchase_order_id=entry_data.purchase_order_id,
            reference_number=entry_data.reference_number,
            reason=entry_data.reason,
            notes=entry_data.notes,
            created_by=current_user.id,
            created_at=datetime.utcnow()
        )
        db.add(main_movement)
        db.flush()  # Get the ID
        
        processed_items = []
        total_value = 0.0
        errors = []
        warnings = []
        
        for item in entry_data.items:
            try:
                # Validate product variant and unit
                variant = db.query(ProductVariant).filter(ProductVariant.id == item.product_variant_id).first()
                if not variant:
                    errors.append(f"Product variant {item.product_variant_id} not found")
                    continue
                
                unit = db.query(Unit).filter(Unit.id == item.unit_id).first()
                if not unit:
                    errors.append(f"Unit {item.unit_id} not found")
                    continue
                
                # Get or create inventory record
                inventory = db.query(Inventory).filter(
                    and_(
                        Inventory.warehouse_id == entry_data.warehouse_id,
                        Inventory.product_variant_id == item.product_variant_id,
                        Inventory.unit_id == item.unit_id
                    )
                ).first()
                
                if not inventory:
                    inventory = Inventory(
                        warehouse_id=entry_data.warehouse_id,
                        product_variant_id=item.product_variant_id,
                        unit_id=item.unit_id,
                        quantity=0,
                        minimum_stock=0
                    )
                    db.add(inventory)
                    db.flush()
                
                # Update inventory quantity
                inventory.quantity += item.quantity
                
                # Create movement detail
                movement_detail = InventoryMovement(
                    warehouse_id=entry_data.warehouse_id,
                    product_variant_id=item.product_variant_id,
                    unit_id=item.unit_id,
                    movement_type="entry",
                    quantity=item.quantity,
                    cost_per_unit=item.cost_per_unit,
                    reference_number=entry_data.reference_number,
                    supplier_id=entry_data.supplier_id,
                    purchase_order_id=entry_data.purchase_order_id,
                    expiry_date=item.expiry_date,
                    batch_number=item.batch_number,
                    reason=entry_data.reason,
                    notes=item.notes,
                    parent_movement_id=main_movement.id,
                    created_by=current_user.id,
                    created_at=datetime.utcnow()
                )
                db.add(movement_detail)
                
                # Calculate total value
                if item.cost_per_unit:
                    total_value += item.quantity * item.cost_per_unit
                
                processed_items.append({
                    "id": movement_detail.id if movement_detail.id else 0,
                    "product_variant_id": item.product_variant_id,
                    "unit_id": item.unit_id,
                    "quantity": item.quantity,
                    "cost_per_unit": item.cost_per_unit,
                    "expiry_date": item.expiry_date,
                    "batch_number": item.batch_number,
                    "notes": item.notes,
                    "created_at": datetime.utcnow()
                })
                
            except Exception as e:
                errors.append(f"Error processing item {item.product_variant_id}: {str(e)}")
        
        if errors and not processed_items:
            db.rollback()
            raise HTTPException(status_code=400, detail={"errors": errors})
        
        # Update main movement with totals
        main_movement.total_value = total_value if total_value > 0 else None
        
        db.commit()
        
        return InventoryMovementMultiResponse(
            id=main_movement.id,
            warehouse_id=main_movement.warehouse_id,
            movement_type="entry",
            reference_number=main_movement.reference_number,
            supplier_id=main_movement.supplier_id,
            purchase_order_id=main_movement.purchase_order_id,
            reason=main_movement.reason,
            notes=main_movement.notes,
            total_items=len(processed_items),
            total_value=total_value if total_value > 0 else None,
            status="completed",
            items=processed_items,
            created_at=main_movement.created_at,
            created_by=main_movement.created_by
        )
        
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Error creating multi-entry: {str(e)}")


@router.post("/exits/multi", response_model=InventoryMovementMultiResponse)
def create_multi_exit(
    exit_data: InventoryExitMultiCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Crear salida de inventario con múltiples productos"""
    
    try:
        # Validate warehouse exists
        warehouse = db.query(Warehouse).filter(Warehouse.id == exit_data.warehouse_id).first()
        if not warehouse:
            raise HTTPException(status_code=404, detail="Warehouse not found")
        
        # Create main movement record
        main_movement = InventoryMovement(
            warehouse_id=exit_data.warehouse_id,
            movement_type="exit",
            customer_id=exit_data.customer_id,
            sale_id=exit_data.sale_id,
            destination_warehouse_id=exit_data.destination_warehouse_id,
            reference_number=exit_data.reference_number,
            reason=exit_data.reason,
            notes=exit_data.notes,
            created_by=current_user.id,
            created_at=datetime.utcnow()
        )
        db.add(main_movement)
        db.flush()  # Get the ID
        
        processed_items = []
        total_value = 0.0
        errors = []
        warnings = []
        
        for item in exit_data.items:
            try:
                # Validate product variant and unit
                variant = db.query(ProductVariant).filter(ProductVariant.id == item.product_variant_id).first()
                if not variant:
                    errors.append(f"Product variant {item.product_variant_id} not found")
                    continue
                
                unit = db.query(Unit).filter(Unit.id == item.unit_id).first()
                if not unit:
                    errors.append(f"Unit {item.unit_id} not found")
                    continue
                
                # Check inventory availability
                inventory = db.query(Inventory).filter(
                    and_(
                        Inventory.warehouse_id == exit_data.warehouse_id,
                        Inventory.product_variant_id == item.product_variant_id,
                        Inventory.unit_id == item.unit_id
                    )
                ).first()
                
                if not inventory or inventory.quantity < item.quantity:
                    available = inventory.quantity if inventory else 0
                    errors.append(f"Insufficient stock for product {item.product_variant_id}. Available: {available}, Required: {item.quantity}")
                    continue
                
                # Update inventory quantity
                inventory.quantity -= item.quantity
                
                # Create movement detail
                movement_detail = InventoryMovement(
                    warehouse_id=exit_data.warehouse_id,
                    product_variant_id=item.product_variant_id,
                    unit_id=item.unit_id,
                    movement_type="exit",
                    quantity=-item.quantity,  # Negative for exits
                    unit_price=item.unit_price,
                    reference_number=exit_data.reference_number,
                    customer_id=exit_data.customer_id,
                    sale_id=exit_data.sale_id,
                    destination_warehouse_id=exit_data.destination_warehouse_id,
                    reason=exit_data.reason,
                    notes=item.notes,
                    parent_movement_id=main_movement.id,
                    created_by=current_user.id,
                    created_at=datetime.utcnow()
                )
                db.add(movement_detail)
                
                # Calculate total value
                if item.unit_price:
                    total_value += item.quantity * item.unit_price
                
                processed_items.append({
                    "id": movement_detail.id if movement_detail.id else 0,
                    "product_variant_id": item.product_variant_id,
                    "unit_id": item.unit_id,
                    "quantity": item.quantity,
                    "unit_price": item.unit_price,
                    "notes": item.notes,
                    "created_at": datetime.utcnow()
                })
                
            except Exception as e:
                errors.append(f"Error processing item {item.product_variant_id}: {str(e)}")
        
        if errors and not processed_items:
            db.rollback()
            raise HTTPException(status_code=400, detail={"errors": errors})
        
        # Update main movement with totals
        main_movement.total_value = total_value if total_value > 0 else None
        
        db.commit()
        
        return InventoryMovementMultiResponse(
            id=main_movement.id,
            warehouse_id=main_movement.warehouse_id,
            movement_type="exit",
            reference_number=main_movement.reference_number,
            customer_id=main_movement.customer_id,
            sale_id=main_movement.sale_id,
            destination_warehouse_id=main_movement.destination_warehouse_id,
            reason=main_movement.reason,
            notes=main_movement.notes,
            total_items=len(processed_items),
            total_value=total_value if total_value > 0 else None,
            status="completed",
            items=processed_items,
            created_at=main_movement.created_at,
            created_by=main_movement.created_by
        )
        
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Error creating multi-exit: {str(e)}")


@router.post("/adjustments/multi", response_model=InventoryMovementMultiResponse)
def create_multi_adjustment(
    adjustment_data: InventoryAdjustmentMultiCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Crear ajuste de inventario con múltiples productos"""
    
    try:
        # Validate warehouse exists
        warehouse = db.query(Warehouse).filter(Warehouse.id == adjustment_data.warehouse_id).first()
        if not warehouse:
            raise HTTPException(status_code=404, detail="Warehouse not found")
        
        # Create main adjustment record
        main_adjustment = InventoryAdjustment(
            warehouse_id=adjustment_data.warehouse_id,
            reference_number=adjustment_data.reference_number,
            reason=adjustment_data.reason,
            notes=adjustment_data.notes,
            status="completed",
            created_by=current_user.id,
            created_at=datetime.utcnow()
        )
        db.add(main_adjustment)
        db.flush()  # Get the ID
        
        processed_items = []
        total_adjustments = 0
        errors = []
        warnings = []
        
        for item in adjustment_data.items:
            try:
                # Validate product variant and unit
                variant = db.query(ProductVariant).filter(ProductVariant.id == item.product_variant_id).first()
                if not variant:
                    errors.append(f"Product variant {item.product_variant_id} not found")
                    continue
                
                unit = db.query(Unit).filter(Unit.id == item.unit_id).first()
                if not unit:
                    errors.append(f"Unit {item.unit_id} not found")
                    continue
                
                # Get or create inventory record
                inventory = db.query(Inventory).filter(
                    and_(
                        Inventory.warehouse_id == adjustment_data.warehouse_id,
                        Inventory.product_variant_id == item.product_variant_id,
                        Inventory.unit_id == item.unit_id
                    )
                ).first()
                
                if not inventory:
                    inventory = Inventory(
                        warehouse_id=adjustment_data.warehouse_id,
                        product_variant_id=item.product_variant_id,
                        unit_id=item.unit_id,
                        quantity=0,
                        minimum_stock=0
                    )
                    db.add(inventory)
                    db.flush()
                
                # Check for negative stock after adjustment
                if inventory.quantity + item.quantity_adjustment < 0:
                    warnings.append(f"Adjustment for product {item.product_variant_id} would result in negative stock")
                
                # Update inventory quantity
                old_quantity = inventory.quantity
                inventory.quantity += item.quantity_adjustment
                
                # Create adjustment item
                adjustment_item = InventoryAdjustmentItem(
                    adjustment_id=main_adjustment.id,
                    product_variant_id=item.product_variant_id,
                    unit_id=item.unit_id,
                    old_quantity=old_quantity,
                    new_quantity=inventory.quantity,
                    quantity_adjustment=item.quantity_adjustment,
                    cost_adjustment=item.cost_adjustment,
                    reason=item.reason,
                    notes=item.notes
                )
                db.add(adjustment_item)
                
                # Create movement record for tracking
                movement_type = "adjustment_in" if item.quantity_adjustment > 0 else "adjustment_out"
                movement_detail = InventoryMovement(
                    warehouse_id=adjustment_data.warehouse_id,
                    product_variant_id=item.product_variant_id,
                    unit_id=item.unit_id,
                    movement_type=movement_type,
                    quantity=item.quantity_adjustment,
                    reference_number=adjustment_data.reference_number,
                    reason=item.reason or adjustment_data.reason,
                    notes=item.notes,
                    adjustment_id=main_adjustment.id,
                    created_by=current_user.id,
                    created_at=datetime.utcnow()
                )
                db.add(movement_detail)
                
                total_adjustments += abs(item.quantity_adjustment)
                
                processed_items.append({
                    "id": adjustment_item.id if hasattr(adjustment_item, 'id') else 0,
                    "product_variant_id": item.product_variant_id,
                    "unit_id": item.unit_id,
                    "quantity": item.quantity_adjustment,
                    "cost_adjustment": item.cost_adjustment,
                    "notes": item.notes,
                    "created_at": datetime.utcnow()
                })
                
            except Exception as e:
                errors.append(f"Error processing adjustment for item {item.product_variant_id}: {str(e)}")
        
        if errors and not processed_items:
            db.rollback()
            raise HTTPException(status_code=400, detail={"errors": errors})
        
        db.commit()
        
        return InventoryMovementMultiResponse(
            id=main_adjustment.id,
            warehouse_id=main_adjustment.warehouse_id,
            movement_type="adjustment",
            reference_number=main_adjustment.reference_number,
            reason=main_adjustment.reason,
            notes=main_adjustment.notes,
            total_items=len(processed_items),
            total_value=None,  # Adjustments don't have monetary value
            status=main_adjustment.status,
            items=processed_items,
            created_at=main_adjustment.created_at,
            created_by=main_adjustment.created_by
        )
        
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Error creating multi-adjustment: {str(e)}")


@router.get("/movements/multi/{movement_id}", response_model=InventoryMovementMultiResponse)
def get_multi_movement_details(
    movement_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Obtener detalles de un movimiento multi-item"""
    
    # Get main movement or adjustment
    main_movement = db.query(InventoryMovement).filter(InventoryMovement.id == movement_id).first()
    if not main_movement:
        # Try to find as adjustment
        adjustment = db.query(InventoryAdjustment).filter(InventoryAdjustment.id == movement_id).first()
        if not adjustment:
            raise HTTPException(status_code=404, detail="Movement not found")
        
        # Get adjustment items
        items = db.query(InventoryAdjustmentItem).filter(
            InventoryAdjustmentItem.adjustment_id == movement_id
        ).all()
        
        return InventoryMovementMultiResponse(
            id=adjustment.id,
            warehouse_id=adjustment.warehouse_id,
            movement_type="adjustment",
            reference_number=adjustment.reference_number,
            reason=adjustment.reason,
            notes=adjustment.notes,
            total_items=len(items),
            total_value=None,
            status=adjustment.status,
            items=[{
                "id": item.id,
                "product_variant_id": item.product_variant_id,
                "unit_id": item.unit_id,
                "quantity": item.quantity_adjustment,
                "cost_adjustment": item.cost_adjustment,
                "notes": item.notes,
                "created_at": adjustment.created_at
            } for item in items],
            created_at=adjustment.created_at,
            created_by=adjustment.created_by
        )
    
    # Get child movements for entry/exit
    child_movements = db.query(InventoryMovement).filter(
        InventoryMovement.parent_movement_id == movement_id
    ).all()
    
    return InventoryMovementMultiResponse(
        id=main_movement.id,
        warehouse_id=main_movement.warehouse_id,
        movement_type=main_movement.movement_type,
        reference_number=main_movement.reference_number,
        supplier_id=main_movement.supplier_id,
        customer_id=main_movement.customer_id,
        purchase_order_id=main_movement.purchase_order_id,
        sale_id=main_movement.sale_id,
        destination_warehouse_id=main_movement.destination_warehouse_id,
        reason=main_movement.reason,
        notes=main_movement.notes,
        total_items=len(child_movements),
        total_value=main_movement.total_value,
        status="completed",
        items=[{
            "id": mov.id,
            "product_variant_id": mov.product_variant_id,
            "unit_id": mov.unit_id,
            "quantity": abs(mov.quantity),  # Always show positive quantity
            "cost_per_unit": mov.cost_per_unit,
            "unit_price": mov.unit_price,
            "expiry_date": mov.expiry_date,
            "batch_number": mov.batch_number,
            "notes": mov.notes,
            "created_at": mov.created_at
        } for mov in child_movements],
        created_at=main_movement.created_at,
        created_by=main_movement.created_by
    )


# Inventory Movements
@router.get("/movements", response_model=List[InventoryMovementSchema])
def get_inventory_movements(
    warehouse_id: Optional[int] = Query(None, description="Filter by warehouse"),
    product_variant_id: Optional[int] = Query(None, description="Filter by product variant"),
    movement_type: Optional[MovementType] = Query(None, description="Filter by movement type"),
    limit: int = Query(100, description="Limit number of results"),
    offset: int = Query(0, description="Offset for pagination"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get inventory movements with optional filters"""
    
    query = db.query(InventoryMovement).options(
        joinedload(InventoryMovement.warehouse),
        joinedload(InventoryMovement.product_variant).joinedload(ProductVariant.product),
        joinedload(InventoryMovement.unit),
        joinedload(InventoryMovement.user)
    )
    
    # Apply filters
    if warehouse_id:
        query = query.filter(InventoryMovement.warehouse_id == warehouse_id)
    
    if product_variant_id:
        query = query.filter(InventoryMovement.product_variant_id == product_variant_id)
    
    if movement_type:
        query = query.filter(InventoryMovement.movement_type == movement_type)
    
    # Order by created_at descending (most recent first)
    query = query.order_by(desc(InventoryMovement.created_at))
    
    # Apply pagination
    movements = query.offset(offset).limit(limit).all()
    
    return movements
