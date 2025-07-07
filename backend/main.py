"""
Punto de entrada principal para Maestro Inventario
Importa la aplicación desde main_production.py
"""

import logging

# Configure minimal logging
logging.basicConfig(
    level=logging.WARNING,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler()
    ]
)

from main_production import app

# Re-exportar la aplicación para que uvicorn pueda encontrarla
__all__ = ["app"]

if __name__ == "__main__":
    import uvicorn
    from app.core.config import settings
    
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=settings.DEBUG,
        log_level="debug"
    )
