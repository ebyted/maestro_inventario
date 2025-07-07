from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import and_, or_, func
from app.db.database import get_db
from app.models.models import (
    PurchaseOrder, PurchaseOrderItem, PurchaseOrderReceipt, PurchaseOrderReceiptItem,
    Supplier, Warehouse, Business, ProductVariant, Unit, InventoryMovement, User
)
from app.schemas.production import (
    PurchaseOrderResponse, PurchaseOrderCreate, PurchaseOrderUpdate,
    PurchaseOrderReceiptResponse, PurchaseOrderReceiptCreate,
    PurchaseOrderStatus, MovementType
)
from app.api.v1.endpoints.auth import get_current_user
import uuid
from datetime import datetime

router = APIRouter()


@router.get("/", response_model=List[PurchaseOrderResponse])
def read_purchase_orders(
    business_id: int,
    skip: int = 0,
    limit: int = 100,
    status: Optional[PurchaseOrderStatus] = Query(None, description="Filter by status"),
    supplier_id: Optional[int] = Query(None, description="Filter by supplier"),
    search: Optional[str] = Query(None, description="Search by order number or supplier reference"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get all purchase orders for a business with optional filtering."""
    query = db.query(PurchaseOrder).options(
        joinedload(PurchaseOrder.supplier),
        joinedload(PurchaseOrder.warehouse),
        joinedload(PurchaseOrder.items).joinedload(PurchaseOrderItem.product_variant)
    ).filter(PurchaseOrder.business_id == business_id)
    
    if status:
        query = query.filter(PurchaseOrder.status == status)
    
    if supplier_id:
        query = query.filter(PurchaseOrder.supplier_id == supplier_id)
    
    if search:
        search_filter = or_(
            PurchaseOrder.order_number.contains(search),
            PurchaseOrder.supplier_reference.contains(search)
        )
        query = query.filter(search_filter)
    
    purchase_orders = query.order_by(PurchaseOrder.created_at.desc()).offset(skip).limit(limit).all()
    return purchase_orders


@router.get("/{purchase_order_id}", response_model=PurchaseOrderResponse)
def read_purchase_order(
    purchase_order_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get a specific purchase order by ID."""
    purchase_order = db.query(PurchaseOrder).options(
        joinedload(PurchaseOrder.supplier),
        joinedload(PurchaseOrder.warehouse),
        joinedload(PurchaseOrder.items).joinedload(PurchaseOrderItem.product_variant),
        joinedload(PurchaseOrder.items).joinedload(PurchaseOrderItem.unit)
    ).filter(PurchaseOrder.id == purchase_order_id).first()
    
    if not purchase_order:
        raise HTTPException(status_code=404, detail="Purchase order not found")
    
    return purchase_order


@router.post("/", response_model=PurchaseOrderResponse)
def create_purchase_order(
    purchase_order: PurchaseOrderCreate,
    business_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new purchase order."""
    # Verify business, supplier, and warehouse exist
    business = db.query(Business).filter(Business.id == business_id).first()
    if not business:
        raise HTTPException(status_code=404, detail="Business not found")
    
    supplier = db.query(Supplier).filter(
        and_(Supplier.id == purchase_order.supplier_id, Supplier.business_id == business_id)
    ).first()
    if not supplier:
        raise HTTPException(status_code=404, detail="Supplier not found")
    
    warehouse = db.query(Warehouse).filter(
        and_(Warehouse.id == purchase_order.warehouse_id, Warehouse.business_id == business_id)
    ).first()
    if not warehouse:
        raise HTTPException(status_code=404, detail="Warehouse not found")
    
    # Generate order number if not provided
    if not purchase_order.order_number:
        order_number = f"PO-{datetime.now().strftime('%Y%m%d')}-{str(uuid.uuid4())[:8].upper()}"
    else:
        order_number = purchase_order.order_number
        # Check if order number already exists
        existing = db.query(PurchaseOrder).filter(
            and_(
                PurchaseOrder.business_id == business_id,
                PurchaseOrder.order_number == order_number
            )
        ).first()
        if existing:
            raise HTTPException(status_code=400, detail="Order number already exists")
    
    # Calculate totals from items
    subtotal = sum(item.quantity_ordered * item.unit_cost for item in purchase_order.items)
    tax_amount = subtotal * (purchase_order.tax_rate or 0.0)
    total_amount = subtotal + tax_amount + (purchase_order.shipping_cost or 0.0) - (purchase_order.discount_amount or 0.0)
    
    # Create purchase order
    po_data = purchase_order.dict(exclude={'items'})
    po_data.update({
        'business_id': business_id,
        'user_id': current_user.id,
        'order_number': order_number,
        'subtotal': subtotal,
        'tax_amount': tax_amount,
        'total_amount': total_amount,
        'status': PurchaseOrderStatus.DRAFT
    })
    
    db_po = PurchaseOrder(**po_data)
    db.add(db_po)
    db.flush()  # Get the ID without committing
    
    # Create purchase order items
    for item_data in purchase_order.items:
        # Verify product variant exists
        product_variant = db.query(ProductVariant).filter(
            ProductVariant.id == item_data.product_variant_id
        ).first()
        if not product_variant:
            raise HTTPException(
                status_code=404, 
                detail=f"Product variant {item_data.product_variant_id} not found"
            )
        
        # Calculate item total
        total_cost = item_data.quantity_ordered * item_data.unit_cost
        quantity_pending = item_data.quantity_ordered
        
        db_item = PurchaseOrderItem(
            purchase_order_id=db_po.id,
            product_variant_id=item_data.product_variant_id,
            unit_id=item_data.unit_id,
            quantity_ordered=item_data.quantity_ordered,
            quantity_received=0.0,
            quantity_pending=quantity_pending,
            unit_cost=item_data.unit_cost,
            total_cost=total_cost,
            product_name=product_variant.name or product_variant.product.name,
            product_sku=product_variant.sku,
            supplier_sku=item_data.supplier_sku,
            notes=item_data.notes
        )
        db.add(db_item)
    
    db.commit()
    db.refresh(db_po)
    
    # Reload with relationships
    db_po = db.query(PurchaseOrder).options(
        joinedload(PurchaseOrder.supplier),
        joinedload(PurchaseOrder.warehouse),
        joinedload(PurchaseOrder.items)
    ).filter(PurchaseOrder.id == db_po.id).first()
    
    return db_po


@router.put("/{purchase_order_id}", response_model=PurchaseOrderResponse)
def update_purchase_order(
    purchase_order_id: int,
    purchase_order_update: PurchaseOrderUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update an existing purchase order."""
    db_po = db.query(PurchaseOrder).filter(PurchaseOrder.id == purchase_order_id).first()
    if not db_po:
        raise HTTPException(status_code=404, detail="Purchase order not found")
    
    # Only allow updates if order is in DRAFT or PENDING status
    if db_po.status not in [PurchaseOrderStatus.DRAFT, PurchaseOrderStatus.PENDING]:
        raise HTTPException(
            status_code=400, 
            detail="Purchase order cannot be modified in current status"
        )
    
    # Update only provided fields
    update_data = purchase_order_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_po, field, value)
    
    db.commit()
    db.refresh(db_po)
    return db_po


@router.patch("/{purchase_order_id}/status")
def update_purchase_order_status(
    purchase_order_id: int,
    status: PurchaseOrderStatus,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update the status of a purchase order."""
    db_po = db.query(PurchaseOrder).filter(PurchaseOrder.id == purchase_order_id).first()
    if not db_po:
        raise HTTPException(status_code=404, detail="Purchase order not found")
    
    # Validate status transitions
    valid_transitions = {
        PurchaseOrderStatus.DRAFT: [PurchaseOrderStatus.PENDING, PurchaseOrderStatus.CANCELLED],
        PurchaseOrderStatus.PENDING: [PurchaseOrderStatus.APPROVED, PurchaseOrderStatus.CANCELLED],
        PurchaseOrderStatus.APPROVED: [PurchaseOrderStatus.ORDERED, PurchaseOrderStatus.CANCELLED],
        PurchaseOrderStatus.ORDERED: [PurchaseOrderStatus.PARTIALLY_RECEIVED, PurchaseOrderStatus.RECEIVED],
        PurchaseOrderStatus.PARTIALLY_RECEIVED: [PurchaseOrderStatus.RECEIVED],
    }
    
    if status not in valid_transitions.get(db_po.status, []):
        raise HTTPException(
            status_code=400,
            detail=f"Cannot change status from {db_po.status} to {status}"
        )
    
    db_po.status = status
    if status == PurchaseOrderStatus.APPROVED:
        db_po.approved_at = datetime.utcnow()
        db_po.approved_by_id = current_user.id
    
    db.commit()
    return {"message": f"Purchase order status updated to {status}"}


@router.post("/{purchase_order_id}/receipts", response_model=PurchaseOrderReceiptResponse)
def create_purchase_receipt(
    purchase_order_id: int,
    receipt: PurchaseOrderReceiptCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a receipt for a purchase order (receive merchandise)."""
    # Verify purchase order exists and is in correct status
    db_po = db.query(PurchaseOrder).filter(PurchaseOrder.id == purchase_order_id).first()
    if not db_po:
        raise HTTPException(status_code=404, detail="Purchase order not found")
    
    if db_po.status not in [PurchaseOrderStatus.ORDERED, PurchaseOrderStatus.PARTIALLY_RECEIVED]:
        raise HTTPException(
            status_code=400,
            detail="Purchase order must be in ORDERED or PARTIALLY_RECEIVED status to receive items"
        )
    
    # Generate receipt number if not provided
    if not receipt.receipt_number:
        receipt_number = f"REC-{datetime.now().strftime('%Y%m%d')}-{str(uuid.uuid4())[:8].upper()}"
    else:
        receipt_number = receipt.receipt_number
    
    # Create receipt
    db_receipt = PurchaseOrderReceipt(
        purchase_order_id=purchase_order_id,
        warehouse_id=receipt.warehouse_id,
        user_id=current_user.id,
        receipt_number=receipt_number,
        supplier_invoice_number=receipt.supplier_invoice_number,
        supplier_delivery_note=receipt.supplier_delivery_note,
        notes=receipt.notes,
        quality_notes=receipt.quality_notes
    )
    db.add(db_receipt)
    db.flush()
    
    # Process receipt items and create inventory movements
    total_received = 0
    
    for item_data in receipt.items:
        # Verify purchase order item exists
        po_item = db.query(PurchaseOrderItem).filter(
            and_(
                PurchaseOrderItem.id == item_data.purchase_order_item_id,
                PurchaseOrderItem.purchase_order_id == purchase_order_id
            )
        ).first()
        
        if not po_item:
            raise HTTPException(
                status_code=404,
                detail=f"Purchase order item {item_data.purchase_order_item_id} not found"
            )
        
        # Validate received quantity
        max_receivable = po_item.quantity_ordered - po_item.quantity_received
        if item_data.quantity_received > max_receivable:
            raise HTTPException(
                status_code=400,
                detail=f"Cannot receive {item_data.quantity_received} units. Maximum receivable: {max_receivable}"
            )
        
        # Create receipt item
        quantity_accepted = item_data.quantity_accepted or item_data.quantity_received
        
        db_receipt_item = PurchaseOrderReceiptItem(
            receipt_id=db_receipt.id,
            purchase_order_item_id=item_data.purchase_order_item_id,
            quantity_received=item_data.quantity_received,
            quantity_accepted=quantity_accepted,
            quantity_rejected=item_data.quantity_rejected,
            batch_number=item_data.batch_number,
            expiry_date=item_data.expiry_date,
            quality_status=item_data.quality_status,
            notes=item_data.notes,
            rejection_reason=item_data.rejection_reason
        )
        db.add(db_receipt_item)
        
        # Update purchase order item quantities
        po_item.quantity_received += item_data.quantity_received
        po_item.quantity_pending = po_item.quantity_ordered - po_item.quantity_received
        
        # Create inventory movement for accepted items
        if quantity_accepted > 0:
            inventory_movement = InventoryMovement(
                warehouse_id=receipt.warehouse_id,
                product_variant_id=po_item.product_variant_id,
                unit_id=po_item.unit_id,
                user_id=current_user.id,
                movement_type=MovementType.ENTRY,
                quantity=quantity_accepted,
                cost_per_unit=po_item.unit_cost,
                batch_number=item_data.batch_number,
                expiry_date=item_data.expiry_date,
                reference_number=receipt_number,
                reason=f"Purchase Order Receipt - PO#{db_po.order_number}",
                notes=f"Received from supplier: {db_po.supplier.name}",
                purchase_order_id=purchase_order_id,
                purchase_order_receipt_id=db_receipt.id
            )
            db.add(inventory_movement)
        
        total_received += item_data.quantity_received
    
    # Update purchase order status based on completion
    total_ordered = sum(item.quantity_ordered for item in db_po.items)
    total_received_all = sum(item.quantity_received for item in db_po.items)
    
    if total_received_all >= total_ordered:
        db_po.status = PurchaseOrderStatus.RECEIVED
        db_po.actual_delivery_date = datetime.utcnow()
    elif total_received_all > 0:
        db_po.status = PurchaseOrderStatus.PARTIALLY_RECEIVED
    
    db.commit()
    db.refresh(db_receipt)
    return db_receipt


@router.get("/{purchase_order_id}/receipts", response_model=List[PurchaseOrderReceiptResponse])
def get_purchase_receipts(
    purchase_order_id: int,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get all receipts for a purchase order."""
    receipts = db.query(PurchaseOrderReceipt).filter(
        PurchaseOrderReceipt.purchase_order_id == purchase_order_id
    ).order_by(PurchaseOrderReceipt.created_at.desc()).offset(skip).limit(limit).all()
    
    return receipts


@router.delete("/{purchase_order_id}")
def cancel_purchase_order(
    purchase_order_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Cancel a purchase order."""
    db_po = db.query(PurchaseOrder).filter(PurchaseOrder.id == purchase_order_id).first()
    if not db_po:
        raise HTTPException(status_code=404, detail="Purchase order not found")
    
    # Only allow cancellation if order hasn't been received
    if db_po.status in [PurchaseOrderStatus.RECEIVED, PurchaseOrderStatus.PARTIALLY_RECEIVED]:
        raise HTTPException(
            status_code=400,
            detail="Cannot cancel purchase order that has already been received"
        )
    
    db_po.status = PurchaseOrderStatus.CANCELLED
    db.commit()
    return {"message": "Purchase order cancelled successfully"}
