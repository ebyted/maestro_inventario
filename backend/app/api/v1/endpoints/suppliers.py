from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import and_, or_
from app.db.database import get_db
from app.models.models import Supplier, Business
from app.schemas.production import (
    SupplierResponse, SupplierCreate, SupplierUpdate
)
from app.api.v1.endpoints.auth import get_current_user
from app.models.models import User

router = APIRouter()


def is_admin(user: User):
    return user.role == "ADMIN" or (hasattr(user.role, "value") and user.role.value == "ADMIN")


@router.get("/", response_model=List[SupplierResponse])
def read_suppliers(
    business_id: int,
    skip: int = 0,
    limit: int = 100,
    search: Optional[str] = Query(None, description="Search by name, company name or email"),
    is_active: Optional[bool] = Query(True, description="Filter by active status"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get all suppliers for a business with optional search and filtering."""
    query = db.query(Supplier).filter(Supplier.business_id == business_id)
    
    if is_active is not None:
        query = query.filter(Supplier.is_active == is_active)
    
    if search:
        search_filter = or_(
            Supplier.name.contains(search),
            Supplier.company_name.contains(search),
            Supplier.email.contains(search),
            Supplier.contact_person.contains(search)
        )
        query = query.filter(search_filter)
    
    suppliers = query.offset(skip).limit(limit).all()
    return suppliers


@router.get("/{supplier_id}", response_model=SupplierResponse)
def read_supplier(
    supplier_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get a specific supplier by ID."""
    supplier = db.query(Supplier).filter(Supplier.id == supplier_id).first()
    if not supplier:
        raise HTTPException(status_code=404, detail="Supplier not found")
    return supplier


@router.post("/", response_model=SupplierResponse)
def create_supplier(
    supplier: SupplierCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if not is_admin(current_user):
        raise HTTPException(status_code=403, detail="Solo un administrador puede crear proveedores.")
    
    db_supplier = Supplier(**supplier.dict())
    db.add(db_supplier)
    db.commit()
    db.refresh(db_supplier)
    return db_supplier


@router.put("/{supplier_id}", response_model=SupplierResponse)
def update_supplier(
    supplier_id: int,
    supplier_update: SupplierUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update an existing supplier."""
    db_supplier = db.query(Supplier).filter(Supplier.id == supplier_id).first()
    if not db_supplier:
        raise HTTPException(status_code=404, detail="Supplier not found")
    
    # Update only provided fields
    update_data = supplier_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_supplier, field, value)
    
    db.commit()
    db.refresh(db_supplier)
    return db_supplier


@router.delete("/{supplier_id}")
def delete_supplier(
    supplier_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Soft delete a supplier (mark as inactive)."""
    db_supplier = db.query(Supplier).filter(Supplier.id == supplier_id).first()
    if not db_supplier:
        raise HTTPException(status_code=404, detail="Supplier not found")
    
    db_supplier.is_active = False
    db.commit()
    return {"message": "Supplier deactivated successfully"}
