from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from app.core.config import settings
import os

app = FastAPI(
    title="Maestro Inventario API",
    description="Comprehensive inventory management system",
    version="1.0.0",
    openapi_url=f"{settings.API_V1_STR}/openapi.json"
)

# Mount static files
app.mount("/static", StaticFiles(directory="static"), name="static")

# Set all CORS enabled origins
if settings.BACKEND_CORS_ORIGINS:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=[str(origin) for origin in settings.BACKEND_CORS_ORIGINS],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

@app.get("/")
def read_root():
    """Servir la página de bienvenida"""
    return FileResponse('static/index.html')

@app.get("/health")
def health_check():
    return {"status": "healthy", "version": "1.0.0"}

@app.get(f"{settings.API_V1_STR}/test")
def api_test():
    return {"message": "API is working!", "api_version": "v1"}

# Mock authentication endpoints for frontend integration
@app.post(f"{settings.API_V1_STR}/auth/login")
def login():
    return {
        "access_token": "mock_token_123456789",
        "token_type": "bearer",
        "user": {
            "id": 1,
            "email": "admin@example.com",
            "name": "Administrator"
        }
    }

@app.post(f"{settings.API_V1_STR}/auth/register")
def register():
    return {
        "message": "User registered successfully",
        "user": {
            "id": 2,
            "email": "user@example.com",
            "name": "New User"
        }
    }

@app.get(f"{settings.API_V1_STR}/auth/me")
def get_current_user():
    return {
        "id": 1,
        "email": "admin@example.com",
        "name": "Administrator"
    }

if __name__ == "__main__":
    import uvicorn
    import sys
    
    # Default port
    port = 8020
    
    # Check if port is provided as command line argument
    if len(sys.argv) > 1:
        try:
            port = int(sys.argv[1])
        except ValueError:
            print(f"Invalid port number: {sys.argv[1]}. Using default port 8020.")
    
    print(f"Starting server on port {port}")
    uvicorn.run(app, host="localhost", port=port)
