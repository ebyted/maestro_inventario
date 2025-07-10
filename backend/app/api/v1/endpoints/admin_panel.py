from typing import List, Optional, Dict, Any
from fastapi import APIRouter, Depends, HTTPException, Request, Form, Query
from fastapi.responses import HTMLResponse, Response
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import func, desc, asc, and_, or_, text
from app.db.database import get_db
from app.models.models import (
    Product, Category, Brand, Business, User, Warehouse, Supplier, 
    PurchaseOrder, PurchaseOrderItem, InventoryMovement, Unit,
    PurchaseOrderStatus, MovementType, ProductVariant
)
from app.schemas.production import (
    CategoryResponse, CategoryCreate, CategoryUpdate,
    BrandResponse, BrandCreate, BrandUpdate
)
from app.schemas import Product as ProductSchema, ProductCreate, ProductUpdate
from app.api.v1.endpoints.auth import get_current_user
from app.api.v1.endpoints.session_auth import get_current_user_session
import os
import pandas as pd
from io import BytesIO
import json
from datetime import datetime, timedelta
from app.utils import get_user_role

router = APIRouter()

# Templates setup
# Get the backend directory path - go up from app/api/v1/endpoints/ to backend/
current_file = os.path.abspath(__file__)
endpoints_dir = os.path.dirname(current_file)  # endpoints/
v1_dir = os.path.dirname(endpoints_dir)        # v1/
api_dir = os.path.dirname(v1_dir)              # api/
app_dir = os.path.dirname(api_dir)             # app/
backend_dir = os.path.dirname(app_dir)         # backend/
templates_dir = os.path.join(backend_dir, "templates")
print(f"Templates directory: {templates_dir}")  # Debug
templates = Jinja2Templates(directory=templates_dir)

# Agregar filtros personalizados a Jinja2
def format_currency(value):
    """Formatear números como moneda"""
    try:
        return f"${value:,.2f}" if value else "$0.00"
    except:
        return "$0.00"

def format_date(value, format_str='%Y-%m-%d'):
    """Formatear fechas de forma segura"""
    try:
        if value:
            return value.strftime(format_str)
        return '-'
    except:
        return '-'

def format_datetime(value):
    """Formatear fecha y hora"""
    try:
        if value:
            return value.strftime('%Y-%m-%d %H:%M')
        return '-'
    except:
        return '-'

def format_number(value, decimals=1):
    """Formatear números con decimales"""
    try:
        if value is None:
            return "0"
        return f"{float(value):.{decimals}f}"
    except:
        return "0"

def format_percentage(value, decimals=1):
    """Formatear porcentajes"""
    try:
        if value is None:
            return "0"
        return f"{float(value):.{decimals}f}%"
    except:
        return "0%"

# Registrar filtros
templates.env.filters['currency'] = format_currency
templates.env.filters['date'] = format_date
templates.env.filters['datetime'] = format_datetime
templates.env.filters['number'] = format_number
templates.env.filters['percentage'] = format_percentage


@router.get("/", response_class=HTMLResponse)
@router.get("/dashboard", response_class=HTMLResponse)
async def admin_dashboard(
    request: Request,
    db: Session = Depends(get_db)
):
    """Panel principal de administración con estadísticas generales"""
    
    # Obtener estadísticas generales
    stats = {
        "total_products": db.query(Product).count(),
        "total_categories": db.query(Category).count(),
        "total_brands": db.query(Brand).count(),
        "products_without_category": db.query(Product).filter(Product.category_id == None).count(),
        "products_without_brand": db.query(Product).filter(Product.brand_id == None).count(),
        "active_products": db.query(Product).filter(Product.is_active == True).count(),
        "inactive_products": db.query(Product).filter(Product.is_active == False).count(),
    }
    
    # Top categorías por número de productos
    top_categories = db.query(
        Category.name,
        func.count(Product.id).label('product_count')
    ).outerjoin(Product).group_by(Category.id, Category.name).order_by(desc('product_count')).limit(5).all()
    
    # Top marcas por número de productos
    top_brands = db.query(
        Brand.name,
        func.count(Product.id).label('product_count')
    ).outerjoin(Product).group_by(Brand.id, Brand.name).order_by(desc('product_count')).limit(5).all()
    
    return templates.TemplateResponse("admin_dashboard.html", {
        "request": request,
        "stats": stats,
        "top_categories": top_categories,
        "top_brands": top_brands
    })


@router.get("/products", response_class=HTMLResponse)
async def admin_products(
    request: Request,
    page: int = 1,
    per_page: int = 20,
    search: Optional[str] = None,
    category_id: Optional[int] = None,
    brand_id: Optional[int] = None,
    has_category: Optional[bool] = None,
    has_brand: Optional[bool] = None,
    db: Session = Depends(get_db)
):
    """Panel de administración de productos"""
    
    # Construir query base
    query = db.query(Product).options(
        joinedload(Product.category),
        joinedload(Product.brand),
        joinedload(Product.base_unit)
    )
    
    # Aplicar filtros
    if search:
        search_term = f"%{search}%"
        query = query.filter(
            Product.name.ilike(search_term) | 
            Product.sku.ilike(search_term) |
            Product.barcode.ilike(search_term)
        )
    
    if category_id:
        query = query.filter(Product.category_id == category_id)
    
    if brand_id:
        query = query.filter(Product.brand_id == brand_id)
    
    if has_category is not None:
        if has_category:
            query = query.filter(Product.category_id != None)
        else:
            query = query.filter(Product.category_id == None)
    
    if has_brand is not None:
        if has_brand:
            query = query.filter(Product.brand_id != None)
        else:
            query = query.filter(Product.brand_id == None)
    
    # Paginación
    total = query.count()
    products = query.order_by(Product.name).offset((page - 1) * per_page).limit(per_page).all()
    
    # Obtener todas las categorías y marcas para los filtros
    categories = db.query(Category).order_by(Category.name).all()
    brands = db.query(Brand).order_by(Brand.name).all()
    
    # Obtener variantes de producto activas para el modal y para productos
    product_variants = db.query(ProductVariant).join(Product).filter(ProductVariant.is_active == True).order_by(Product.name, ProductVariant.name).all()
    units = db.query(Unit).order_by(Unit.name).all()
    # Buscar unidad 'pieza' como default
    default_unit = next((u for u in units if u.name.lower() == 'pieza'), None)
    # Calcular páginas
    total_pages = (total + per_page - 1) // per_page
    return templates.TemplateResponse("admin_products.html", {
        "request": request,
        "products": products,
        "categories": categories,
        "brands": brands,
        "current_page": page,
        "total_pages": total_pages,
        "total": total,
        "per_page": per_page,
        "search": search or "",
        "category_id": category_id,
        "brand_id": brand_id,
        "has_category": has_category,
        "has_brand": has_brand,
        "product_variants": product_variants,
        "units": units,
        "default_unit": default_unit
    })


