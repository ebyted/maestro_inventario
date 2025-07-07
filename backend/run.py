#!/usr/bin/env python3
"""
Script simple para ejecutar el servidor de desarrollo
"""
import uvicorn

if __name__ == "__main__":
    uvicorn.run(
        "main:app", 
        host="localhost", 
        port=8000, 
        reload=True,
        log_level="info"
    )
