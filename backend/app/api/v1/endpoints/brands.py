from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import and_, or_
from app.db.database import get_db
from app.models.models import Brand, User
from app.schemas.production import (
    BrandResponse, BrandCreate, BrandUpdate
)
from app.api.v1.endpoints.auth import get_current_user

router = APIRouter()


@router.get("/", response_model=List[BrandResponse])
def read_brands(
    business_id: int,
    skip: int = 0,
    limit: int = 100,
    search: Optional[str] = Query(None, description="Search by name or description"),
    active_only: bool = Query(True, description="Filter only active brands"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get all brands for a business with optional filtering."""
    query = db.query(Brand).filter(Brand.business_id == business_id)
    
    if active_only:
        query = query.filter(Brand.is_active == True)
    
    if search:
        search_filter = or_(
            Brand.name.contains(search),
            Brand.description.contains(search)
        )
        query = query.filter(search_filter)
    
    brands = query.order_by(Brand.name).offset(skip).limit(limit).all()
    return brands


@router.get("/{brand_id}", response_model=BrandResponse)
def read_brand(
    brand_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get a specific brand by ID."""
    brand = db.query(Brand).filter(Brand.id == brand_id).first()
    if not brand:
        raise HTTPException(status_code=404, detail="Brand not found")
    return brand


@router.post("/", response_model=BrandResponse)
def create_brand(
    brand: BrandCreate,
    business_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new brand."""
    # Check if brand name already exists in this business
    existing = db.query(Brand).filter(
        and_(
            Brand.business_id == business_id,
            Brand.name == brand.name
        )
    ).first()
    if existing:
        raise HTTPException(
            status_code=400, 
            detail="Brand with this name already exists"
        )
    
    db_brand = Brand(
        **brand.dict(),
        business_id=business_id,
        created_by_id=current_user.id
    )
    db.add(db_brand)
    db.commit()
    db.refresh(db_brand)
    return db_brand


@router.put("/{brand_id}", response_model=BrandResponse)
def update_brand(
    brand_id: int,
    brand_update: BrandUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update an existing brand."""
    db_brand = db.query(Brand).filter(Brand.id == brand_id).first()
    if not db_brand:
        raise HTTPException(status_code=404, detail="Brand not found")
    
    # Check if new name already exists (if name is being changed)
    if brand_update.name and brand_update.name != db_brand.name:
        existing = db.query(Brand).filter(
            and_(
                Brand.business_id == db_brand.business_id,
                Brand.name == brand_update.name,
                Brand.id != brand_id
            )
        ).first()
        if existing:
            raise HTTPException(
                status_code=400, 
                detail="Brand with this name already exists"
            )
    
    # Update only provided fields
    update_data = brand_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_brand, field, value)
    
    db_brand.updated_by_id = current_user.id
    db.commit()
    db.refresh(db_brand)
    return db_brand


@router.delete("/{brand_id}")
def delete_brand(
    brand_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Soft delete a brand (mark as inactive)."""
    db_brand = db.query(Brand).filter(Brand.id == brand_id).first()
    if not db_brand:
        raise HTTPException(status_code=404, detail="Brand not found")
    
    # Check if brand is being used by products
    from app.models.models import Product
    products_using_brand = db.query(Product).filter(
        Product.brand_id == brand_id
    ).count()
    
    if products_using_brand > 0:
        # Soft delete - mark as inactive
        db_brand.is_active = False
        db_brand.updated_by_id = current_user.id
        db.commit()
        return {"message": f"Brand marked as inactive. {products_using_brand} products are using this brand."}
    else:
        # Hard delete if not being used
        db.delete(db_brand)
        db.commit()
        return {"message": "Brand deleted successfully"}


@router.patch("/{brand_id}/activate")
def activate_brand(
    brand_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Reactivate a brand."""
    db_brand = db.query(Brand).filter(Brand.id == brand_id).first()
    if not db_brand:
        raise HTTPException(status_code=404, detail="Brand not found")
    
    db_brand.is_active = True
    db_brand.updated_by_id = current_user.id
    db.commit()
    return {"message": "Brand activated successfully"}