@router.get("/categories", response_class=HTMLResponse)
async def admin_categories(
    request: Request,
    page: int = 1,
    per_page: int = 20,
    search: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Panel de administración de categorías"""
    
    query = db.query(Category)
    
    if search:
        search_term = f"%{search}%"
        query = query.filter(
            Category.name.ilike(search_term) | 
            Category.description.ilike(search_term)
        )
    
    # Agregar conteo de productos por categoría
    query = query.outerjoin(Product).group_by(Category.id).order_by(Category.name)
    
    total = query.count()
    categories_data = []
    
    categories = query.offset((page - 1) * per_page).limit(per_page).all()
    
    for category in categories:
        product_count = db.query(Product).filter(Product.category_id == category.id).count()
        categories_data.append({
            'category': category,
            'product_count': product_count
        })
    
    total_pages = (total + per_page - 1) // per_page
    
    return templates.TemplateResponse("admin_categories.html", {
        "request": request,
        "categories_data": categories_data,
        "current_page": page,
        "total_pages": total_pages,
        "total": total,
        "per_page": per_page,
        "search": search or ""
    })


@router.get("/brands", response_class=HTMLResponse)
async def admin_brands(
    request: Request,
    page: int = 1,
    per_page: int = 20,
    search: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Panel de administración de marcas"""
    
    query = db.query(Brand)
    
    if search:
        search_term = f"%{search}%"
        query = query.filter(
            Brand.name.ilike(search_term) | 
            Brand.description.ilike(search_term)
        )
    
    total = query.count()
    brands_data = []
    
    brands = query.order_by(Brand.name).offset((page - 1) * per_page).limit(per_page).all()
    
    for brand in brands:
        product_count = db.query(Product).filter(Product.brand_id == brand.id).count()
        brands_data.append({
            'brand': brand,
            'product_count': product_count
        })
    
    total_pages = (total + per_page - 1) // per_page
    
    return templates.TemplateResponse("admin_brands.html", {
        "request": request,
        "brands_data": brands_data,
        "current_page": page,
        "total_pages": total_pages,
        "total": total,
        "per_page": per_page,
        "search": search or ""
    })


# CRUD Operations for Categories
@router.post("/categories/create")
async def create_category(
    name: str = Form(...),
    description: str = Form(""),
    code: str = Form(""),
    business_id: int = Form(1),
    db: Session = Depends(get_db)
):
    """Crear nueva categoría"""
    
    # Verificar si ya existe
    existing = db.query(Category).filter(Category.name == name, Category.business_id == business_id).first()
    if existing:
        raise HTTPException(status_code=400, detail="La categoría ya existe")
    
    # Generar código si no se proporciona
    if not code:
        code = name.upper().replace(" ", "_")[:10]
    
    category = Category(
        name=name,
        description=description,
        code=code,
        business_id=business_id,
        is_active=True
    )
    
    db.add(category)
    db.commit()
    db.refresh(category)
    
    return {"success": True, "category_id": category.id}


@router.post("/categories/{category_id}/update")
async def update_category(
    category_id: int,
    name: str = Form(...),
    description: str = Form(""),
    code: str = Form(""),
    is_active: bool = Form(True),
    db: Session = Depends(get_db)
):
    """Actualizar categoría existente"""
    
    category = db.query(Category).filter(Category.id == category_id).first()
    if not category:
        raise HTTPException(status_code=404, detail="Categoría no encontrada")
    
    category.name = name
    category.description = description
    category.code = code
    category.is_active = is_active
    
    db.commit()
    
    return {"success": True}


@router.post("/categories/{category_id}/delete")
async def delete_category(
    category_id: int,
    db: Session = Depends(get_db)
):
    """Eliminar categoría (solo si no tiene productos)"""
    
    category = db.query(Category).filter(Category.id == category_id).first()
    if not category:
        raise HTTPException(status_code=404, detail="Categoría no encontrada")
    
    # Verificar si tiene productos asociados
    product_count = db.query(Product).filter(Product.category_id == category_id).count()
    if product_count > 0:
        raise HTTPException(status_code=400, detail=f"No se puede eliminar. La categoría tiene {product_count} productos asociados")
    
    db.delete(category)
    db.commit()
    
    return {"success": True}


# CRUD Operations for Brands
@router.post("/brands/create")
async def create_brand(
    name: str = Form(...),
    description: str = Form(""),
    code: str = Form(""),
    business_id: int = Form(1),
    db: Session = Depends(get_db)
):
    """Crear nueva marca"""
    
    # Verificar si ya existe
    existing = db.query(Brand).filter(Brand.name == name, Brand.business_id == business_id).first()
    if existing:
        raise HTTPException(status_code=400, detail="La marca ya existe")
    
    # Generar código si no se proporciona
    if not code:
        code = name.upper().replace(" ", "_")[:10]
    
    brand = Brand(
        name=name,
        description=description,
        code=code,
        business_id=business_id,
        is_active=True
    )
    
    db.add(brand)
    db.commit()
    db.refresh(brand)
    
    return {"success": True, "brand_id": brand.id}


@router.post("/brands/{brand_id}/update")
async def update_brand(
    brand_id: int,
    name: str = Form(...),
    description: str = Form(""),
    code: str = Form(""),
    is_active: bool = Form(True),
    db: Session = Depends(get_db)
):
    """Actualizar marca existente"""
    
    brand = db.query(Brand).filter(Brand.id == brand_id).first()
    if not brand:
        raise HTTPException(status_code=404, detail="Marca no encontrada")
    
    brand.name = name
    brand.description = description
    brand.code = code
    brand.is_active = is_active
    
    db.commit()
    
    return {"success": True}


@router.post("/brands/{brand_id}/delete")
async def delete_brand(
    brand_id: int,
    db: Session = Depends(get_db)
):
    """Eliminar marca (solo si no tiene productos)"""
    
    brand = db.query(Brand).filter(Brand.id == brand_id).first()
    if not brand:
        raise HTTPException(status_code=404, detail="Marca no encontrada")
    
    # Verificar si tiene productos asociados
    product_count = db.query(Product).filter(Product.brand_id == brand_id).count()
    if product_count > 0:
        raise HTTPException(status_code=400, detail=f"No se puede eliminar. La marca tiene {product_count} productos asociados")
    
    db.delete(brand)
    db.commit()
    
    return {"success": True}


# Product relationship updates
@router.post("/products/{product_id}/update-relationships")
async def update_product_relationships(
    product_id: int,
    category_id: Optional[int] = Form(None),
    brand_id: Optional[int] = Form(None),
    db: Session = Depends(get_db)
):
    """Actualizar relaciones de categoría y marca de un producto"""
    
    product = db.query(Product).filter(Product.id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Producto no encontrado")
    
    if category_id:
        category = db.query(Category).filter(Category.id == category_id).first()
        if not category:
            raise HTTPException(status_code=404, detail="Categoría no encontrada")
        product.category_id = category_id
    
    if brand_id:
        brand = db.query(Brand).filter(Brand.id == brand_id).first()
        if not brand:
            raise HTTPException(status_code=404, detail="Marca no encontrada")
        product.brand_id = brand_id
    
    db.commit()
    
    return {"success": True}


# API endpoints for getting data
@router.get("/api/stats")
async def get_stats(db: Session = Depends(get_db)):
    """Obtener estadísticas del sistema"""
    
    stats = {
        "total_products": db.query(Product).count(),
        "total_categories": db.query(Category).count(),
        "total_brands": db.query(Brand).count(),
        "products_without_category": db.query(Product).filter(Product.category_id == None).count(),
        "products_without_brand": db.query(Product).filter(Product.brand_id == None).count(),
        "active_products": db.query(Product).filter(Product.is_active == True).count(),
        "inactive_products": db.query(Product).filter(Product.is_active == False).count(),
    }
    
    return stats


@router.get("/api/categories")
async def get_categories_api(db: Session = Depends(get_db)):
    """Obtener todas las categorías para selects"""
    
    categories = db.query(Category).order_by(Category.name).all()
    return [{"id": cat.id, "name": cat.name} for cat in categories]


@router.get("/api/brands")
async def get_brands_api(db: Session = Depends(get_db)):
    """Obtener todas las marcas para selects"""
    
    brands = db.query(Brand).order_by(Brand.name).all()
    return [{"id": brand.id, "name": brand.name} for brand in brands]


# =============================================================================
# GESTIÓN DE PROVEEDORES
# =============================================================================

@router.get("/suppliers", response_class=HTMLResponse)
async def admin_suppliers(
    request: Request,
    page: int = 1,
    per_page: int = 20,
    search: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Panel de administración de proveedores"""
    
    # Construir query base
    query = db.query(Supplier)
    
    # Aplicar filtros
    if search:
        search_term = f"%{search}%"
        query = query.filter(
            or_(
                Supplier.name.ilike(search_term),
                Supplier.company_name.ilike(search_term),
                Supplier.email.ilike(search_term),
                Supplier.phone.ilike(search_term)
            )
        )
    
    # Paginación
    total = query.count()
    offset = (page - 1) * per_page
    suppliers = query.offset(offset).limit(per_page).all()
    
    # Calcular páginas
    total_pages = (total + per_page - 1) // per_page
    
    return templates.TemplateResponse("admin_suppliers.html", {
        "request": request,
        "suppliers": suppliers,
        "page": page,
        "per_page": per_page,
        "total": total,
        "total_pages": total_pages,
        "search": search or ""
    })

@router.post("/suppliers/create")
async def create_supplier_admin(
    request: Request,
    name: str = Form(...),
    company_name: str = Form(""),
    email: str = Form(""),
    phone: str = Form(""),
    address: str = Form(""),
    db: Session = Depends(get_db)
):
    """Crear nuevo proveedor"""
    
    supplier = Supplier(
        name=name,
        company_name=company_name,
        email=email,
        phone=phone,
        address=address
    )
    
    db.add(supplier)
    db.commit()
    db.refresh(supplier)
    
    return {"success": True, "message": "Proveedor creado exitosamente", "supplier": supplier}

@router.post("/suppliers/{supplier_id}/update")
async def update_supplier_admin(
    supplier_id: int,
    name: str = Form(...),
    company_name: str = Form(""),
    email: str = Form(""),
    phone: str = Form(""),
    address: str = Form(""),
    db: Session = Depends(get_db)
):
    """Actualizar proveedor"""
    
    supplier = db.query(Supplier).filter(Supplier.id == supplier_id).first()
    if not supplier:
        raise HTTPException(status_code=404, detail="Proveedor no encontrado")
    
    supplier.name = name
    supplier.company_name = company_name
    supplier.email = email
    supplier.phone = phone
    supplier.address = address
    
    db.commit()
    
    return {"success": True, "message": "Proveedor actualizado exitosamente"}

@router.post("/suppliers/{supplier_id}/delete")
async def delete_supplier_admin(
    supplier_id: int,
    db: Session = Depends(get_db)
):
    """Eliminar proveedor"""
    
    supplier = db.query(Supplier).filter(Supplier.id == supplier_id).first()
    if not supplier:
        raise HTTPException(status_code=404, detail="Proveedor no encontrado")
    
    db.delete(supplier)
    db.commit()
    
    return {"success": True, "message": "Proveedor eliminado exitosamente"}

@router.get("/suppliers/export")
async def export_suppliers_excel(
    search: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Exportar proveedores a Excel"""
    
    # Construir query
    query = db.query(Supplier)
    
    # Aplicar filtros
    if search:
        search_term = f"%{search}%"
        query = query.filter(
            or_(
                Supplier.name.ilike(search_term),
                Supplier.company_name.ilike(search_term),
                Supplier.email.ilike(search_term),
                Supplier.phone.ilike(search_term)
            )
        )
    
    suppliers = query.all()
    
    # Crear DataFrame
    data = []
    for supplier in suppliers:
        data.append({
            'ID': supplier.id,
            'Nombre': supplier.name,
            'Empresa': supplier.company_name,
            'Email': supplier.email,
            'Teléfono': supplier.phone,
            'Móvil': supplier.mobile,
            'Dirección': supplier.address,
            'Ciudad': supplier.city,
            'Fecha Creación': supplier.created_at.strftime('%Y-%m-%d') if supplier.created_at else ''
        })
    
    df = pd.DataFrame(data)
    
    # Crear archivo Excel
    output = BytesIO()
    with pd.ExcelWriter(output, engine='openpyxl') as writer:
        df.to_excel(writer, sheet_name='Proveedores', index=False)
    
    output.seek(0)
    
    # Crear respuesta
    filename = f"proveedores_{datetime.now().strftime('%Y%m%d_%H%M%S')}.xlsx"
    headers = {
        'Content-Disposition': f'attachment; filename="{filename}"'
    }
    
    return Response(
        content=output.getvalue(),
        media_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        headers=headers
    )

# =============================================================================
# GESTIÓN DE ALMACENES
# =============================================================================

@router.get("/warehouses", response_class=HTMLResponse)
async def admin_warehouses(
    request: Request,
    page: int = 1,
    per_page: int = 20,
    search: Optional[str] = None,
    business_id: Optional[int] = None,
    db: Session = Depends(get_db)
):
    """Panel de administración de almacenes"""
    
    # Construir query base
    query = db.query(Warehouse).options(joinedload(Warehouse.business))
    
    # Aplicar filtros
    if search:
        search_term = f"%{search}%"
        query = query.filter(
            or_(
                Warehouse.name.ilike(search_term),
                Warehouse.code.ilike(search_term),
                Warehouse.address.ilike(search_term)
            )
        )
    
    if business_id:
        query = query.filter(Warehouse.business_id == business_id)
    
    # Paginación
    total = query.count()
    offset = (page - 1) * per_page
    warehouses = query.offset(offset).limit(per_page).all()
    
    # Obtener negocios para filtro
    businesses = db.query(Business).order_by(Business.name).all()
    
    # Calcular páginas
    total_pages = (total + per_page - 1) // per_page
    
    return templates.TemplateResponse("admin_warehouses.html", {
        "request": request,
        "warehouses": warehouses,
        "businesses": businesses,
        "page": page,
        "per_page": per_page,
        "total": total,
        "total_pages": total_pages,
        "search": search or "",
        "business_id": business_id
    })

@router.get("/warehouses/export")
async def export_warehouses_excel(
    search: Optional[str] = None,
    business_id: Optional[int] = None,
    db: Session = Depends(get_db)
):
    """Exportar almacenes a Excel"""
    
    # Construir query sin joinedload para evitar problemas de schema
    query = db.query(Warehouse)
    
    # Aplicar filtros
    if search:
        search_term = f"%{search}%"
        query = query.filter(
            or_(
                Warehouse.name.ilike(search_term),
                Warehouse.address.ilike(search_term)
            )
        )
    
    if business_id:
        query = query.filter(Warehouse.business_id == business_id)
    
    warehouses = query.all()
    
    # Crear DataFrame
    data = []
    for warehouse in warehouses:
        # Obtener el negocio por separado usando query específico
        business_name = ""
        if warehouse.business_id:
            try:
                # Solo obtener el nombre del negocio para evitar problemas de schema
                business_query = db.execute(
                    text("SELECT name FROM businesses WHERE id = :id"),
                    {"id": warehouse.business_id}
                )
                business_result = business_query.fetchone()
                business_name = business_result[0] if business_result else ""
            except Exception:
                # Si hay un error con la query, usar string vacío
                business_name = ""
        
        data.append({
            'ID': warehouse.id,
            'Nombre': warehouse.name,
            'Dirección': warehouse.address,
            'Negocio': business_name,
            'Activo': 'Sí' if warehouse.is_active else 'No',
            'Fecha Creación': warehouse.created_at.strftime('%Y-%m-%d') if warehouse.created_at else ''
        })
    
    df = pd.DataFrame(data)
    
    # Crear archivo Excel
    output = BytesIO()
    with pd.ExcelWriter(output, engine='openpyxl') as writer:
        df.to_excel(writer, sheet_name='Almacenes', index=False)
    
    output.seek(0)
    
    # Crear respuesta
    filename = f"almacenes_{datetime.now().strftime('%Y%m%d_%H%M%S')}.xlsx"
    headers = {
        'Content-Disposition': f'attachment; filename="{filename}"'
    }
    
    return Response(
        content=output.getvalue(),
        media_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        headers=headers
    )

# =============================================================================
# ANÁLISIS DE ÓRDENES DE COMPRA
# =============================================================================

@router.get("/purchase-orders", response_class=HTMLResponse)
async def admin_purchase_orders(
    request: Request,
    page: int = 1,
    per_page: int = 20,
    search: Optional[str] = None,
    status: Optional[str] = None,
    supplier_id: Optional[int] = None,
    date_from: Optional[str] = None,
    date_to: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Panel de análisis de órdenes de compra con filtros avanzados"""
    
    # Construir query base
    query = db.query(PurchaseOrder).options(
        joinedload(PurchaseOrder.supplier),
        joinedload(PurchaseOrder.items)
    )
    
    # Aplicar filtros
    if search:
        search_term = f"%{search}%"
        query = query.filter(PurchaseOrder.order_number.ilike(search_term))
    
    if status:
        # Convert string status to enum value
        try:
            status_enum = PurchaseOrderStatus(status.lower())
            query = query.filter(PurchaseOrder.status == status_enum)
        except ValueError:
            # Invalid status, ignore filter
            pass
    
    if supplier_id:
        query = query.filter(PurchaseOrder.supplier_id == supplier_id)
    
    if date_from:
        query = query.filter(PurchaseOrder.order_date >= datetime.strptime(date_from, "%Y-%m-%d"))
    
    if date_to:
        query = query.filter(PurchaseOrder.order_date <= datetime.strptime(date_to, "%Y-%m-%d"))
    
    # Ordenar por fecha más reciente
    query = query.order_by(desc(PurchaseOrder.order_date))
    
    # Paginación
    total = query.count()
    offset = (page - 1) * per_page
    orders = query.offset(offset).limit(per_page).all()
    
    # Obtener datos para filtros
    suppliers = db.query(Supplier).order_by(Supplier.name).all()
    statuses = [
        {"value": PurchaseOrderStatus.DRAFT.value, "label": "Borrador"},
        {"value": PurchaseOrderStatus.PENDING.value, "label": "Pendiente"},
        {"value": PurchaseOrderStatus.APPROVED.value, "label": "Aprobada"},
        {"value": PurchaseOrderStatus.ORDERED.value, "label": "Ordenada"},
        {"value": PurchaseOrderStatus.PARTIALLY_RECEIVED.value, "label": "Parcialmente Recibida"},
        {"value": PurchaseOrderStatus.RECEIVED.value, "label": "Recibida"},
        {"value": PurchaseOrderStatus.CANCELLED.value, "label": "Cancelada"}
    ]
    
    # Estadísticas
    stats = {
        "total_orders": db.query(PurchaseOrder).count(),
        "pending_orders": db.query(PurchaseOrder).filter(PurchaseOrder.status == PurchaseOrderStatus.PENDING).count(),
        "approved_orders": db.query(PurchaseOrder).filter(PurchaseOrder.status == PurchaseOrderStatus.APPROVED).count(),
        "total_amount": db.query(func.sum(PurchaseOrder.total_amount)).scalar() or 0,
        "avg_order_value": db.query(func.avg(PurchaseOrder.total_amount)).scalar() or 0
    }
    
    # Calcular páginas
    total_pages = (total + per_page - 1) // per_page
    
    return templates.TemplateResponse("admin_purchase_orders.html", {
        "request": request,
        "orders": orders,
        "suppliers": suppliers,
        "statuses": statuses,
        "stats": stats,
        "page": page,
        "per_page": per_page,
        "total": total,
        "total_pages": total_pages,
        "search": search or "",
        "status": status,
        "supplier_id": supplier_id,
        "date_from": date_from,
        "date_to": date_to
    })

@router.get("/purchase-orders/export")
async def export_purchase_orders(
    search: Optional[str] = None,
    status: Optional[str] = None,
    supplier_id: Optional[int] = None,
    date_from: Optional[str] = None,
    date_to: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Exportar órdenes de compra a Excel"""
    
    # Construir query base
    query = db.query(PurchaseOrder).options(
        joinedload(PurchaseOrder.supplier),
        joinedload(PurchaseOrder.items).joinedload(PurchaseOrderItem.product_variant)
    )
    
    # Aplicar filtros
    if search:
        search_term = f"%{search}%"
        query = query.filter(PurchaseOrder.order_number.ilike(search_term))
    
    if status:
        # Convert string status to enum value
        try:
            status_enum = PurchaseOrderStatus(status.lower())
            query = query.filter(PurchaseOrder.status == status_enum)
        except ValueError:
            # Invalid status, ignore filter
            pass
    
    if supplier_id:
        query = query.filter(PurchaseOrder.supplier_id == supplier_id)
    
    if date_from:
        query = query.filter(PurchaseOrder.order_date >= datetime.strptime(date_from, "%Y-%m-%d"))
    
    if date_to:
        query = query.filter(PurchaseOrder.order_date <= datetime.strptime(date_to, "%Y-%m-%d"))
    
    orders = query.order_by(desc(PurchaseOrder.order_date)).all()
    
    # Preparar datos para Excel
    data = []
    for order in orders:
        for item in order.items:
            data.append({
                "Número de Orden": order.order_number,
                "Fecha": order.order_date.strftime("%Y-%m-%d"),
                "Proveedor": order.supplier.name if order.supplier else "",
                "Estado": order.status,
                "Producto": item.product_variant.product.name if item.product_variant and item.product_variant.product else "",
                "SKU": item.product_variant.product.sku if item.product_variant and item.product_variant.product else "",
                "Cantidad": item.quantity_ordered,
                "Precio Unitario": item.unit_cost,
                "Total Item": item.total_cost,
                "Total Orden": order.total_amount,
                "Notas": order.notes or ""
            })
    
    # Crear Excel
    df = pd.DataFrame(data)
    output = BytesIO()
    with pd.ExcelWriter(output, engine='openpyxl') as writer:
        df.to_excel(writer, sheet_name='Órdenes de Compra', index=False)
    
    output.seek(0)
    
    return Response(
        content=output.getvalue(),
        media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={"Content-Disposition": f"attachment; filename=ordenes_compra_{datetime.now().strftime('%Y%m%d_%H%M%S')}.xlsx"}
    )

# =============================================================================
# ANÁLISIS DE MOVIMIENTOS DE INVENTARIO
# =============================================================================

@router.get("/inventory-movements", response_class=HTMLResponse)
async def admin_inventory_movements(
    request: Request,
    page: int = 1,
    per_page: int = 20,
    search: Optional[str] = None,
    movement_type: Optional[str] = None,
    product_id: Optional[int] = None,
    warehouse_id: Optional[int] = None,
    date_from: Optional[str] = None,
    date_to: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Panel de análisis de movimientos de inventario con filtros avanzados"""
    
    # Construir query base
    query = db.query(InventoryMovement).options(
        joinedload(InventoryMovement.product_variant),
        joinedload(InventoryMovement.warehouse),
        joinedload(InventoryMovement.user)
    )
    
    # Aplicar filtros
    if search:
        search_term = f"%{search}%"
        query = query.join(InventoryMovement.product_variant).join(Product).filter(
            or_(
                Product.name.ilike(search_term),
                Product.sku.ilike(search_term),
                InventoryMovement.reference_number.ilike(search_term)
            )
        )
    
    if movement_type:
        # Convert string movement_type to enum value
        try:
            movement_type_enum = MovementType(movement_type.lower())
            query = query.filter(InventoryMovement.movement_type == movement_type_enum)
        except ValueError:
            # Invalid movement type, ignore filter
            pass
    
    if product_id:
        # Buscar por product_variant_id que pertenezca al product_id
        query = query.join(InventoryMovement.product_variant).filter(ProductVariant.product_id == product_id)
    
    if warehouse_id:
        query = query.filter(InventoryMovement.warehouse_id == warehouse_id)
    
    if date_from:
        query = query.filter(InventoryMovement.created_at >= datetime.strptime(date_from, "%Y-%m-%d"))
    
    if date_to:
        query = query.filter(InventoryMovement.created_at <= datetime.strptime(date_to, "%Y-%m-%d"))
    
    # Ordenar por fecha más reciente
    query = query.order_by(desc(InventoryMovement.created_at))
    
    # Paginación
    total = query.count()
    offset = (page - 1) * per_page
    movements = query.offset(offset).limit(per_page).all()
    
    # Obtener datos para filtros
    products = db.query(Product).order_by(Product.name).limit(100).all()
    warehouses = db.query(Warehouse).order_by(Warehouse.name).all()
    movement_types = [
        {"value": MovementType.ENTRY.value, "label": "Entrada"},
        {"value": MovementType.EXIT.value, "label": "Salida"},
        {"value": MovementType.TRANSFER.value, "label": "Transferencia"},
        {"value": MovementType.ADJUSTMENT.value, "label": "Ajuste"}
    ]
    
    # Estadísticas
    stats = {
        "total_movements": db.query(InventoryMovement).count(),
        "movements_in": db.query(InventoryMovement).filter(InventoryMovement.movement_type == MovementType.ENTRY).count(),
        "movements_out": db.query(InventoryMovement).filter(InventoryMovement.movement_type == MovementType.EXIT).count(),
        "movements_today": db.query(InventoryMovement).filter(
            func.date(InventoryMovement.created_at) == datetime.now().date()
        ).count()
    }
    
    # Obtener variantes de producto activas para el modal
    product_variants = db.query(ProductVariant).join(Product).filter(ProductVariant.is_active == True).order_by(Product.name, ProductVariant.name).all()
    units = db.query(Unit).order_by(Unit.name).all()
    
    # Calcular páginas
    total_pages = (total + per_page - 1) // per_page
    
    return templates.TemplateResponse("admin_inventory_movements.html", {
        "request": request,
        "movements": movements,
        "products": products,
        "warehouses": warehouses,
        "movement_types": movement_types,
        "stats": stats,
        "page": page,
        "per_page": per_page,
        "total": total,
        "total_pages": total_pages,
        "search": search or "",
        "movement_type": movement_type,
        "product_id": product_id,
        "warehouse_id": warehouse_id,
        "date_from": date_from,
        "date_to": date_to,
        "product_variants": product_variants,
        "units": units
    })

@router.get("/inventory-movements/export")
async def export_inventory_movements(
    search: Optional[str] = None,
    movement_type: Optional[str] = None,
    product_id: Optional[int] = None,
    warehouse_id: Optional[int] = None,
    date_from: Optional[str] = None,
    date_to: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Exportar movimientos de inventario a Excel"""
    
    # Construir query base
    query = db.query(InventoryMovement).options(
        joinedload(InventoryMovement.product_variant).joinedload(ProductVariant.product),
        joinedload(InventoryMovement.warehouse),
        joinedload(InventoryMovement.user)
    )
    
    # Aplicar filtros (mismo código que arriba)
    if search:
        search_term = f"%{search}%"
        query = query.join(InventoryMovement.product_variant).join(Product).filter(
            or_(
                Product.name.ilike(search_term),
                Product.sku.ilike(search_term),
                InventoryMovement.reference_number.ilike(search_term)
            )
        )
    
    if movement_type:
        # Convert string movement_type to enum value
        try:
            movement_type_enum = MovementType(movement_type.lower())
            query = query.filter(InventoryMovement.movement_type == movement_type_enum)
        except ValueError:
            # Invalid movement type, ignore filter
            pass
    
    if product_id:
        # Buscar por product_variant_id que pertenezca al product_id
        query = query.join(InventoryMovement.product_variant).filter(ProductVariant.product_id == product_id)
    
    if warehouse_id:
        query = query.filter(InventoryMovement.warehouse_id == warehouse_id)
    
    if date_from:
        query = query.filter(InventoryMovement.created_at >= datetime.strptime(date_from, "%Y-%m-%d"))
    
    if date_to:
        query = query.filter(InventoryMovement.created_at <= datetime.strptime(date_to, "%Y-%m-%d"))
    
    movements = query.order_by(desc(InventoryMovement.created_at)).all()
    
    # Preparar datos para Excel
    data = []
    for movement in movements:
        product = movement.product_variant.product if movement.product_variant else None
        data.append({
            "Fecha": movement.created_at.strftime("%Y-%m-%d %H:%M:%S"),
            "Tipo": movement.movement_type,
            "Producto": product.name if product else "",
            "SKU": product.sku if product else "",
            "Variante": movement.product_variant.name if movement.product_variant else "",
            "Almacén": movement.warehouse.name if movement.warehouse else "",
            "Cantidad": movement.quantity,
            "Stock Anterior": movement.previous_quantity,
            "Stock Nuevo": movement.new_quantity,
            "Referencia": movement.reference_number or "",
            "Notas": movement.notes or "",
            "Usuario": f"{movement.user.first_name} {movement.user.last_name}" if movement.user else ""
        })
    
    # Crear Excel
    df = pd.DataFrame(data)
    output = BytesIO()
    with pd.ExcelWriter(output, engine='openpyxl') as writer:
        df.to_excel(writer, sheet_name='Movimientos Inventario', index=False)
    
    output.seek(0)
    
    return Response(
        content=output.getvalue(),
        media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={"Content-Disposition": f"attachment; filename=movimientos_inventario_{datetime.now().strftime('%Y%m%d_%H%M%S')}.xlsx"}
    )

# =============================================================================
# ANÁLISIS AVANZADO DE ARTÍCULOS/PRODUCTOS
# =============================================================================

@router.get("/articles", response_class=HTMLResponse)
async def admin_articles_analysis(
    request: Request,
    page: int = 1,
    per_page: int = 20,
    search: Optional[str] = None,
    category_id: Optional[int] = None,
    brand_id: Optional[int] = None,
    stock_status: Optional[str] = None,
    price_range: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Panel de análisis avanzado de artículos con métricas de negocio"""
    
    # Construir query base con métricas
    query = db.query(Product).options(
        joinedload(Product.category),
        joinedload(Product.brand),
        joinedload(Product.base_unit)
    )
    
    # Aplicar filtros
    if search:
        search_term = f"%{search}%"
        query = query.filter(
            or_(
                Product.name.ilike(search_term),
                Product.sku.ilike(search_term),
                Product.barcode.ilike(search_term)
            )
        )
    
    if category_id:
        query = query.filter(Product.category_id == category_id)
    
    if brand_id:
        query = query.filter(Product.brand_id == brand_id)
    
    # Filtro por estado de stock
    if stock_status == "low":
        query = query.filter(Product.current_stock <= Product.minimum_stock)
    elif stock_status == "out":
        query = query.filter(Product.current_stock <= 0)
    elif stock_status == "good":
        query = query.filter(Product.current_stock > Product.minimum_stock)
    
    # Filtro por rango de precios
    if price_range:
        if price_range == "low":
            query = query.filter(Product.sale_price <= 100)
        elif price_range == "medium":
            query = query.filter(and_(Product.sale_price > 100, Product.sale_price <= 1000))
        elif price_range == "high":
            query = query.filter(Product.sale_price > 1000)
    
    # Paginación
    total = query.count()
    offset = (page - 1) * per_page
    products = query.offset(offset).limit(per_page).all()
    
    # Obtener datos para filtros
    categories = db.query(Category).order_by(Category.name).all()
    brands = db.query(Brand).order_by(Brand.name).all()
    
    # Estadísticas avanzadas
    stats = {
        "total_products": db.query(Product).count(),
        "active_products": db.query(Product).filter(Product.is_active == True).count(),
        "inactive_products": db.query(Product).filter(Product.is_active == False).count(),
        "products_with_minimum_stock": db.query(Product).filter(Product.minimum_stock > 0).count(),
        "total_variants": db.query(ProductVariant).count(),
        "active_variants": db.query(ProductVariant).filter(ProductVariant.is_active == True).count(),
        "total_categories": db.query(Category).count(),
        "total_brands": db.query(Brand).count()
    }
    
    # Calcular páginas
    total_pages = (total + per_page - 1) // per_page
    
    return templates.TemplateResponse("admin_articles.html", {
        "request": request,
        "products": products,
        "categories": categories,
        "brands": brands,
        "stats": stats,
        "page": page,
        "per_page": per_page,
        "total": total,
        "total_pages": total_pages,
        "search": search or "",
        "category_id": category_id,
        "brand_id": brand_id,
        "stock_status": stock_status,
        "price_range": price_range
    })

@router.get("/articles/export")
async def export_articles(
    search: Optional[str] = None,
    category_id: Optional[int] = None,
    brand_id: Optional[int] = None,
    stock_status: Optional[str] = None,
    price_range: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Exportar análisis de artículos a Excel"""
    
    # Construir query (mismo código que arriba)
    query = db.query(Product).options(
        joinedload(Product.category),
        joinedload(Product.brand),
        joinedload(Product.base_unit)
    )
    
    # Aplicar filtros
    if search:
        search_term = f"%{search}%"
        query = query.filter(
            or_(
                Product.name.ilike(search_term),
                Product.sku.ilike(search_term),
                Product.barcode.ilike(search_term)
            )
        )
    
    if category_id:
        query = query.filter(Product.category_id == category_id)
    
    if brand_id:
        query = query.filter(Product.brand_id == brand_id)
    
    products = query.all()
    
    # Preparar datos para Excel
    data = []
    for product in products:
        data.append({
            "SKU": product.sku,
            "Nombre": product.name,
            "Descripción": product.description,
            "Categoría": product.category.name if product.category else "",
            "Marca": product.brand.name if product.brand else "",
            "Código de Barras": product.barcode,
            "Stock Mínimo": product.minimum_stock,
            "Stock Máximo": product.maximum_stock,
            "Unidad Base": product.base_unit.name if product.base_unit else "",
            "Activo": "Sí" if product.is_active else "No",
            "Fecha Creación": product.created_at.strftime('%Y-%m-%d') if product.created_at else ''
        })
    
    # Crear Excel con múltiples hojas
    output = BytesIO()
    with pd.ExcelWriter(output, engine='openpyxl') as writer:
        # Hoja principal con todos los productos
        df_products = pd.DataFrame(data)
        df_products.to_excel(writer, sheet_name='Productos', index=False)
        
        # Hoja de resumen por categorías (simplificado)
        if not df_products.empty:
            df_categories = df_products.groupby('Categoría').agg({
                'SKU': 'count'
            }).rename(columns={
                'SKU': 'Total Productos'
            }).reset_index()
            df_categories.to_excel(writer, sheet_name='Resumen por Categoría', index=False)
        
        # Hoja de productos activos vs inactivos (simplificado)
        if not df_products.empty:
            df_status = df_products.groupby('Activo').agg({
                'SKU': 'count'
            }).rename(columns={
                'SKU': 'Total Productos'
            }).reset_index()
            df_status.to_excel(writer, sheet_name='Estado Productos', index=False)
    
    output.seek(0)
    
    return Response(
        content=output.getvalue(),
        media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={"Content-Disposition": f"attachment; filename=analisis_articulos_{datetime.now().strftime('%Y%m%d_%H%M%S')}.xlsx"}
    )

# =============================================================================
# DASHBOARD EJECUTIVO
# =============================================================================

@router.get("/executive-dashboard", response_class=HTMLResponse)
async def executive_dashboard(
    request: Request,
    db: Session = Depends(get_db)
):
    """Dashboard ejecutivo con métricas avanzadas"""
    
    # Fecha actual y rangos
    today = datetime.now().date()
    week_ago = today - timedelta(days=7)
    month_ago = today - timedelta(days=30)
    
    # Métricas de inventario
    inventory_metrics = {
        "total_products": db.query(Product).count(),
        "active_products": db.query(Product).filter(Product.is_active == True).count(),
        "low_stock_count": 0,  # Simplificado por ahora, necesitaríamos calcular stock real
        "total_inventory_value": 0, # Simplificado por ahora 
        "avg_margin": 0  # Simplificado por ahora
    }
    
    # Métricas de compras
    purchase_metrics = {
        "total_orders": db.query(PurchaseOrder).count(),
        "pending_orders": db.query(PurchaseOrder).filter(PurchaseOrder.status == PurchaseOrderStatus.PENDING).count(),
        "orders_this_month": db.query(PurchaseOrder).filter(PurchaseOrder.order_date >= month_ago).count(),
        "total_purchase_amount": db.query(func.sum(PurchaseOrder.total_amount)).scalar() or 0
    }
    
    # Métricas de movimientos
    movement_metrics = {
        "movements_today": db.query(InventoryMovement).filter(func.date(InventoryMovement.created_at) == today).count(),
        "movements_week": db.query(InventoryMovement).filter(InventoryMovement.created_at >= week_ago).count(),
        "in_movements": db.query(InventoryMovement).filter(InventoryMovement.movement_type == MovementType.ENTRY).count(),
        "out_movements": db.query(InventoryMovement).filter(InventoryMovement.movement_type == MovementType.EXIT).count()
    }
    
    # Métricas de usuarios y roles
    from app.models.models import UserRole
    user_metrics = {
        "total_users": db.query(User).count(),
        "active_users": db.query(User).filter(User.is_active == True).count(),
        "inactive_users": db.query(User).filter(User.is_active == False).count(),
        "admin_users": db.query(User).filter(User.role == UserRole.ADMIN.value).count(),
        "manager_users": db.query(User).filter(User.role == UserRole.MANAGER.value).count(),
        "warehouse_users": db.query(User).filter(
            or_(User.role == UserRole.ALMACENISTA.value, User.role == UserRole.CAPTURISTA.value)
        ).count(),
        "users_created_this_month": db.query(User).filter(User.created_at >= month_ago).count(),
        "most_active_users": db.query(
            User.first_name,
            User.last_name,
            func.count(InventoryMovement.id).label('movement_count')
        ).join(InventoryMovement, User.id == InventoryMovement.user_id, isouter=True).group_by(
            User.id, User.first_name, User.last_name
        ).order_by(desc('movement_count')).limit(5).all()
    }
    
    # Top productos por movimientos (simplificado - usando ProductVariant)
    try:
        # Simplificado para evitar joins complejos por ahora
        top_products = []
    except:
        top_products = []
    
    # Proveedores más activos (simplificado)
    try:
        top_suppliers = db.query(
            Supplier.name,
            func.count(PurchaseOrder.id).label('order_count'),
            func.sum(PurchaseOrder.total_amount).label('total_amount')
        ).join(PurchaseOrder, Supplier.id == PurchaseOrder.supplier_id).group_by(Supplier.id, Supplier.name).order_by(desc('order_count')).limit(5).all()
    except:
        top_suppliers = []
    
    return templates.TemplateResponse("admin_executive_dashboard.html", {
        "request": request,
        "inventory_metrics": inventory_metrics,
        "purchase_metrics": purchase_metrics,
        "movement_metrics": movement_metrics,
        "user_metrics": user_metrics,
        "top_products": top_products,
        "top_suppliers": top_suppliers,
        "today": today,
        "week_ago": week_ago,
        "month_ago": month_ago
    })


# =============================================================================
# GESTIÓN DE USUARIOS Y ROLES
# =============================================================================

@router.get("/users", response_class=HTMLResponse)
async def admin_users(
    request: Request,
    page: int = 1,
    per_page: int = 20,
    search: Optional[str] = None,
    role: Optional[str] = None,
    is_active: Optional[bool] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user_session)
):
    """Panel de administración de usuarios"""
    from app.models.models import UserRole
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(status_code=403, detail="Solo los administradores pueden gestionar usuarios")
    query = db.query(User)
    if search:
        search_term = f"%{search}%"
        query = query.filter(
            or_(
                User.first_name.ilike(search_term),
                User.last_name.ilike(search_term),
                User.email.ilike(search_term)
            )
        )
    if role:
        try:
            role_enum = get_user_role(role)
            query = query.filter(User.role == role_enum)
        except ValueError:
            pass
    if is_active is not None:
        query = query.filter(User.is_active == is_active)
    total = query.count()
    offset = (page - 1) * per_page
    users = query.order_by(User.created_at.desc()).offset(offset).limit(per_page).all()
    roles = [
        {"value": UserRole.ADMIN.value, "label": "Administrador"},
        {"value": UserRole.MANAGER.value, "label": "Gerente"},
        {"value": UserRole.EMPLOYEE.value, "label": "Empleado"},
        {"value": UserRole.VIEWER.value, "label": "Visualizador"},
        {"value": UserRole.ALMACENISTA.value, "label": "Almacenista"},
        {"value": UserRole.CAPTURISTA.value, "label": "Capturista"}
    ]
    stats = {
        "total_users": db.query(User).count(),
        "active_users": db.query(User).filter(User.is_active == True).count(),
        "inactive_users": db.query(User).filter(User.is_active == False).count(),
        "admin_users": db.query(User).filter(User.role == UserRole.ADMIN.value).count(),
        "warehouse_users": db.query(User).filter(
            or_(User.role == UserRole.ALMACENISTA.value, User.role == UserRole.CAPTURISTA.value)
        ).count()
    }
    total_pages = (total + per_page - 1) // per_page
    return templates.TemplateResponse("admin_users.html", {
        "request": request,
        "users": users,
        "roles": roles,
        "stats": stats,
        "page": page,
        "per_page": per_page,
        "total": total,
        "total_pages": total_pages,
        "search": search or "",
        "role": role,
        "is_active": is_active
    })

@router.post("/users/create")
async def create_user_admin(
    first_name: str = Form(...),
    last_name: str = Form(...),
    email: str = Form(...),
    password: str = Form(...),
    role: str = Form(...),
    is_active: bool = Form(True),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user_session)
):
    """Crear nuevo usuario"""
    
    # Verificar que el usuario sea admin
    from app.models.models import UserRole
    from app.core.security import get_password_hash
    
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(status_code=403, detail="Solo los administradores pueden crear usuarios")
    
    # Verificar si el email ya existe
    existing_user = db.query(User).filter(User.email == email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="El email ya está registrado")
    
    # Validar rol
    try:
        user_role = get_user_role(role)
    except ValueError:
        raise HTTPException(status_code=400, detail="Rol inválido")
    
    # Crear usuario
    user = User(
        first_name=first_name,
        last_name=last_name,
        email=email,
        password_hash=get_password_hash(password),
        hashed_password=get_password_hash(password),
        role=user_role,
        is_active=is_active
    )
    
    db.add(user)
    db.commit()
    db.refresh(user)
    
    return {"success": True, "message": "Usuario creado exitosamente", "user_id": user.id}

@router.post("/users/{user_id}/update")
async def update_user_admin(
    user_id: int,
    first_name: str = Form(...),
    last_name: str = Form(...),
    email: str = Form(...),
    role: str = Form(...),
    is_active: bool = Form(True),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user_session)
):
    """Actualizar usuario existente"""
    
    # Verificar que el usuario sea admin
    from app.models.models import UserRole
    
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(status_code=403, detail="Solo los administradores pueden modificar usuarios")
    
    # Obtener usuario
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    
    # No permitir que el admin se desactive a sí mismo
    if user.id == current_user.id and not is_active:
        raise HTTPException(status_code=400, detail="No puedes desactivar tu propia cuenta")
    
    # Verificar email único (si ha cambiado)
    if email != user.email:
        existing_user = db.query(User).filter(User.email == email, User.id != user_id).first()
        if existing_user:
            raise HTTPException(status_code=400, detail="El email ya está en uso por otro usuario")
    
    # Validar rol
    try:
        user_role = get_user_role(role)
    except ValueError:
        raise HTTPException(status_code=400, detail="Rol inválido")
    
    # Actualizar usuario
    user.first_name = first_name
    user.last_name = last_name
    user.email = email
    user.role = user_role
    user.is_active = is_active
    
    db.commit()
    
    return {"success": True, "message": "Usuario actualizado exitosamente"}

@router.post("/users/{user_id}/change-password")
async def change_user_password_admin(
    user_id: int,
    new_password: str = Form(...),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user_session)
):
    """Cambiar contraseña de usuario (solo admin)"""
    
    # Verificar que el usuario sea admin
    from app.models.models import UserRole
    from app.core.security import get_password_hash
    
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(status_code=403, detail="Solo los administradores pueden cambiar contraseñas")
    
    # Obtener usuario
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    
    # Validar contraseña
    if len(new_password) < 6:
        raise HTTPException(status_code=400, detail="La contraseña debe tener al menos 6 caracteres")
    
    # Actualizar contraseña
    user.password_hash = get_password_hash(new_password)
    user.hashed_password    = get_password_hash(new_password)
    db.commit()
    
    return {"success": True, "message": "Contraseña actualizada exitosamente"}

@router.post("/users/{user_id}/toggle-status")
async def toggle_user_status(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user_session)
):
    """Activar/desactivar usuario"""
    
    # Verificar que el usuario sea admin
    from app.models.models import UserRole
    
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(status_code=403, detail="Solo los administradores pueden cambiar el estado de usuarios")
    
    # Obtener usuario
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    
    # No permitir que el admin se desactive a sí mismo
    if user.id == current_user.id and user.is_active:
        raise HTTPException(status_code=400, detail="No puedes desactivar tu propia cuenta")
    
    # Cambiar estado
    user.is_active = not user.is_active
    db.commit()
    
    status = "activado" if user.is_active else "desactivado"
    return {"success": True, "message": f"Usuario {status} exitosamente", "is_active": user.is_active}

@router.post("/users/{user_id}/delete")
async def delete_user_admin(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user_session)
):
    """Eliminar usuario (solo si no tiene movimientos asociados)"""
    
    # Verificar que el usuario sea admin
    from app.models.models import UserRole
    
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(status_code=403, detail="Solo los administradores pueden eliminar usuarios")
    
    # Obtener usuario
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    
    # No permitir que el admin se elimine a sí mismo
    if user.id == current_user.id:
        raise HTTPException(status_code=400, detail="No puedes eliminar tu propia cuenta")
    
    # Verificar si tiene movimientos asociados
    movement_count = db.query(InventoryMovement).filter(InventoryMovement.user_id == user_id).count()
    if movement_count > 0:
        raise HTTPException(
            status_code=400, 
            detail=f"No se puede eliminar. El usuario tiene {movement_count} movimientos de inventario asociados"
        )
    
    # Verificar si tiene órdenes de compra asociadas
    purchase_order_count = db.query(PurchaseOrder).filter(PurchaseOrder.user_id == user_id).count()
    if purchase_order_count > 0:
        raise HTTPException(
            status_code=400,
            detail=f"No se puede eliminar. El usuario tiene {purchase_order_count} órdenes de compra asociadas"
        )
    
    db.delete(user)
    db.commit()
    
    return {"success": True, "message": "Usuario eliminado exitosamente"}

