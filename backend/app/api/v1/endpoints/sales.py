from typing import List
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.models import Sale, SaleItem, Inventory
from app.schemas import Sale as SaleSchema, SaleCreate
from app.api.v1.endpoints.auth import get_current_user
from app.models import User
import uuid

router = APIRouter()


@router.get("/", response_model=List[SaleSchema])
def read_sales(
    warehouse_id: int = None,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    query = db.query(Sale)
    if warehouse_id:
        query = query.filter(Sale.warehouse_id == warehouse_id)
    sales = query.offset(skip).limit(limit).all()
    return sales


@router.post("/", response_model=SaleSchema)
def create_sale(
    sale_data: SaleCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    # Calculate totals
    subtotal = sum(item.total_price for item in sale_data.items)
    tax = subtotal * 0.16  # 16% tax
    total = subtotal + tax
    
    # Generate sale number
    sale_number = f"SALE-{uuid.uuid4().hex[:8].upper()}"
    
    # Create sale
    sale_dict = sale_data.dict(exclude={'items'})
    sale_dict.update({
        'user_id': current_user.id,
        'sale_number': sale_number,
        'subtotal': subtotal,
        'tax': tax,
        'total': total
    })
    
    db_sale = Sale(**sale_dict)
    db.add(db_sale)
    db.commit()
    db.refresh(db_sale)
    
    # Create sale items and update inventory
    for item_data in sale_data.items:
        # Create sale item
        item_dict = item_data.dict()
        item_dict['sale_id'] = db_sale.id
        db_item = SaleItem(**item_dict)
        db.add(db_item)
        
        # Update inventory
        inventory = db.query(Inventory).filter(
            Inventory.warehouse_id == sale_data.warehouse_id,
            Inventory.product_variant_id == item_data.product_variant_id,
            Inventory.unit_id == item_data.unit_id
        ).first()
        
        if inventory:
            inventory.quantity -= item_data.quantity
    
    db.commit()
    db.refresh(db_sale)
    return db_sale
