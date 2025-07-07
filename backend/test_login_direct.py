import requests
import json

# Test login endpoint
url = "http://localhost:8000/api/v1/auth/login"
data = {
    "email": "admin@maestroinventario.com",
    "password": "admin123"
}

print("🔐 Probando login...")
print(f"📍 URL: {url}")
print(f"📧 Email: {data['email']}")

try:
    response = requests.post(url, json=data)
    print(f"📊 Status Code: {response.status_code}")
    print(f"📄 Response: {response.text}")
    
    if response.status_code == 200:
        print("✅ Login exitoso!")
        token_data = response.json()
        print(f"🎫 Token: {token_data.get('access_token', 'No token')}")
    else:
        print("❌ Login falló")
        
except Exception as e:
    print(f"❌ Error de conexión: {e}")
