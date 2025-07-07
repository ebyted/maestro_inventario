#!/usr/bin/env python3
"""
Debug server for Maestro Inventario API
Provides enhanced debugging capabilities, detailed logging, and system diagnostics
"""
import sys
import os
import time
import traceback
import platform
from datetime import datetime
from typing import Dict, Any

# Add the current directory to Python path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from fastapi import FastAPI, Request, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, FileResponse
from fastapi.staticfiles import StaticFiles
import uvicorn
import logging

# Custom middleware for request debugging
async def debug_middleware(request: Request, call_next):
    start_time = time.time()
    
    # Log request details
    logging.info(f"🔍 [{request.method}] {request.url}")
    logging.info(f"📋 Headers: {dict(request.headers)}")
    
    try:
        response = await call_next(request)
        process_time = time.time() - start_time
        
        logging.info(f"✅ Response: {response.status_code} ({process_time:.3f}s)")
        response.headers["X-Process-Time"] = str(process_time)
        
        return response
        
    except Exception as e:
        process_time = time.time() - start_time
        logging.error(f"❌ Error: {str(e)} ({process_time:.3f}s)")
        logging.error(f"🔥 Traceback: {traceback.format_exc()}")
        
        return JSONResponse(
            status_code=500,
            content={
                "error": "Internal Server Error",
                "message": str(e),
                "traceback": traceback.format_exc() if os.getenv("DEBUG", "false").lower() == "true" else None,
                "timestamp": datetime.now().isoformat()
            }
        )

# Create FastAPI app with debug configuration
app = FastAPI(
    title="Maestro Inventario API - DEBUG MODE",
    description="Debug server with enhanced logging and diagnostics",
    version="1.0.0-debug",
    debug=True
)

# Add debug middleware (we'll use the global exception handler instead)
# Custom middleware would require more complex setup without BaseHTTPMiddleware

# Enhanced CORS configuration for debugging
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["X-Process-Time"]
)

# Mount static files if directory exists
if os.path.exists("static"):
    app.mount("/static", StaticFiles(directory="static"), name="static")

# Global exception handler
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logging.error(f"🚨 Unhandled exception: {str(exc)}")
    logging.error(f"📍 Request: {request.method} {request.url}")
    logging.error(f"🔥 Traceback: {traceback.format_exc()}")
    
    return JSONResponse(
        status_code=500,
        content={
            "error": "Internal Server Error",
            "message": str(exc),
            "path": str(request.url),
            "method": request.method,
            "traceback": traceback.format_exc(),
            "timestamp": datetime.now().isoformat()
        }
    )

@app.get("/")
def read_root():
    """Página de bienvenida del servidor de debug"""
    logging.info("📄 Serving debug index page")
    if os.path.exists("static/index.html"):
        return FileResponse('static/index.html')
    return {
        "message": "Maestro Inventario API - DEBUG MODE", 
        "status": "running",
        "debug": True,
        "timestamp": datetime.now().isoformat()
    }

@app.get("/health")
def health_check():
    """Health check detallado"""
    logging.info("💓 Detailed health check requested")
    
    # Get basic system information without psutil
    import shutil
    
    try:
        disk_usage = shutil.disk_usage('.')
        disk_total = disk_usage.total
        disk_free = disk_usage.free
        disk_used = disk_total - disk_free
    except:
        disk_total = disk_free = disk_used = 0
    
    return {
        "status": "healthy",
        "version": "1.0.0-debug",
        "timestamp": datetime.now().isoformat(),
        "uptime": time.time(),
        "system": {
            "platform": platform.system(),
            "platform_release": platform.release(),
            "platform_version": platform.version(),
            "architecture": platform.machine(),
            "processor": platform.processor(),
            "disk": {
                "total": disk_total,
                "used": disk_used,
                "free": disk_free,
                "percent": (disk_used / disk_total * 100) if disk_total > 0 else 0
            }
        },
        "python": {
            "version": sys.version,
            "executable": sys.executable,
            "path": sys.path[:5]  # Show first 5 paths
        }
    }

@app.get("/debug/info")
def debug_info():
    """Información completa de debug"""
    logging.info("🔍 Debug info requested")
    
    return {
        "server": {
            "name": "Maestro Inventario Debug Server",
            "version": "1.0.0-debug",
            "python_version": sys.version,
            "fastapi_version": "latest",
            "current_time": datetime.now().isoformat(),
            "working_directory": os.getcwd()
        },
        "environment": {
            "env_vars": {k: v for k, v in os.environ.items() if not k.startswith('_')},
            "python_path": sys.path
        },
        "files": {
            "exists_requirements": os.path.exists("requirements.txt"),
            "exists_main": os.path.exists("main.py"),
            "exists_static": os.path.exists("static"),
            "exists_app": os.path.exists("app")
        }
    }

