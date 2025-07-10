from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, Query, status, Security
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import and_, or_, func, desc
from app.db.database import get_db
from app.models.models import Product, ProductVariant, Unit, User, Business
from app.models import Inventory
from app.schemas import (
    Product as ProductSchema, ProductCreate, ProductUpdate,
    ProductVariant as ProductVariantSchema, ProductVariantCreate, ProductVariantUpdate
)
from app.schemas.inventory import ProductWithInventory, ProductSearchFilters
from app.api.v1.endpoints.auth import get_current_user
from app.core.audit import log_action

router = APIRouter()


def is_admin(user: User):
    return user.role == "ADMIN" or (hasattr(user.role, "value") and user.role.value == "ADMIN")


@router.get("/", response_model=List[ProductSchema])
def get_products(
    search: Optional[str] = Query(None, description="Buscar por nombre, SKU, código de barras"),
    category: Optional[str] = Query(None, description="Filtrar por categoría"),
    brand: Optional[str] = Query(None, description="Filtrar por marca"),
    is_active: Optional[bool] = Query(True, description="Filtrar productos activos"),
    business_id: Optional[int] = Query(None, description="ID del negocio"),
    skip: int = Query(0, ge=0, description="Registros a omitir"),
    limit: int = Query(50, ge=1, le=100, description="Límite de registros"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Obtener lista de productos con filtros avanzados"""
    
    query = db.query(Product).options(
        joinedload(Product.base_unit),
        joinedload(Product.variants)
    )
    
    # Filter by business
    if business_id:
        query = query.filter(Product.business_id == business_id)
    else:
        # Get the main business with most products (Maestro Inventario)
        main_business = db.query(Business).filter(Business.name == "Maestro Inventario").first()
        if main_business:
            query = query.filter(Product.business_id == main_business.id)
        else:
            query = query.filter(Product.business_id == 1)  # Fallback
    
    # Search filter
    if search:
        search_term = f"%{search}%"
        query = query.filter(
            or_(
                Product.name.ilike(search_term),
                Product.description.ilike(search_term),
                Product.sku.ilike(search_term),
                Product.barcode.ilike(search_term)
            )
        )
    
    # Category filter
    if category:
        query = query.filter(Product.category == category)
    
    # Brand filter
    if brand:
        query = query.filter(Product.brand == brand)
    
    # Active filter
    if is_active is not None:
        query = query.filter(Product.is_active == is_active)
    
    # Order by name and apply pagination
    products = query.order_by(Product.name).offset(skip).limit(limit).all()
    
    return products


@router.get("/categories", response_model=List[str])
def get_product_categories(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Obtener lista de categorías de productos"""
    
    categories = db.query(Product.category).filter(
        and_(
            Product.category.isnot(None),
            Product.category != "",
            Product.business_id == 1  # TODO: Get from current user
        )
    ).distinct().all()
    
    return [cat[0] for cat in categories if cat[0]]


@router.get("/brands", response_model=List[str])
def get_product_brands(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Obtener lista de marcas de productos"""
    
    brands = db.query(Product.brand).filter(
        and_(
            Product.brand.isnot(None),
            Product.brand != "",
            Product.business_id == 1  # TODO: Get from current user
        )
    ).distinct().all()
    
    return [brand[0] for brand in brands if brand[0]]


@router.get("/{product_id}", response_model=ProductSchema)
def get_product(
    product_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Obtener producto por ID"""
    
    product = db.query(Product).options(
        joinedload(Product.base_unit),
        joinedload(Product.variants).joinedload(ProductVariant.unit),
        joinedload(Product.variants).joinedload(ProductVariant.inventory)
    ).filter(Product.id == product_id).first()
    
    if not product:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product not found"
        )
    
    return product


@router.post("/", response_model=ProductSchema)
def create_product(
    product: ProductCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Crear nuevo producto"""
    
    # Check if SKU is unique
    if product.sku:
        existing = db.query(Product).filter(Product.sku == product.sku).first()
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="SKU already exists"
            )
    
    # Check if barcode is unique
    if product.barcode:
        existing = db.query(Product).filter(Product.barcode == product.barcode).first()
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Barcode already exists"
            )
    
    db_product = Product(**product.dict())
    db.add(db_product)
    db.commit()
    db.refresh(db_product)
    
    log_action(current_user.id, "create_product", detail=f"product={product.name}")
    
    return db_product


@router.put("/{product_id}", response_model=ProductSchema)
def update_product(
    product_id: int,
    product_update: ProductUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Actualizar producto"""
    
    db_product = db.query(Product).filter(Product.id == product_id).first()
    if not db_product:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product not found"
        )
    
    # Check SKU uniqueness if being updated
    if product_update.sku and product_update.sku != db_product.sku:
        existing = db.query(Product).filter(
            and_(Product.sku == product_update.sku, Product.id != product_id)
        ).first()
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="SKU already exists"
            )
    
    # Check barcode uniqueness if being updated
    if product_update.barcode and product_update.barcode != db_product.barcode:
        existing = db.query(Product).filter(
            and_(Product.barcode == product_update.barcode, Product.id != product_id)
        ).first()
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Barcode already exists"
            )
    
    # Update fields
    update_data = product_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_product, field, value)
    
    db.commit()
    db.refresh(db_product)
    
    log_action(current_user.id, "update_product", detail=f"product_id={product_id}")
    
    return db_product