@router.get("/users/export")
async def export_users_excel(
    search: Optional[str] = None,
    role: Optional[str] = None,
    is_active: Optional[bool] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user_session)
):
    """Exportar usuarios a Excel"""
    from app.models.models import UserRole
    if current_user.role != UserRole.ADMIN:
        raise HTTPException(status_code=403, detail="Solo los administradores pueden exportar usuarios")
    query = db.query(User)
    if search:
        search_term = f"%{search}%"
        query = query.filter(
            or_(
                User.first_name.ilike(search_term),
                User.last_name.ilike(search_term),
                User.email.ilike(search_term)
            )
        )
    if role:
        try:
            role_enum = get_user_role(role)
            query = query.filter(User.role == role_enum)
        except ValueError:
            pass
    if is_active is not None:
        query = query.filter(User.is_active == is_active)
    users = query.all()
    data = []
    for user in users:
        data.append({
            'ID': user.id,
            'Nombre': user.first_name,
            'Apellido': user.last_name,
            'Email': user.email,
            'Teléfono': user.phone,
            'Rol': user.role.value if hasattr(user.role, 'value') else str(user.role),
            'Activo': 'Sí' if user.is_active else 'No',
            'Fecha Creación': user.created_at.strftime('%Y-%m-%d') if user.created_at else ''
        })
    df = pd.DataFrame(data)
    output = BytesIO()
    with pd.ExcelWriter(output, engine='openpyxl') as writer:
        df.to_excel(writer, sheet_name='Usuarios', index=False)
    output.seek(0)
    filename = f"usuarios_{datetime.now().strftime('%Y%m%d_%H%M%S')}.xlsx"
    headers = {
        'Content-Disposition': f'attachment; filename="{filename}"'
    }
    return Response(
        content=output.getvalue(),
        media_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        headers=headers
    )
