"""
Punto de entrada principal para Maestro Inventario
Importa la aplicación desde main_production.py
"""

from fastapi import FastAPI, Request
import logging
from logging_config import setup_logging

setup_logging()
logger = logging.getLogger(__name__)

app = FastAPI()

@app.on_event("startup")
async def startup_event():
    logger.info("🚀 Backend started and ready to accept requests.")

@app.middleware("http")
async def log_requests(request: Request, call_next):
    logger.info(f"Request: {request.method} {request.url}")
    response = await call_next(request)
    logger.info(f"Response status: {response.status_code}")
    return response

# Re-exportar la aplicación para que uvicorn pueda encontrarla
__all__ = ["app"]

if __name__ == "__main__":
    import uvicorn
    from app.core.config import settings

    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8020,
        reload=settings.DEBUG,
        log_level="info"
    )