@app.get("/debug/logs")
def get_recent_logs():
    """Obtener logs recientes"""
    logging.info("📋 Recent logs requested")
    
    # This is a simple implementation - in production you'd read from log files
    return {
        "message": "Log endpoint - implement log file reading here",
        "timestamp": datetime.now().isoformat(),
        "note": "Check console output for real-time logs"
    }

@app.get("/debug/test-error")
def test_error():
    """Endpoint para probar manejo de errores"""
    logging.info("💥 Test error endpoint called")
    raise HTTPException(status_code=500, detail="This is a test error for debugging")

@app.get("/debug/test-exception")
def test_exception():
    """Endpoint para probar excepciones no manejadas"""
    logging.info("⚡ Test exception endpoint called")
    raise ValueError("This is a test exception for debugging the global handler")

@app.get("/api/v1/test")
def api_test():
    """API test con información adicional de debug"""
    logging.info("🧪 Enhanced API test requested")
    return {
        "message": "API is working!",
        "api_version": "v1",
        "debug_mode": True,
        "timestamp": datetime.now().isoformat(),
        "server_info": {
            "host": "localhost",
            "environment": "development"
        }
    }

# Mock authentication endpoints with enhanced debugging
@app.post("/api/v1/auth/login")
def login(request: Dict[str, Any] = None):
    """Login con logging detallado"""
    logging.info("🔐 Login attempt received")
    logging.info(f"📝 Request body: {request}")
    
    # Usuarios de prueba predefinidos
    test_users = {
        "admin@inventario.com": {
            "password": "admin123",
            "user": {
                "id": 1,
                "email": "admin@inventario.com",
                "name": "Administrador Principal",
                "first_name": "Admin",
                "last_name": "Principal",
                "roles": ["admin", "debug", "super_user"],
                "permissions": ["read", "write", "delete", "debug", "manage_users"]
            }
        },
        "usuario@inventario.com": {
            "password": "usuario123",
            "user": {
                "id": 2,
                "email": "usuario@inventario.com",
                "name": "Usuario Estándar",
                "first_name": "Usuario",
                "last_name": "Estándar",
                "roles": ["user"],
                "permissions": ["read", "write"]
            }
        },
        "demo@inventario.com": {
            "password": "demo123",
            "user": {
                "id": 3,
                "email": "demo@inventario.com",
                "name": "Usuario Demo",
                "first_name": "Demo",
                "last_name": "User",
                "roles": ["demo", "read_only"],
                "permissions": ["read"]
            }
        },
        "gerente@inventario.com": {
            "password": "gerente123",
            "user": {
                "id": 4,
                "email": "gerente@inventario.com",
                "name": "Gerente de Inventario",
                "first_name": "Gerente",
                "last_name": "Inventario",
                "roles": ["manager", "supervisor"],
                "permissions": ["read", "write", "manage_inventory", "reports"]
            }
        }
    }
    
    # Si no hay request body, devolver error
    if not request:
        logging.warning("🚫 No credentials provided")
        return {
            "error": "No credentials provided",
            "message": "Please provide email and password",
            "available_test_users": {
                "admin@inventario.com": "admin123",
                "usuario@inventario.com": "usuario123", 
                "demo@inventario.com": "demo123",
                "gerente@inventario.com": "gerente123"
            }
        }
    
    email = request.get("email", "").lower()
    password = request.get("password", "")
    
    # Verificar credenciales
    if email in test_users and test_users[email]["password"] == password:
        user_data = test_users[email]["user"]
        logging.info(f"✅ Login successful for {email}")
        
        return {
            "access_token": f"debug_token_{user_data['id']}_{int(time.time())}",
            "token_type": "bearer",
            "expires_in": 3600,
            "user": user_data,
            "debug": {
                "timestamp": datetime.now().isoformat(),
                "session_id": f"debug_session_{user_data['id']}",
                "login_source": "debug_server"
            }
        }
    else:
        logging.warning(f"❌ Invalid credentials for {email}")
        return {
            "error": "Invalid credentials",
            "message": "Email or password incorrect",
            "provided_email": email,
            "available_test_users": {
                "admin@inventario.com": "admin123",
                "usuario@inventario.com": "usuario123",
                "demo@inventario.com": "demo123", 
                "gerente@inventario.com": "gerente123"
            },
            "debug": {
                "timestamp": datetime.now().isoformat(),
                "login_attempt": True
            }
        }

