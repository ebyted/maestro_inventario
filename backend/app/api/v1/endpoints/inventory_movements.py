from fastapi import APIRouter, Depends, HTTPException, Query, Request
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime
from app.db.database import get_db
from app.models.models import InventoryMovement, Warehouse, ProductVariant, Unit, User, MovementType
from app.api.v1.endpoints.auth import get_current_user
from pydantic import BaseModel, Field
import logging

router = APIRouter()  # Remove prefix here, set only in api.py

class InventoryMovementItemCreate(BaseModel):
    product_variant_id: int
    quantity: float
    unit_id: int

class InventoryMovementCreate(BaseModel):
    movement_type: MovementType
    warehouse_id: int
    reference_number: Optional[str] = None
    notes: Optional[str] = None
    items: List[InventoryMovementItemCreate]

class InventoryMovementResponse(BaseModel):
    id: int
    movement_type: str
    warehouse_id: int
    reference_number: Optional[str]
    notes: Optional[str]
    created_at: datetime
    items: List[InventoryMovementItemCreate]

class InventoryMovementListResponse(BaseModel):
    id: int
    movement_type: str
    warehouse_id: int
    product_variant_id: int
    unit_id: int
    user_id: int
    quantity: float
    reference_number: str | None = None
    notes: str | None = None
    created_at: datetime

@router.post("/", response_model=InventoryMovementResponse)
def create_inventory_movement(
    movement: InventoryMovementCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
    request: Request = None
):
    logging.warning(f"[DEBUG] POST /inventory-movements/ called. Headers: {dict(request.headers) if request else 'N/A'} Body: {movement}")
    warehouse = db.query(Warehouse).filter(Warehouse.id == movement.warehouse_id).first()
    if not warehouse:
        logging.error("[DEBUG] Warehouse not found.")
        raise HTTPException(status_code=404, detail="Warehouse not found")
    created_movements = []
    movement_ids = []
    for item in movement.items:
        variant = db.query(ProductVariant).filter(ProductVariant.id == item.product_variant_id).first()
        if not variant:
            raise HTTPException(status_code=404, detail=f"Product variant {item.product_variant_id} not found")
        unit = db.query(Unit).filter(Unit.id == item.unit_id).first()
        if not unit:
            raise HTTPException(status_code=404, detail=f"Unit {item.unit_id} not found")
        inv_move = InventoryMovement(
            warehouse_id=movement.warehouse_id,
            product_variant_id=item.product_variant_id,
            unit_id=item.unit_id,
            user_id=current_user.id,
            movement_type=movement.movement_type,
            quantity=item.quantity,
            reference_number=movement.reference_number,
            notes=movement.notes,
            created_at=datetime.utcnow(),
        )
        db.add(inv_move)
        created_movements.append(inv_move)
    try:
        db.commit()
        db.refresh(created_movements[0])
        return InventoryMovementResponse(
            id=created_movements[0].id,
            movement_type=created_movements[0].movement_type.value,
            warehouse_id=created_movements[0].warehouse_id,
            reference_number=created_movements[0].reference_number,
            notes=created_movements[0].notes,
            created_at=created_movements[0].created_at,
            items=movement.items
        )
    except Exception as e:
        logging.error(f"[DEBUG] Exception in create_inventory_movement: {e}")
        raise

@router.post("", response_model=InventoryMovementResponse, include_in_schema=False)
def create_inventory_movement_noslash(*args, **kwargs):
    return create_inventory_movement(*args, **kwargs)

@router.get("/", response_model=List[InventoryMovementListResponse])
def list_inventory_movements(
    db: Session = Depends(get_db),
    warehouse_id: int | None = Query(None),
    date_from: datetime | None = Query(None),
    date_to: datetime | None = Query(None),
    limit: int = Query(100, ge=1, le=1000),
    offset: int = Query(0, ge=0)
):
    query = db.query(InventoryMovement)
    if warehouse_id:
        query = query.filter(InventoryMovement.warehouse_id == warehouse_id)
    if date_from:
        query = query.filter(InventoryMovement.created_at >= date_from)
    if date_to:
        query = query.filter(InventoryMovement.created_at <= date_to)
    movements = query.order_by(InventoryMovement.created_at.desc()).offset(offset).limit(limit).all()
    return [
        InventoryMovementListResponse(
            id=m.id,
            movement_type=m.movement_type.value if hasattr(m.movement_type, 'value') else str(m.movement_type),
            warehouse_id=m.warehouse_id,
            product_variant_id=m.product_variant_id,
            unit_id=m.unit_id,
            user_id=m.user_id,
            quantity=m.quantity,
            reference_number=m.reference_number,
            notes=m.notes,
            created_at=m.created_at
        ) for m in movements
    ]
