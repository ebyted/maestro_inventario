from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.models import Warehouse
from app.schemas import Warehouse as WarehouseSchema, WarehouseCreate, WarehouseUpdate
from app.api.v1.endpoints.auth import get_current_user
from app.models import User

router = APIRouter()


@router.get("/", response_model=List[WarehouseSchema])
def read_warehouses(
    business_id: int = None,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    query = db.query(Warehouse)
    if business_id:
        query = query.filter(Warehouse.business_id == business_id)
    warehouses = query.offset(skip).limit(limit).all()
    return warehouses


@router.post("/", response_model=WarehouseSchema)
def create_warehouse(
    warehouse: WarehouseCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    db_warehouse = Warehouse(**warehouse.dict())
    db.add(db_warehouse)
    db.commit()
    db.refresh(db_warehouse)
    return db_warehouse
