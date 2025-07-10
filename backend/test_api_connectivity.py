"""
Script de prueba para verificar login y productos
"""
import requests
import json

API_BASE = "http://127.0.0.1:8020/api/v1"

def test_login():
    """Probar login"""
    try:
        response = requests.post(f"{API_BASE}/auth/login", 
                               json={"email": "admin@maestro.com", "password": "admin123"})
        if response.status_code == 200:
            data = response.json()
            print("✅ Login exitoso!")
            return data.get("access_token")
        else:
            print(f"❌ Error en login: {response.status_code} - {response.text}")
            return None
    except Exception as e:
        print(f"❌ Error de conexión en login: {e}")
        return None

def test_products(token):
    """Probar obtener productos"""
    try:
        headers = {"Authorization": f"Bearer {token}"}
        response = requests.get(f"{API_BASE}/products?limit=5", headers=headers)
        
        if response.status_code == 200:
            products = response.json()
            print(f"✅ Productos obtenidos: {len(products)}")
            for i, product in enumerate(products[:3], 1):
                print(f"   {i}. {product.get('name', 'Sin nombre')} (SKU: {product.get('sku', 'N/A')})")
            return True
        else:
            print(f"❌ Error obteniendo productos: {response.status_code} - {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Error de conexión obteniendo productos: {e}")
        return False

def test_categories(token):
    """Probar obtener categorías"""
    try:
        headers = {"Authorization": f"Bearer {token}"}
        response = requests.get(f"{API_BASE}/categories", headers=headers)
        
        if response.status_code == 200:
            categories = response.json()
            print(f"✅ Categorías obtenidas: {len(categories)}")
            return True
        else:
            print(f"❌ Error obteniendo categorías: {response.status_code} - {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Error de conexión obteniendo categorías: {e}")
        return False

if __name__ == "__main__":
    print("🧪 PRUEBA DE CONECTIVIDAD API")
    print("=" * 40)
    
    # Probar login
    token = test_login()
    if not token:
        print("❌ No se pudo obtener token. Verificar que el backend esté ejecutándose.")
        exit(1)
    
    print(f"Token obtenido: {token[:20]}...")
    print()
    
    # Probar productos
    products_ok = test_products(token)
    
    # Probar categorías
    categories_ok = test_categories(token)
    
    print()
    print("RESUMEN:")
    print(f"Login: {'✅' if token else '❌'}")
    print(f"Productos: {'✅' if products_ok else '❌'}")
    print(f"Categorías: {'✅' if categories_ok else '❌'}")
    
    if token and products_ok:
        print()
        print("🎉 El API está funcionando correctamente!")
        print("El frontend debería poder cargar los productos.")
    else:
        print()
        print("⚠️ Hay problemas con el API que pueden afectar el frontend.")
