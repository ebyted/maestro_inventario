#!/usr/bin/env python3
"""
Script de pruebas para endpoints multi-item (servidor simple sin autenticación)
"""
import requests
import json
from datetime import datetime, timedelta

# Configuración
BASE_URL = "http://127.0.0.1:8020"
API_BASE = f"{BASE_URL}/api/v1"

def print_separator(title: str):
    """Imprime un separador visual con título"""
    print(f"\n{'='*60}")
    print(f"🧪 {title}")
    print("="*60)

def print_success(message: str):
    """Imprime mensaje de éxito"""
    print(f"✅ {message}")

def print_error(message: str):
    """Imprime mensaje de error"""
    print(f"❌ {message}")

def make_request(method: str, endpoint: str, data: dict = None, use_api_base: bool = True):
    """Hace una petición HTTP y maneja errores"""
    if use_api_base:
        url = f"{API_BASE}{endpoint}"
    else:
        url = f"{BASE_URL}{endpoint}"
    
    headers = {"Content-Type": "application/json"}
    
    try:
        if method == "GET":
            response = requests.get(url, headers=headers)
        elif method == "POST":
            response = requests.post(url, headers=headers, json=data)
        else:
            raise ValueError(f"Método HTTP no soportado: {method}")
        
        print(f"📡 {method} {endpoint}")
        print(f"📊 Status: {response.status_code}")
        
        if response.status_code >= 400:
            print_error(f"Error HTTP {response.status_code}")
            try:
                error_detail = response.json()
                print(f"🔍 Detalle: {json.dumps(error_detail, indent=2, ensure_ascii=False)}")
            except:
                print(f"🔍 Respuesta: {response.text}")
            return None
        
        result = response.json()
        print_success("Respuesta recibida")
        return result
        
    except requests.exceptions.ConnectionError:
        print_error("No se pudo conectar al servidor. ¿Está corriendo en 127.0.0.1:8020?")
        return None
    except Exception as e:
        print_error(f"Error inesperado: {str(e)}")
        return None

def test_health_check():
    """Verifica que el servidor esté funcionando"""
    print_separator("Verificación de Salud del Servidor")
    
    result = make_request("GET", "/health", use_api_base=False)
    if result:
        print(f"📈 Estado: {result.get('status', 'desconocido')}")
        print(f"⏰ Timestamp: {result.get('timestamp', 'no disponible')}")
        return True
    return False

def test_get_warehouses():
    """Obtiene lista de almacenes"""
    print_separator("Obtener Almacenes")
    
    result = make_request("GET", "/inventory/warehouses")
    if result:
        print(f"🏢 Almacenes encontrados: {len(result)}")
        for warehouse in result:
            print(f"  - ID {warehouse.get('id')}: {warehouse.get('name')} ({warehouse.get('code')})")
        return result
    return []

def test_get_units():
    """Obtiene unidades de medida"""
    print_separator("Obtener Unidades de Medida")
    
    result = make_request("GET", "/inventory/units")
    if result:
        print(f"📏 Unidades encontradas: {len(result)}")
        for unit in result:
            print(f"  - ID {unit.get('id')}: {unit.get('name')} ({unit.get('symbol')})")
        return result
    return []

def test_get_products():
    """Obtiene productos"""
    print_separator("Obtener Productos")
    
    result = make_request("GET", "/inventory/products")
    if result:
        print(f"📦 Productos encontrados: {len(result)}")
        for product in result:
            print(f"  - ID {product.get('id')}: {product.get('name')} (SKU: {product.get('sku')})")
            for variant in product.get('variants', []):
                print(f"    → Variante ID {variant.get('id')}: {variant.get('attributes', {})}")
        return result
    return []

