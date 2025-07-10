from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime
from app.db.database import get_db
from app.models.models import InventoryMovement, Warehouse, ProductVariant, Unit, User, MovementType
from app.api.v1.endpoints.auth import get_current_user
from pydantic import BaseModel, Field
from app.core.audit import log_action

router = APIRouter(prefix="/inventory-movements", tags=["Inventory Movements"])

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

def is_admin(user: User):
    return user.role == "ADMIN" or (hasattr(user.role, "value") and user.role.value == "ADMIN")

@router.post("/", response_model=InventoryMovementResponse)
def create_inventory_movement(
    movement: InventoryMovementCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if not is_admin(current_user):
        raise HTTPException(status_code=403, detail="Solo un administrador puede registrar movimientos de inventario.")
    warehouse = db.query(Warehouse).filter(Warehouse.id == movement.warehouse_id).first()
    if not warehouse:
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
    db.commit()
    db.refresh(created_movements[0])
    log_action(current_user.id, "create_inventory_movement", detail=f"type={movement.movement_type} items={len(movement.items)}")
    return InventoryMovementResponse(
        id=created_movements[0].id,
        movement_type=created_movements[0].movement_type.value,
        warehouse_id=created_movements[0].warehouse_id,
        reference_number=created_movements[0].reference_number,
        notes=created_movements[0].notes,
        created_at=created_movements[0].created_at,
        items=movement.items
    )
