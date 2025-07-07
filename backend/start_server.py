#!/usr/bin/env python3
"""
Simple startup script for Maestro Inventario API
"""
import sys
import os

# Add the current directory to Python path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
import uvicorn

# Simple FastAPI app without complex dependencies
app = FastAPI(
    title="Maestro Inventario API",
    description="Comprehensive inventory management system",
    version="1.0.0"
)

# Simple CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins for development
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount static files if directory exists
if os.path.exists("static"):
    app.mount("/static", StaticFiles(directory="static"), name="static")

@app.get("/")
def read_root():
    """Página de bienvenida"""
    print("📄 Serving index.html")
    if os.path.exists("static/index.html"):
        return FileResponse('static/index.html')
    return {"message": "Maestro Inventario API", "status": "running"}

@app.get("/health")
def health_check():
    print("💓 Health check requested")
    return {"status": "healthy", "version": "1.0.0"}

@app.get("/api/v1/test")
def api_test():
    print("🧪 API test requested")
    return {"message": "API is working!", "api_version": "v1"}

# Mock authentication endpoints for frontend
@app.post("/api/v1/auth/login")
def login():
    print("🔐 Login attempt received")
    return {
        "access_token": "mock_token_123456789",
        "token_type": "bearer",
        "user": {
            "id": 1,
            "email": "admin@example.com",
            "name": "Administrator"
        }
    }

@app.post("/api/v1/auth/register")
def register():
    print("📝 Registration attempt received")
    return {
        "message": "User registered successfully",
        "user": {
            "id": 2,
            "email": "user@example.com",
            "name": "New User"
        }
    }

@app.get("/api/v1/auth/me")
def get_current_user():
    print("👤 Current user requested")
    return {
        "id": 1,
        "email": "admin@example.com",
        "name": "Administrator"
    }

if __name__ == "__main__":
    import logging
    
    port = 8020
    
    # Configure logging
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )
    
    # Check if port is provided as command line argument
    if len(sys.argv) > 1:
        try:
            port = int(sys.argv[1])
        except ValueError:
            print(f"Invalid port number: {sys.argv[1]}. Using default port 8020.")
    
    print(f"🚀 Starting Maestro Inventario API on port {port}")
    print(f"📱 API Documentation: http://localhost:{port}/docs")
    print(f"🌐 Health Check: http://localhost:{port}/health")
    print(f"🔗 Test Connection: http://localhost:{port}/static/test-connection.html")
    
    uvicorn.run(
        app, 
        host="localhost", 
        port=port, 
        reload=True,
        log_level="info",
        access_log=True
    )
