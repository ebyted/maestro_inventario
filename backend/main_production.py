"""
Servidor principal de Maestro Inventario con base de datos PostgreSQL
"""
from fastapi import FastAPI, HTTPException, Depends, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer
from fastapi.responses import RedirectResponse
from sqlalchemy.orm import Session
from typing import List
import uvicorn

from app.core.config import settings
from app.db.database import SessionLocal, engine
from app.models import Base
from app.api.v1.api import api_router
from app.api.v1.endpoints.admin_panel import router as admin_router
from app.api.v1.endpoints import auth

# Crear tablas (solo para desarrollo, comentar en producción)
# Base.metadata.create_all(bind=engine)

app = FastAPI(
    title=settings.PROJECT_NAME,
    openapi_url=f"{settings.API_V1_STR}/openapi.json"
)

# Set all CORS enabled origins
if settings.BACKEND_CORS_ORIGINS:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=[str(origin) for origin in settings.BACKEND_CORS_ORIGINS],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

# Dependencia de base de datos
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Incluir rutas de API
app.include_router(api_router, prefix=settings.API_V1_STR)

# Incluir rutas de admin panel directamente en la raíz (sin prefijo /api/v1)
app.include_router(admin_router, prefix="/admin", tags=["admin-panel"])
# Only include the web_router (HTML login) at the root
app.include_router(auth.web_router, tags=["auth-web"])

@app.get("/", include_in_schema=False)
def root_redirect():
    return RedirectResponse(url="/login")

@app.get("/health")
def health_check(db: Session = Depends(get_db)):
    """Verificar estado de la aplicación y base de datos"""
    try:
        # Verificar conexión a base de datos
        db.execute("SELECT 1")
        return {
            "status": "healthy",
            "database": "connected",
            "version": "2.0.0"
        }
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=f"Database connection failed: {str(e)}"
        )

# Incluye los routers de autenticación
app.include_router(auth.api_router, prefix="/api/v1/auth", tags=["auth"])

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="localhost",
        port=8020,
        reload=settings.DEBUG
    )