@app.post("/api/v1/auth/register")
def register(request: Dict[str, Any] = None):
    """Registro con logging detallado"""
    logging.info("📝 Registration attempt received")
    logging.info(f"📋 Request body: {request}")
    
    return {
        "message": "User registered successfully",
        "user": {
            "id": 2,
            "email": "user@example.com",
            "name": "Debug User",
            "created_at": datetime.now().isoformat()
        },
        "debug": {
            "registration_source": "debug_server",
            "timestamp": datetime.now().isoformat()
        }
    }

@app.get("/api/v1/auth/me")
def get_current_user():
    """Usuario actual con información de debug"""
    logging.info("👤 Current user requested")
    
    return {
        "id": 1,
        "email": "admin@example.com",
        "name": "Debug Administrator",
        "roles": ["admin", "debug"],
        "last_login": datetime.now().isoformat(),
        "debug": {
            "session_active": True,
            "permissions": ["read", "write", "debug"],
            "timestamp": datetime.now().isoformat()
        }
    }

@app.get("/debug/test-users")
def get_test_users():
    """Obtener lista de usuarios de prueba disponibles"""
    logging.info("👥 Test users list requested")
    
    return {
        "message": "Usuarios de prueba disponibles",
        "test_users": [
            {
                "email": "admin@inventario.com",
                "password": "admin123",
                "role": "Administrador Principal",
                "description": "Usuario con todos los permisos",
                "permissions": ["read", "write", "delete", "debug", "manage_users"]
            },
            {
                "email": "usuario@inventario.com", 
                "password": "usuario123",
                "role": "Usuario Estándar",
                "description": "Usuario con permisos básicos",
                "permissions": ["read", "write"]
            },
            {
                "email": "demo@inventario.com",
                "password": "demo123", 
                "role": "Usuario Demo",
                "description": "Usuario solo lectura para demostraciones",
                "permissions": ["read"]
            },
            {
                "email": "gerente@inventario.com",
                "password": "gerente123",
                "role": "Gerente de Inventario", 
                "description": "Usuario con permisos de gestión",
                "permissions": ["read", "write", "manage_inventory", "reports"]
            }
        ],
        "usage": {
            "login_endpoint": "/api/v1/auth/login",
            "method": "POST",
            "body_example": {
                "email": "admin@inventario.com",
                "password": "admin123"
            }
        },
        "debug": {
            "timestamp": datetime.now().isoformat(),
            "total_users": 4
        }
    }

if __name__ == "__main__":
    port = 8020
    
    # Enhanced logging configuration for debugging
    logging.basicConfig(
        level=logging.DEBUG,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.StreamHandler(sys.stdout),
            logging.FileHandler('debug.log', encoding='utf-8') if os.access('.', os.W_OK) else logging.NullHandler()
        ]
    )
    
    # Check if port is provided as command line argument
    if len(sys.argv) > 1:
        try:
            port = int(sys.argv[1])
        except ValueError:
            print(f"❌ Invalid port number: {sys.argv[1]}. Using default port {port}.")
    
    print("🐛" + "="*50)
    print(f"🚀 Starting Maestro Inventario DEBUG SERVER on port {port}")
    print(f"🔍 Debug mode: ENABLED")
    print(f"📊 System monitoring: ENABLED")
    print(f"📋 Enhanced logging: ENABLED")
    print("🐛" + "="*50)
    print("📱 ENDPOINTS DISPONIBLES:")
    print(f"   � API Documentation: http://localhost:{port}/docs")
    print(f"   🌐 Health Check: http://localhost:{port}/health")
    print(f"   🔍 Debug Info: http://localhost:{port}/debug/info")
    print(f"   👥 Test Users: http://localhost:{port}/debug/test-users")
    print(f"   💥 Test Error: http://localhost:{port}/debug/test-error")
    print(f"   📋 Recent Logs: http://localhost:{port}/debug/logs")
    print(f"   🔗 Test Connection: http://localhost:{port}/static/test-connection.html")
    print("🐛" + "="*50)
    print("👤 USUARIOS DE PRUEBA DISPONIBLES:")
    print("   🔑 admin@inventario.com / admin123 (Administrador)")
    print("   👤 usuario@inventario.com / usuario123 (Usuario Estándar)")  
    print("   🎭 demo@inventario.com / demo123 (Solo Lectura)")
    print("   👨‍💼 gerente@inventario.com / gerente123 (Gerente)")
    print("🐛" + "="*50)
    
    # Set debug environment variable
    os.environ["DEBUG"] = "true"
    
    uvicorn.run(
        "debug_server:app", 
        host="localhost", 
        port=port, 
        reload=True,
        log_level="debug",
        access_log=True
    )
