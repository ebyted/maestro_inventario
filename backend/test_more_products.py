"""
Probar el API con más productos
"""
import requests

API_BASE = "http://localhost:8000/api/v1"

def test_with_more_products():
    # Login
    response = requests.post(f"{API_BASE}/auth/login", 
                           json={"email": "admin@maestro.com", "password": "admin123"})
    if response.status_code != 200:
        print("❌ Error en login")
        return
    
    token = response.json().get("access_token")
    headers = {"Authorization": f"Bearer {token}"}
    
    # Probar con más productos
    for limit in [10, 50, 100]:
        response = requests.get(f"{API_BASE}/products?limit={limit}", headers=headers)
        if response.status_code == 200:
            products = response.json()
            print(f"✅ Con limit={limit}: {len(products)} productos obtenidos")
            if len(products) > 0:
                print(f"   Primer producto: {products[0].get('name', 'Sin nombre')}")
                print(f"   Último producto: {products[-1].get('name', 'Sin nombre')}")
        else:
            print(f"❌ Error con limit={limit}: {response.status_code}")
        print()

if __name__ == "__main__":
    test_with_more_products()
