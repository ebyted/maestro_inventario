#!/usr/bin/env python3
"""
Script de prueba para endpoints de inventario multi-item
Prueba las operaciones de entrada, salida y ajuste con múltiples productos
"""

import requests
import json
from datetime import datetime, timedelta

# Configuración
BASE_URL = "http://127.0.0.1:8020/api/v1"
USERNAME = "admin@example.com"
PASSWORD = "admin123"

def get_auth_token():
    """Obtener token de autenticación"""
    response = requests.post(
        f"{BASE_URL}/auth/login",
        data={"username": USERNAME, "password": PASSWORD}
    )
    if response.status_code == 200:
        return response.json()["access_token"]
    else:
        print(f"Error obteniendo token: {response.status_code}")
        print(response.text)
        return None

def test_multi_entry():
    """Probar entrada multi-item"""
    token = get_auth_token()
    if not token:
        return
    
    headers = {"Authorization": f"Bearer {token}"}
    
    # Datos de entrada con múltiples productos
    entry_data = {
        "warehouse_id": 1,
        "supplier_id": 1,
        "reference_number": f"ENTRY-MULTI-{datetime.now().strftime('%Y%m%d-%H%M%S')}",
        "reason": "Compra de mercancía múltiple",
        "notes": "Entrada de prueba con múltiples productos",
        "items": [
            {
                "product_variant_id": 1,
                "unit_id": 1,
                "quantity": 50.0,
                "cost_per_unit": 15.50,
                "batch_number": "BATCH-001",
                "notes": "Producto A - Lote 001"
            },
            {
                "product_variant_id": 2,
                "unit_id": 1,
                "quantity": 30.0,
                "cost_per_unit": 25.75,
                "expiry_date": (datetime.now() + timedelta(days=365)).isoformat(),
                "batch_number": "BATCH-002",
                "notes": "Producto B - Lote 002"
            },
            {
                "product_variant_id": 3,
                "unit_id": 2,
                "quantity": 100.0,
                "cost_per_unit": 8.25,
                "notes": "Producto C - Sin lote"
            }
        ]
    }
    
    print("🔄 Probando entrada multi-item...")
    response = requests.post(
        f"{BASE_URL}/inventory/entries/multi",
        headers=headers,
        json=entry_data
    )
    
    if response.status_code == 200:
        result = response.json()
        print(f"✅ Entrada multi-item creada exitosamente!")
        print(f"   ID: {result['id']}")
        print(f"   Total items: {result['total_items']}")
        print(f"   Total valor: ${result['total_value']:.2f}" if result['total_value'] else "   Sin valor total")
        print(f"   Referencia: {result['reference_number']}")
        return result['id']
    else:
        print(f"❌ Error creando entrada multi-item: {response.status_code}")
        print(response.text)
        return None

def test_multi_exit():
    """Probar salida multi-item"""
    token = get_auth_token()
    if not token:
        return
    
    headers = {"Authorization": f"Bearer {token}"}
    
    # Datos de salida con múltiples productos
    exit_data = {
        "warehouse_id": 1,
        "customer_id": 1,
        "reference_number": f"EXIT-MULTI-{datetime.now().strftime('%Y%m%d-%H%M%S')}",
        "reason": "Venta múltiple",
        "notes": "Salida de prueba con múltiples productos",
        "items": [
            {
                "product_variant_id": 1,
                "unit_id": 1,
                "quantity": 10.0,
                "unit_price": 20.00,
                "notes": "Venta Producto A"
            },
            {
                "product_variant_id": 2,
                "unit_id": 1,
                "quantity": 5.0,
                "unit_price": 35.00,
                "notes": "Venta Producto B"
            },
            {
                "product_variant_id": 3,
                "unit_id": 2,
                "quantity": 25.0,
                "unit_price": 12.50,
                "notes": "Venta Producto C"
            }
        ]
    }
    
    print("\n🔄 Probando salida multi-item...")
    response = requests.post(
        f"{BASE_URL}/inventory/exits/multi",
        headers=headers,
        json=exit_data
    )
    
    if response.status_code == 200:
        result = response.json()
        print(f"✅ Salida multi-item creada exitosamente!")
        print(f"   ID: {result['id']}")
        print(f"   Total items: {result['total_items']}")
        print(f"   Total valor: ${result['total_value']:.2f}" if result['total_value'] else "   Sin valor total")
        print(f"   Referencia: {result['reference_number']}")
        return result['id']
    else:
        print(f"❌ Error creando salida multi-item: {response.status_code}")
        print(response.text)
        return None

