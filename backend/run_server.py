"""
Ejecutar servidor de pruebas de inventario
"""
import uvicorn
from simple_server import app

if __name__ == "__main__":
    print("🚀 Iniciando Maestro Inventario - Servidor de Pruebas")
    print("📦 Endpoints de inventario con almacenes específicos")
    print("🔗 http://localhost:8000")
    print("📚 Documentación: http://localhost:8000/docs")
    
    uvicorn.run(
        app, 
        host="127.0.0.1", 
        port=8000, 
        log_level="info"
    )