def test_multi_entry():
    """Prueba entrada multi-item"""
    print_separator("Entrada Multi-Item")
    
    # Datos de prueba para entrada
    entry_data = {
        "warehouse_id": 1,
        "supplier_id": 1,
        "reference_number": f"ENT-{datetime.now().strftime('%Y%m%d%H%M%S')}",
        "reason": "Entrada de mercancía - Prueba Multi-Item",
        "notes": "Entrada automatizada para pruebas",
        "items": [
            {
                "product_variant_id": 1,
                "unit_id": 1,
                "quantity": 25.0,
                "cost_per_unit": 45.50,
                "batch_number": "BATCH001",
                "notes": "Producto A - Color Rojo"
            },
            {
                "product_variant_id": 2,
                "unit_id": 1,
                "quantity": 30.0,
                "cost_per_unit": 42.75,
                "batch_number": "BATCH002",
                "notes": "Producto A - Color Azul"
            },
            {
                "product_variant_id": 3,
                "unit_id": 2,
                "quantity": 15.5,
                "cost_per_unit": 78.25,
                "expiry_date": (datetime.now() + timedelta(days=90)).isoformat(),
                "notes": "Producto B - Con fecha de vencimiento"
            }
        ]
    }
    
    print(f"📦 Enviando entrada con {len(entry_data['items'])} productos...")
    result = make_request("POST", "/inventory/entries/multi", entry_data)
    
    if result:
        print_success(f"Entrada creada: {result.get('message')}")
        print(f"🆔 Movement ID: {result.get('movement_id')}")
        print(f"📊 Total items: {result.get('total_items')}")
        print(f"💰 Valor total: ${result.get('total_value', 0):.2f}")
        
        movements = result.get('movements', [])
        print(f"📋 Movimientos generados: {len(movements)}")
        for movement in movements:
            print(f"  - Producto {movement.get('product_variant_id')}: {movement.get('quantity')} {movement.get('unit_symbol')}")
        
        return result.get('movement_id')
    return None

def test_multi_exit():
    """Prueba salida multi-item"""
    print_separator("Salida Multi-Item")
    
    # Datos de prueba para salida
    exit_data = {
        "warehouse_id": 1,
        "customer_id": 1,
        "reference_number": f"SAL-{datetime.now().strftime('%Y%m%d%H%M%S')}",
        "reason": "Venta a cliente - Prueba Multi-Item",
        "notes": "Salida automatizada para pruebas",
        "items": [
            {
                "product_variant_id": 1,
                "unit_id": 1,
                "quantity": 10.0,
                "unit_price": 75.00,
                "notes": "Producto A - Venta directa"
            },
            {
                "product_variant_id": 2,
                "unit_id": 1,
                "quantity": 8.0,
                "unit_price": 72.50,
                "notes": "Producto A - Descuento aplicado"
            }
        ]
    }
    
    print(f"📤 Enviando salida con {len(exit_data['items'])} productos...")
    result = make_request("POST", "/inventory/exits/multi", exit_data)
    
    if result:
        print_success(f"Salida creada: {result.get('message')}")
        print(f"🆔 Movement ID: {result.get('movement_id')}")
        print(f"📊 Total items: {result.get('total_items')}")
        print(f"💰 Valor total: ${result.get('total_value', 0):.2f}")
        
        movements = result.get('movements', [])
        print(f"📋 Movimientos generados: {len(movements)}")
        for movement in movements:
            print(f"  - Producto {movement.get('product_variant_id')}: {movement.get('quantity')} {movement.get('unit_symbol')}")
        
        return result.get('movement_id')
    return None

def test_multi_adjustment():
    """Prueba ajuste multi-item"""
    print_separator("Ajuste Multi-Item")
    
    # Datos de prueba para ajuste
    adjustment_data = {
        "warehouse_id": 1,
        "reference_number": f"ADJ-{datetime.now().strftime('%Y%m%d%H%M%S')}",
        "reason": "Ajuste por inventario físico",
        "notes": "Ajuste automatizado para pruebas",
        "items": [
            {
                "product_variant_id": 1,
                "unit_id": 1,
                "quantity_adjustment": 5.0,  # Agregar 5 unidades
                "reason": "Sobrante encontrado en conteo",
                "cost_adjustment": 45.50,
                "notes": "Producto encontrado en área de recepción"
            },
            {
                "product_variant_id": 2,
                "unit_id": 1,
                "quantity_adjustment": -3.0,  # Quitar 3 unidades
                "reason": "Producto dañado",
                "cost_adjustment": 42.75,
                "notes": "Productos con daños menores"
            },
            {
                "product_variant_id": 3,
                "unit_id": 2,
                "quantity_adjustment": 2.5,  # Agregar 2.5 kg
                "reason": "Error en registro anterior",
                "cost_adjustment": 78.25,
                "notes": "Corrección de peso exacto"
            }
        ]
    }
    
    print(f"⚖️ Enviando ajuste con {len(adjustment_data['items'])} productos...")
    result = make_request("POST", "/inventory/adjustments/multi", adjustment_data)
    
    if result:
        print_success(f"Ajuste creado: {result.get('message')}")
        print(f"🆔 Movement ID: {result.get('movement_id')}")
        print(f"📊 Total items: {result.get('total_items')}")
        print(f"💰 Valor total: ${result.get('total_value', 0):.2f}")
        
        movements = result.get('movements', [])
        print(f"📋 Movimientos generados: {len(movements)}")
        for movement in movements:
            adj = movement.get('quantity_adjustment', 0)
            sign = '+' if adj > 0 else ''
            print(f"  - Producto {movement.get('product_variant_id')}: {sign}{adj} {movement.get('unit_symbol')}")
        
        return result.get('movement_id')
    return None