def test_multi_adjustment():
    """Probar ajuste multi-item"""
    token = get_auth_token()
    if not token:
        return
    
    headers = {"Authorization": f"Bearer {token}"}
    
    # Datos de ajuste con múltiples productos
    adjustment_data = {
        "warehouse_id": 1,
        "reference_number": f"ADJ-MULTI-{datetime.now().strftime('%Y%m%d-%H%M%S')}",
        "reason": "Ajuste de inventario múltiple",
        "notes": "Ajuste de prueba con múltiples productos",
        "items": [
            {
                "product_variant_id": 1,
                "unit_id": 1,
                "quantity_adjustment": 5.0,
                "reason": "Encontrado en bodega",
                "notes": "Producto A - Incremento"
            },
            {
                "product_variant_id": 2,
                "unit_id": 1,
                "quantity_adjustment": -2.0,
                "reason": "Dañado",
                "notes": "Producto B - Decremento"
            },
            {
                "product_variant_id": 3,
                "unit_id": 2,
                "quantity_adjustment": 10.0,
                "reason": "Corrección de inventario",
                "cost_adjustment": 50.0,
                "notes": "Producto C - Ajuste positivo"
            }
        ]
    }
    
    print("\n🔄 Probando ajuste multi-item...")
    response = requests.post(
        f"{BASE_URL}/inventory/adjustments/multi",
        headers=headers,
        json=adjustment_data
    )
    
    if response.status_code == 200:
        result = response.json()
        print(f"✅ Ajuste multi-item creado exitosamente!")
        print(f"   ID: {result['id']}")
        print(f"   Total items: {result['total_items']}")
        print(f"   Estado: {result['status']}")
        print(f"   Referencia: {result['reference_number']}")
        return result['id']
    else:
        print(f"❌ Error creando ajuste multi-item: {response.status_code}")
        print(response.text)
        return None

def test_get_movement_details(movement_id):
    """Probar obtener detalles de movimiento"""
    token = get_auth_token()
    if not token:
        return
    
    headers = {"Authorization": f"Bearer {token}"}
    
    print(f"\n🔄 Obteniendo detalles del movimiento {movement_id}...")
    response = requests.get(
        f"{BASE_URL}/inventory/movements/multi/{movement_id}",
        headers=headers
    )
    
    if response.status_code == 200:
        result = response.json()
        print(f"✅ Detalles obtenidos exitosamente!")
        print(f"   Tipo: {result['movement_type']}")
        print(f"   Almacén: {result['warehouse_id']}")
        print(f"   Items: {len(result['items'])}")
        print(f"   Fecha: {result['created_at']}")
        for i, item in enumerate(result['items'], 1):
            print(f"   Item {i}: Producto {item['product_variant_id']}, Cantidad: {item['quantity']}")
    else:
        print(f"❌ Error obteniendo detalles: {response.status_code}")
        print(response.text)

def main():
    """Función principal para ejecutar todas las pruebas"""
    print("🚀 Iniciando pruebas de endpoints multi-item")
    print("=" * 50)
    
    # Probar entrada multi-item
    entry_id = test_multi_entry()
    
    # Probar salida multi-item
    exit_id = test_multi_exit()
    
    # Probar ajuste multi-item
    adjustment_id = test_multi_adjustment()
    
    # Probar obtener detalles de movimientos
    if entry_id:
        test_get_movement_details(entry_id)
    
    if exit_id:
        test_get_movement_details(exit_id)
    
    if adjustment_id:
        test_get_movement_details(adjustment_id)
    
    print("\n🎉 Pruebas completadas!")

if __name__ == "__main__":
    main()
