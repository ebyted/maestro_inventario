"""
Script de prueba para validar los endpoints de inventario con almacenes específicos
"""
import requests
import json
from datetime import datetime

# URL base del API
BASE_URL = "http://localhost:8000/api/v1"

def test_inventory_endpoints():
    """Prueba básica de los endpoints de inventario"""
    
    # Datos de prueba para entrada de inventario
    entry_data = {
        "warehouse_id": 1,
        "product_variant_id": 1,
        "unit_id": 1,
        "quantity": 100.0,
        "cost_per_unit": 15.50,
        "batch_number": "LOTE001",
        "reason": "Entrada inicial de inventario",
        "notes": "Primer ingreso de productos al almacén principal"
    }
    
    # Datos de prueba para salida de inventario
    exit_data = {
        "warehouse_id": 1,
        "product_variant_id": 1,
        "unit_id": 1,
        "quantity": 10.0,
        "reason": "Venta al cliente",
        "notes": "Salida por venta #001"
    }
    
    # Datos de prueba para ajuste de inventario
    adjustment_data = {
        "warehouse_id": 1,
        "product_variant_id": 1,
        "unit_id": 1,
        "current_quantity": 90.0,
        "actual_quantity": 85.0,
        "adjustment_type": "physical_count",
        "reason": "Conteo físico mensual",
        "notes": "Diferencia encontrada en conteo físico"
    }
    
    # Datos de prueba para transferencia entre almacenes
    transfer_data = {
        "source_warehouse_id": 1,
        "destination_warehouse_id": 2,
        "product_variant_id": 1,
        "unit_id": 1,
        "quantity": 20.0,
        "reason": "Transferencia de stock",
        "notes": "Movimiento de stock entre almacenes"
    }
    
    print("=== PRUEBAS DE ENDPOINTS DE INVENTARIO ===\n")
    
    # Headers simulados (en producción sería con token JWT)
    headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer fake-token-for-testing"
    }
    
    try:
        # Prueba 1: Obtener almacenes activos
        print("1. Probando obtener almacenes activos...")
        response = requests.get(f"{BASE_URL}/inventory/warehouses", headers=headers)
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            warehouses = response.json()
            print(f"   Almacenes encontrados: {len(warehouses)}")
        print()
        
        # Prueba 2: Obtener unidades de medida
        print("2. Probando obtener unidades de medida...")
        response = requests.get(f"{BASE_URL}/inventory/units", headers=headers)
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            units = response.json()
            print(f"   Unidades encontradas: {len(units)}")
        print()
        
        # Prueba 3: Entrada de inventario
        print("3. Probando entrada de inventario...")
        response = requests.post(
            f"{BASE_URL}/inventory/movements/entry", 
            headers=headers,
            json=entry_data
        )
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            movement = response.json()
            print(f"   Movimiento creado ID: {movement.get('id')}")
            print(f"   Cantidad anterior: {movement.get('previous_quantity')}")
            print(f"   Cantidad nueva: {movement.get('new_quantity')}")
        else:
            print(f"   Error: {response.text}")
        print()
        
        # Prueba 4: Salida de inventario
        print("4. Probando salida de inventario...")
        response = requests.post(
            f"{BASE_URL}/inventory/movements/exit", 
            headers=headers,
            json=exit_data
        )
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            movement = response.json()
            print(f"   Movimiento creado ID: {movement.get('id')}")
            print(f"   Cantidad anterior: {movement.get('previous_quantity')}")
            print(f"   Cantidad nueva: {movement.get('new_quantity')}")
        else:
            print(f"   Error: {response.text}")
        print()
        
        # Prueba 5: Ajuste de inventario
        print("5. Probando ajuste de inventario...")
        response = requests.post(
            f"{BASE_URL}/inventory/movements/adjustment", 
            headers=headers,
            json=adjustment_data
        )
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            movement = response.json()
            print(f"   Movimiento creado ID: {movement.get('id')}")
            print(f"   Cantidad anterior: {movement.get('previous_quantity')}")
            print(f"   Cantidad nueva: {movement.get('new_quantity')}")
        else:
            print(f"   Error: {response.text}")
        print()
        
        # Prueba 6: Transferencia entre almacenes
        print("6. Probando transferencia entre almacenes...")
        response = requests.post(
            f"{BASE_URL}/inventory/movements/transfer", 
            headers=headers,
            json=transfer_data
        )
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            movements = response.json()
            print(f"   Movimientos creados: {len(movements)}")
            for i, movement in enumerate(movements):
                print(f"   Movimiento {i+1} - Almacén: {movement.get('warehouse_id')}")
        else:
            print(f"   Error: {response.text}")
        print()
        
        # Prueba 7: Obtener productos con inventario
        print("7. Probando obtener productos con inventario...")
        response = requests.get(f"{BASE_URL}/inventory/products", headers=headers)
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            products = response.json()
            print(f"   Productos encontrados: {len(products)}")
        print()
        
    except requests.exceptions.ConnectionError:
        print("❌ Error: No se pudo conectar al servidor.")
        print("   Asegúrate de que el backend esté ejecutándose en http://localhost:8000")
    except Exception as e:
        print(f"❌ Error inesperado: {e}")
    
    print("=== PRUEBAS COMPLETADAS ===")

if __name__ == "__main__":
    test_inventory_endpoints()
