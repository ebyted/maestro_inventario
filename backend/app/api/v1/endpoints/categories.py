from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import and_, or_
from app.db.database import get_db
from app.models.models import Category, User
from app.schemas.production import (
    CategoryResponse, CategoryCreate, CategoryUpdate
)
from app.api.v1.endpoints.auth import get_current_user

router = APIRouter()


@router.get("/", response_model=List[CategoryResponse])
def read_categories(
    business_id: int,
    skip: int = 0,
    limit: int = 100,
    search: Optional[str] = Query(None, description="Search by name or description"),
    active_only: bool = Query(True, description="Filter only active categories"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get all categories for a business with optional filtering."""
    query = db.query(Category).filter(Category.business_id == business_id)
    
    if active_only:
        query = query.filter(Category.is_active == True)
    
    if search:
        search_filter = or_(
            Category.name.contains(search),
            Category.description.contains(search)
        )
        query = query.filter(search_filter)
    
    categories = query.order_by(Category.name).offset(skip).limit(limit).all()
    return categories


@router.get("/{category_id}", response_model=CategoryResponse)
def read_category(
    category_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get a specific category by ID."""
    category = db.query(Category).filter(Category.id == category_id).first()
    if not category:
        raise HTTPException(status_code=404, detail="Category not found")
    return category


@router.post("/", response_model=CategoryResponse)
def create_category(
    category: CategoryCreate,
    business_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new category."""
    # Check if category name already exists in this business
    existing = db.query(Category).filter(
        and_(
            Category.business_id == business_id,
            Category.name == category.name
        )
    ).first()
    if existing:
        raise HTTPException(
            status_code=400, 
            detail="Category with this name already exists"
        )
    
    db_category = Category(
        **category.dict(),
        business_id=business_id,
        created_by_id=current_user.id
    )
    db.add(db_category)
    db.commit()
    db.refresh(db_category)
    return db_category


@router.put("/{category_id}", response_model=CategoryResponse)
def update_category(
    category_id: int,
    category_update: CategoryUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update an existing category."""
    db_category = db.query(Category).filter(Category.id == category_id).first()
    if not db_category:
        raise HTTPException(status_code=404, detail="Category not found")
    
    # Check if new name already exists (if name is being changed)
    if category_update.name and category_update.name != db_category.name:
        existing = db.query(Category).filter(
            and_(
                Category.business_id == db_category.business_id,
                Category.name == category_update.name,
                Category.id != category_id
            )
        ).first()
        if existing:
            raise HTTPException(
                status_code=400, 
                detail="Category with this name already exists"
            )
    
    # Update only provided fields
    update_data = category_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_category, field, value)
    
    db_category.updated_by_id = current_user.id
    db.commit()
    db.refresh(db_category)
    return db_category


@router.delete("/{category_id}")
def delete_category(
    category_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Soft delete a category (mark as inactive)."""
    db_category = db.query(Category).filter(Category.id == category_id).first()
    if not db_category:
        raise HTTPException(status_code=404, detail="Category not found")
    
    # Check if category is being used by products
    from app.models.models import Product
    products_using_category = db.query(Product).filter(
        Product.category_id == category_id
    ).count()
    
    if products_using_category > 0:
        # Soft delete - mark as inactive
        db_category.is_active = False
        db_category.updated_by_id = current_user.id
        db.commit()
        return {"message": f"Category marked as inactive. {products_using_category} products are using this category."}
    else:
        # Hard delete if not being used
        db.delete(db_category)
        db.commit()
        return {"message": "Category deleted successfully"}


@router.patch("/{category_id}/activate")
def activate_category(
    category_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Reactivate a category."""
    db_category = db.query(Category).filter(Category.id == category_id).first()
    if not db_category:
        raise HTTPException(status_code=404, detail="Category not found")
    
    db_category.is_active = True
    db_category.updated_by_id = current_user.id
    db.commit()
    return {"message": "Category activated successfully"}