@router.delete("/{product_id}")
def delete_product(
    product_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Eliminar producto (soft delete, solo ADMIN)"""
    if not is_admin(current_user):
        raise HTTPException(status_code=403, detail="Solo un administrador puede eliminar productos.")
    
    db_product = db.query(Product).filter(Product.id == product_id).first()
    if not db_product:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product not found"
        )
    
    # Check if product has inventory
    inventory_count = db.query(Inventory).join(ProductVariant).filter(
        ProductVariant.product_id == product_id
    ).count()
    
    if inventory_count > 0:
        # Soft delete - just mark as inactive
        db_product.is_active = False
        db.commit()
        return {"message": "Product deactivated (has inventory history)"}
    else:
        # Hard delete if no inventory
        db.delete(db_product)
        db.commit()
        log_action(current_user.id, "delete_product", detail=f"product_id={product_id}")
        return {"message": "Product deleted"}


# Product Variants endpoints
@router.get("/{product_id}/variants", response_model=List[ProductVariantSchema])
def get_product_variants(
    product_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Obtener variantes de un producto"""
    
    variants = db.query(ProductVariant).options(
        joinedload(ProductVariant.unit),
        joinedload(ProductVariant.inventory)
    ).filter(ProductVariant.product_id == product_id).all()
    
    return variants


@router.post("/{product_id}/variants", response_model=ProductVariantSchema)
def create_product_variant(
    product_id: int,
    variant: ProductVariantCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Crear nueva variante de producto"""
    
    # Verify product exists
    product = db.query(Product).filter(Product.id == product_id).first()
    if not product:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product not found"
        )
    
    # Check SKU uniqueness if provided
    if variant.sku:
        existing = db.query(ProductVariant).filter(ProductVariant.sku == variant.sku).first()
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Variant SKU already exists"
            )
    
    # Check barcode uniqueness if provided
    if variant.barcode:
        existing = db.query(ProductVariant).filter(ProductVariant.barcode == variant.barcode).first()
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Variant barcode already exists"
            )
    
    variant_data = variant.dict()
    variant_data['product_id'] = product_id
    
    db_variant = ProductVariant(**variant_data)
    db.add(db_variant)
    db.commit()
    db.refresh(db_variant)
    
    return db_variant


@router.put("/variants/{variant_id}", response_model=ProductVariantSchema)
def update_product_variant(
    variant_id: int,
    variant_update: ProductVariantUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Actualizar variante de producto"""
    
    db_variant = db.query(ProductVariant).filter(ProductVariant.id == variant_id).first()
    if not db_variant:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product variant not found"
        )
    
    # Check SKU uniqueness if being updated
    if variant_update.sku and variant_update.sku != db_variant.sku:
        existing = db.query(ProductVariant).filter(
            and_(ProductVariant.sku == variant_update.sku, ProductVariant.id != variant_id)
        ).first()
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Variant SKU already exists"
            )
    
    # Check barcode uniqueness if being updated
    if variant_update.barcode and variant_update.barcode != db_variant.barcode:
        existing = db.query(ProductVariant).filter(
            and_(ProductVariant.barcode == variant_update.barcode, ProductVariant.id != variant_id)
        ).first()
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Variant barcode already exists"
            )
    
    # Update fields
    update_data = variant_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_variant, field, value)
    
    db.commit()
    db.refresh(db_variant)
    
    return db_variant


@router.delete("/variants/{variant_id}")
def delete_product_variant(
    variant_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Eliminar variante de producto"""
    
    db_variant = db.query(ProductVariant).filter(ProductVariant.id == variant_id).first()
    if not db_variant:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product variant not found"
        )
    
    # Check if variant has inventory
    inventory_count = db.query(Inventory).filter(
        Inventory.product_variant_id == variant_id
    ).count()
    
    if inventory_count > 0:
        # Soft delete - just mark as inactive
        db_variant.is_active = False
        db.commit()
        return {"message": "Product variant deactivated (has inventory history)"}
    else:
        # Hard delete if no inventory
        db.delete(db_variant)
        db.commit()
        return {"message": "Product variant deleted"}


@router.get("/{product_id}", response_model=ProductSchema)
def read_product(
    product_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    product = db.query(Product).filter(Product.id == product_id).first()
    if product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    return product


@router.get("/{product_id}/variants", response_model=List[ProductVariantSchema])
def read_product_variants(
    product_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    variants = db.query(ProductVariant).filter(
        ProductVariant.product_id == product_id,
        ProductVariant.is_active == True
    ).all()
    return variants


@router.post("/debug", response_model=dict)
def debug_product_creation(
    product: ProductCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Debug endpoint para ver qué datos llegan"""
    
    return {
        "received_data": product.dict(),
        "user_id": current_user.id,
        "message": "Data received successfully"
    }