def test_get_movement_details(movement_id: int):
    """Obtiene detalles de un movimiento multi-item"""
    print_separator(f"Detalles del Movimiento {movement_id}")
    
    result = make_request("GET", f"/inventory/movements/multi/{movement_id}")
    
    if result:
        print_success("Detalles obtenidos")
        print(f"🆔 ID: {result.get('id')}")
        print(f"🏢 Almacén: {result.get('warehouse_name')} (ID: {result.get('warehouse_id')})")
        print(f"📋 Tipo: {result.get('movement_type')}")
        print(f"📄 Referencia: {result.get('reference_number')}")
        print(f"📊 Total items: {result.get('total_items')}")
        print(f"💰 Valor total: ${result.get('total_value', 0):.2f}")
        print(f"📅 Creado: {result.get('created_at')}")
        
        items = result.get('items', [])
        print(f"\n📦 Items del movimiento ({len(items)}):")
        for item in items:
            product_name = item.get('product_name', f'Producto {item.get("product_variant_id")}')
            print(f"  - {product_name}")
            print(f"    Cantidad: {item.get('quantity')} {item.get('unit_symbol')}")
            if item.get('cost_per_unit'):
                print(f"    Costo unitario: ${item.get('cost_per_unit'):.2f}")
            if item.get('notes'):
                print(f"    Notas: {item.get('notes')}")
        
        return result
    return None

def main():
    """Función principal que ejecuta todas las pruebas"""
    print("🚀 Iniciando pruebas de endpoints multi-item")
    print("🎯 Servidor: 127.0.0.1:8020 (servidor simple sin autenticación)")
    print("="*60)
    
    # Verificar servidor
    if not test_health_check():
        print_error("No se puede continuar sin conexión al servidor")
        return
    
    # Obtener datos básicos
    warehouses = test_get_warehouses()
    units = test_get_units()
    products = test_get_products()
    
    if not warehouses or not units or not products:
        print_error("No se pudieron obtener los datos básicos necesarios")
        return
    
    # Ejecutar pruebas multi-item
    print("\n🧪 Comenzando pruebas de operaciones multi-item...\n")
    
    # Prueba 1: Entrada multi-item
    entry_movement_id = test_multi_entry()
    if entry_movement_id:
        test_get_movement_details(entry_movement_id)
    
    # Prueba 2: Salida multi-item
    exit_movement_id = test_multi_exit()
    if exit_movement_id:
        test_get_movement_details(exit_movement_id)
    
    # Prueba 3: Ajuste multi-item
    adjustment_movement_id = test_multi_adjustment()
    if adjustment_movement_id:
        test_get_movement_details(adjustment_movement_id)
    
    # Resumen final
    print_separator("Resumen de Pruebas")
    
    results = []
    if entry_movement_id:
        results.append("✅ Entrada multi-item: EXITOSA")
    else:
        results.append("❌ Entrada multi-item: FALLIDA")
        
    if exit_movement_id:
        results.append("✅ Salida multi-item: EXITOSA")
    else:
        results.append("❌ Salida multi-item: FALLIDA")
        
    if adjustment_movement_id:
        results.append("✅ Ajuste multi-item: EXITOSO")
    else:
        results.append("❌ Ajuste multi-item: FALLIDO")
    
    for result in results:
        print(result)
    
    successful_tests = sum(1 for r in results if "✅" in r)
    total_tests = len(results)
    
    print(f"\n📊 Resultados: {successful_tests}/{total_tests} pruebas exitosas")
    
    if successful_tests == total_tests:
        print_success("¡Todas las pruebas pasaron! Sistema multi-item funcionando correctamente")
    else:
        print_error(f"Algunas pruebas fallaron. Revisar logs arriba.")
    
    print("\n🎉 Pruebas completadas!")

if __name__ == "__main__":
    main()
