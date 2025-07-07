import requests
import json

# Test de login
url = "http://localhost:8000/api/v1/auth/login"
data = {
    "email": "admin@maestro.com",
    "password": "123456"
}

try:
    response = requests.post(url, json=data)
    print(f"Status Code: {response.status_code}")
    print(f"Response: {response.json()}")
    
    if response.status_code == 200:
        print("✅ Login exitoso!")
        print(f"🔑 Token: {response.json().get('access_token', 'No token')}")
    else:
        print("❌ Error en login")
        
except Exception as e:
    print(f"❌ Error de conexión: {e}")
