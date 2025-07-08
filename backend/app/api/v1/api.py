from fastapi import APIRouter
from app.api.v1.endpoints import auth, businesses, warehouses, products, inventory, suppliers, purchases, sales, users, units, categories, brands, admin_panel, inventory_movements

api_router = APIRouter()

api_router.include_router(auth.router, prefix="/auth", tags=["authentication"])
api_router.include_router(businesses.router, prefix="/businesses", tags=["businesses"])
api_router.include_router(warehouses.router, prefix="/warehouses", tags=["warehouses"])
api_router.include_router(units.router, prefix="/units", tags=["units"])
api_router.include_router(categories.router, prefix="/categories", tags=["categories"])
api_router.include_router(brands.router, prefix="/brands", tags=["brands"])
api_router.include_router(products.router, prefix="/products", tags=["products"])
api_router.include_router(inventory.router, prefix="/inventory", tags=["inventory"])
api_router.include_router(suppliers.router, prefix="/suppliers", tags=["suppliers"])
api_router.include_router(purchases.router, prefix="/purchases", tags=["purchases"])
api_router.include_router(sales.router, prefix="/sales", tags=["sales"])
api_router.include_router(users.router, prefix="/users", tags=["users"])
api_router.include_router(admin_panel.router, prefix="/admin", tags=["admin-panel"])
api_router.include_router(inventory_movements.router, prefix="/inventory-movements", tags=["inventory-movements"])
