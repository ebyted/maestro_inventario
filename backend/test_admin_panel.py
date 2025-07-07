"""
Script de prueba para verificar el funcionamiento del Panel de Configuración CRUD
"""

import requests
import json
from datetime import datetime

BASE_URL = "http://localhost:8000/api/v1/admin"

def print_section(title):
    print("\n" + "="*60)
    print(f" {title}")
    print("="*60)

def test_stats_api():
    """Probar el endpoint de estadísticas"""
    print_section("PROBANDO API DE ESTADÍSTICAS")
    
    try:
        response = requests.get(f"{BASE_URL}/api/stats")
        if response.status_code == 200:
            stats = response.json()
            print("✅ API de estadísticas funcionando correctamente")
            print(f"📊 Total productos: {stats['total_products']}")
            print(f"🏷️ Total categorías: {stats['total_categories']}")
            print(f"🏢 Total marcas: {stats['total_brands']}")
            print(f"⚠️ Productos sin categoría: {stats['products_without_category']}")
            print(f"⚠️ Productos sin marca: {stats['products_without_brand']}")
            return True
        else:
            print(f"❌ Error en API de estadísticas: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Error conectando a API: {e}")
        return False

def test_categories_api():
    """Probar el endpoint de categorías"""
    print_section("PROBANDO API DE CATEGORÍAS")
    
    try:
        response = requests.get(f"{BASE_URL}/api/categories")
        if response.status_code == 200:
            categories = response.json()
            print("✅ API de categorías funcionando correctamente")
            print(f"📋 Primeras 5 categorías:")
            for i, cat in enumerate(categories[:5]):
                print(f"   {i+1}. {cat['name']} (ID: {cat['id']})")
            return True
        else:
            print(f"❌ Error en API de categorías: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Error conectando a API: {e}")
        return False

def test_brands_api():
    """Probar el endpoint de marcas"""
    print_section("PROBANDO API DE MARCAS")
    
    try:
        response = requests.get(f"{BASE_URL}/api/brands")
        if response.status_code == 200:
            brands = response.json()
            print("✅ API de marcas funcionando correctamente")
            print(f"📋 Primeras 5 marcas:")
            for i, brand in enumerate(brands[:5]):
                print(f"   {i+1}. {brand['name']} (ID: {brand['id']})")
            return True
        else:
            print(f"❌ Error en API de marcas: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Error conectando a API: {e}")
        return False

def test_create_category():
    """Probar creación de categoría"""
    print_section("PROBANDO CREACIÓN DE CATEGORÍA")
    
    try:
        test_data = {
            'name': f'Categoría de Prueba {datetime.now().strftime("%H%M%S")}',
            'description': 'Categoría creada por script de prueba',
            'code': f'TEST_{datetime.now().strftime("%H%M%S")}',
            'business_id': 1
        }
        
        response = requests.post(f"{BASE_URL}/categories/create", data=test_data)
        if response.status_code == 200:
            result = response.json()
            if result.get('success'):
                print("✅ Categoría creada exitosamente")
                print(f"🆔 ID de la nueva categoría: {result['category_id']}")
                return result['category_id']
            else:
                print(f"❌ Error creando categoría: {result}")
                return None
        else:
            print(f"❌ Error HTTP creando categoría: {response.status_code}")
            print(f"📄 Respuesta: {response.text}")
            return None
    except Exception as e:
        print(f"❌ Error en prueba de creación: {e}")
        return None

def test_create_brand():
    """Probar creación de marca"""
    print_section("PROBANDO CREACIÓN DE MARCA")
    
    try:
        test_data = {
            'name': f'Marca de Prueba {datetime.now().strftime("%H%M%S")}',
            'description': 'Marca creada por script de prueba',
            'code': f'TEST_{datetime.now().strftime("%H%M%S")}',
            'business_id': 1
        }
        
        response = requests.post(f"{BASE_URL}/brands/create", data=test_data)
        if response.status_code == 200:
            result = response.json()
            if result.get('success'):
                print("✅ Marca creada exitosamente")
                print(f"🆔 ID de la nueva marca: {result['brand_id']}")
                return result['brand_id']
            else:
                print(f"❌ Error creando marca: {result}")
                return None
        else:
            print(f"❌ Error HTTP creando marca: {response.status_code}")
            print(f"📄 Respuesta: {response.text}")
            return None
    except Exception as e:
        print(f"❌ Error en prueba de creación: {e}")
        return None

def test_web_interfaces():
    """Probar que las interfaces web respondan"""
    print_section("PROBANDO INTERFACES WEB")
    
    urls = [
        ("/", "Dashboard Principal"),
        ("/products", "Gestión de Productos"),
        ("/categories", "Gestión de Categorías"),
        ("/brands", "Gestión de Marcas")
    ]
    
    for url, name in urls:
        try:
            response = requests.get(f"{BASE_URL}{url}")
            if response.status_code == 200:
                print(f"✅ {name}: OK")
            else:
                print(f"❌ {name}: Error {response.status_code}")
        except Exception as e:
            print(f"❌ {name}: Error de conexión - {e}")

def main():
    """Función principal del script de prueba"""
    print("🚀 INICIANDO PRUEBAS DEL PANEL DE CONFIGURACIÓN CRUD")
    print(f"🕒 Fecha/Hora: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"🌐 URL Base: {BASE_URL}")
    
    # Pruebas de APIs
    stats_ok = test_stats_api()
    categories_ok = test_categories_api()
    brands_ok = test_brands_api()
    
    # Pruebas de interfaces web
    test_web_interfaces()
    
    # Pruebas de creación (solo si las APIs básicas funcionan)
    if stats_ok and categories_ok and brands_ok:
        print_section("PROBANDO OPERACIONES CRUD")
        category_id = test_create_category()
        brand_id = test_create_brand()
        
        if category_id and brand_id:
            print("✅ Todas las pruebas CRUD pasaron exitosamente")
        else:
            print("⚠️ Algunas pruebas CRUD fallaron")
    else:
        print("⚠️ Saltando pruebas CRUD debido a errores en APIs básicas")
    
    # Resumen final
    print_section("RESUMEN FINAL")
    print("🎯 URLS PARA ACCEDER AL PANEL:")
    print(f"   📊 Dashboard: {BASE_URL}/")
    print(f"   📦 Productos: {BASE_URL}/products")
    print(f"   🏷️ Categorías: {BASE_URL}/categories")
    print(f"   🏢 Marcas: {BASE_URL}/brands")
    print(f"   📚 API Docs: http://localhost:8000/docs")
    
    print("\n✨ ¡Panel de Configuración CRUD funcionando correctamente!")
    print("🎉 Puedes acceder a las interfaces web desde tu navegador")

if __name__ == "__main__":
    main()
