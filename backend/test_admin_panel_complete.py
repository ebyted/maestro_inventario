#!/usr/bin/env python3
"""
Comprehensive test script for the Admin Panel functionality.
Tests all CRUD operations and export functionality.
"""

import requests
import json
import time
from typing import Dict, Any

BASE_URL = "http://localhost:8000"

def test_endpoint_accessibility():
    """Test that all admin panel pages are accessible"""
    endpoints = [
        "/admin/dashboard",
        "/admin/suppliers", 
        "/admin/warehouses",
        "/admin/articles",
        "/admin/purchase-orders",
        "/admin/inventory-movements",
        "/admin/executive-dashboard"
    ]
    
    print("Testing endpoint accessibility...")
    results = {}
    
    for endpoint in endpoints:
        try:
            response = requests.get(f"{BASE_URL}{endpoint}")
            results[endpoint] = {
                "status_code": response.status_code,
                "success": response.status_code == 200,
                "content_length": len(response.content)
            }
            print(f"✓ {endpoint}: {response.status_code} ({len(response.content)} bytes)")
        except requests.exceptions.RequestException as e:
            results[endpoint] = {
                "status_code": None,
                "success": False,
                "error": str(e)
            }
            print(f"✗ {endpoint}: {e}")
    
    return results

def test_export_functionality():
    """Test Excel export endpoints"""
    export_endpoints = [
        "/admin/suppliers/export",
        "/admin/warehouses/export", 
        "/admin/articles/export",
        "/admin/purchase-orders/export",
        "/admin/inventory-movements/export"
    ]
    
    print("\nTesting export functionality...")
    results = {}
    
    for endpoint in export_endpoints:
        try:
            response = requests.get(f"{BASE_URL}{endpoint}")
            content_type = response.headers.get('content-type', '')
            results[endpoint] = {
                "status_code": response.status_code,
                "success": response.status_code == 200,
                "content_type": content_type,
                "is_excel": "excel" in content_type or "spreadsheet" in content_type,
                "content_length": len(response.content)
            }
            print(f"✓ {endpoint}: {response.status_code} - {content_type} ({len(response.content)} bytes)")
        except requests.exceptions.RequestException as e:
            results[endpoint] = {
                "status_code": None,
                "success": False,
                "error": str(e)
            }
            print(f"✗ {endpoint}: {e}")
    
    return results

def test_api_endpoints():
    """Test core API endpoints"""
    api_endpoints = [
        "/docs",
        "/openapi.json",
        "/api/v1/products/",
        "/api/v1/inventory/movements",
        "/api/v1/suppliers/",
        "/api/v1/warehouses/"
    ]
    
    print("\nTesting API endpoints...")
    results = {}
    
    for endpoint in api_endpoints:
        try:
            response = requests.get(f"{BASE_URL}{endpoint}")
            results[endpoint] = {
                "status_code": response.status_code,
                "success": response.status_code == 200,
                "content_length": len(response.content)
            }
            print(f"✓ {endpoint}: {response.status_code} ({len(response.content)} bytes)")
        except requests.exceptions.RequestException as e:
            results[endpoint] = {
                "status_code": None,
                "success": False,
                "error": str(e)
            }
            print(f"✗ {endpoint}: {e}")
    
    return results

def test_filter_endpoints():
    """Test filtered data endpoints"""
    filter_endpoints = [
        "/admin/suppliers?search=test",
        "/admin/warehouses?search=principal", 
        "/admin/articles?search=producto",
        "/admin/purchase-orders?status=pending",
        "/admin/inventory-movements?movement_type=IN"
    ]
    
    print("\nTesting filter functionality...")
    results = {}
    
    for endpoint in filter_endpoints:
        try:
            response = requests.get(f"{BASE_URL}{endpoint}")
            results[endpoint] = {
                "status_code": response.status_code,
                "success": response.status_code == 200,
                "content_length": len(response.content)
            }
            print(f"✓ {endpoint}: {response.status_code} ({len(response.content)} bytes)")
        except requests.exceptions.RequestException as e:
            results[endpoint] = {
                "status_code": None,
                "success": False,
                "error": str(e)
            }
            print(f"✗ {endpoint}: {e}")
    
    return results

def test_api_health():
    """Test API health endpoint and DB status"""
    endpoint = "/api/v1/health"
    print("\nTesting API health endpoint...")
    try:
        response = requests.get(f"{BASE_URL}{endpoint}")
        data = response.json() if response.status_code == 200 else None
        print(f"✓ {endpoint}: {response.status_code}")
        return {
            "status_code": response.status_code,
            "success": response.status_code == 200 and data and data.get("status") == "ok",
            "db_status": data.get("db_status") if data else None,
            "version": data.get("version") if data else None,
            "details": data
        }
    except Exception as e:
        print(f"✗ {endpoint}: {e}")
        return {"status_code": None, "success": False, "error": str(e)}

def test_product_crud():
    """Test create, update, and delete product (CRUD)"""
    print("\nTesting product CRUD endpoints...")
    headers = {"Content-Type": "application/json"}
    # 1. Create
    product_data = {
        "name": "Test Product API",
        "description": "Producto de prueba creado por test automático",
        "sku": f"TESTSKU{int(time.time())}",
        "barcode": f"TESTBAR{int(time.time())}",
        "is_active": True,
        "category_id": None,
        "brand_id": None,
        "base_unit_id": 1,  # Ajusta si tu unidad base tiene otro ID
        "business_id": 1     # Ajusta si tu negocio principal tiene otro ID
    }
    create_resp = requests.post(f"{BASE_URL}/api/v1/products/", data=json.dumps(product_data), headers=headers)
    try:
        create_json = create_resp.json()
    except Exception:
        create_json = None
    print(f"Create: {create_resp.status_code}")
    # 2. Update
    product_id = create_json.get("id") if create_json else None
    update_data = {"name": "Test Product API Updated"}
    update_resp = requests.put(f"{BASE_URL}/api/v1/products/{product_id}", data=json.dumps(update_data), headers=headers) if product_id else None
    print(f"Update: {update_resp.status_code if update_resp else 'N/A'}")
    # 3. Delete
    delete_resp = requests.delete(f"{BASE_URL}/api/v1/products/{product_id}") if product_id else None
    print(f"Delete: {delete_resp.status_code if delete_resp else 'N/A'}")
    return {
        "create": {"status_code": create_resp.status_code, "success": create_resp.status_code == 200, "id": product_id},
        "update": {"status_code": update_resp.status_code if update_resp else None, "success": update_resp and update_resp.status_code == 200},
        "delete": {"status_code": delete_resp.status_code if delete_resp else None, "success": delete_resp and delete_resp.status_code == 200}
    }

def test_warehouse_crud():
    """Test create, update, and delete warehouse (CRUD)"""
    print("\nTesting warehouse CRUD endpoints...")
    headers = {"Content-Type": "application/json"}
    # 1. Create
    warehouse_data = {
        "name": f"Test Warehouse {int(time.time())}",
        "location": "Ubicación de prueba",
        "is_active": True,
        "business_id": 1  # Ajusta si tu negocio principal tiene otro ID
    }
    create_resp = requests.post(f"{BASE_URL}/api/v1/warehouses/", data=json.dumps(warehouse_data), headers=headers)
    try:
        create_json = create_resp.json()
    except Exception:
        create_json = None
    print(f"Create: {create_resp.status_code}")
    # 2. Update
    warehouse_id = create_json.get("id") if create_json else None
    update_data = {"name": "Test Warehouse Updated"}
    update_resp = requests.put(f"{BASE_URL}/api/v1/warehouses/{warehouse_id}", data=json.dumps(update_data), headers=headers) if warehouse_id else None
    print(f"Update: {update_resp.status_code if update_resp else 'N/A'}")
    # 3. Delete
    delete_resp = requests.delete(f"{BASE_URL}/api/v1/warehouses/{warehouse_id}") if warehouse_id else None
    print(f"Delete: {delete_resp.status_code if delete_resp else 'N/A'}")
    return {
        "create": {"status_code": create_resp.status_code, "success": create_resp.status_code == 200, "id": warehouse_id},
        "update": {"status_code": update_resp.status_code if update_resp else None, "success": update_resp and update_resp.status_code == 200},
        "delete": {"status_code": delete_resp.status_code if delete_resp else None, "success": delete_resp and delete_resp.status_code == 200}
    }

def test_supplier_crud():
    """Test create, update, and delete supplier (CRUD)"""
    print("\nTesting supplier CRUD endpoints...")
    headers = {"Content-Type": "application/json"}
    # 1. Create
    supplier_data = {
        "name": f"Test Supplier {int(time.time())}",
        "contact_name": "Contacto Prueba",
        "contact_email": "prueba@example.com",
        "contact_phone": "555-1234",
        "address": "Dirección de prueba",
        "is_active": True,
        "business_id": 1  # Ajusta si tu negocio principal tiene otro ID
    }
    create_resp = requests.post(f"{BASE_URL}/api/v1/suppliers/", data=json.dumps(supplier_data), headers=headers)
    try:
        create_json = create_resp.json()
    except Exception:
        create_json = None
    print(f"Create: {create_resp.status_code}")
    # 2. Update
    supplier_id = create_json.get("id") if create_json else None
    update_data = {"name": "Test Supplier Updated"}
    update_resp = requests.put(f"{BASE_URL}/api/v1/suppliers/{supplier_id}", data=json.dumps(update_data), headers=headers) if supplier_id else None
    print(f"Update: {update_resp.status_code if update_resp else 'N/A'}")
    # 3. Delete
    delete_resp = requests.delete(f"{BASE_URL}/api/v1/suppliers/{supplier_id}") if supplier_id else None
    print(f"Delete: {delete_resp.status_code if delete_resp else 'N/A'}")
    return {
        "create": {"status_code": create_resp.status_code, "success": create_resp.status_code == 200, "id": supplier_id},
        "update": {"status_code": update_resp.status_code if update_resp else None, "success": update_resp and update_resp.status_code == 200},
        "delete": {"status_code": delete_resp.status_code if delete_resp else None, "success": delete_resp and delete_resp.status_code == 200}
    }

def generate_report(all_results: Dict[str, Any]):
    """Generate a comprehensive test report"""
    print("\n" + "="*60)
    print("COMPREHENSIVE ADMIN PANEL TEST REPORT")
    print("="*60)
    
    total_tests = 0
    passed_tests = 0
    
    for category, results in all_results.items():
        print(f"\n{category.upper()}:")
        print("-" * 40)
        
        category_passed = 0
        category_total = len(results)
        
        for endpoint, result in results.items():
            total_tests += 1
            if result.get('success', False):
                passed_tests += 1
                category_passed += 1
                status = "✓ PASS"
            else:
                status = "✗ FAIL"
            
            print(f"  {status} {endpoint}")
            if 'error' in result:
                print(f"    Error: {result['error']}")
            elif 'status_code' in result:
                print(f"    Status: {result['status_code']}")
        
        print(f"  Category Score: {category_passed}/{category_total}")
    
    print("\n" + "="*60)
    print(f"OVERALL SCORE: {passed_tests}/{total_tests} ({passed_tests/total_tests*100:.1f}%)")
    print("="*60)
    
    if passed_tests == total_tests:
        print("🎉 ALL TESTS PASSED! The admin panel is fully functional.")
    elif passed_tests > total_tests * 0.8:
        print("✅ Most tests passed. Minor issues may exist.")
    else:
        print("⚠️  Several tests failed. Please review the issues.")

def main():
    """Run all tests and generate report"""
    print("Starting comprehensive admin panel tests...")
    print(f"Testing server at: {BASE_URL}")
    
    # Run all test categories
    all_results = {
        "accessibility": test_endpoint_accessibility(),
        "exports": test_export_functionality(),
        "api": test_api_endpoints(),
        "filters": test_filter_endpoints(),
        "health": test_api_health(),
        "product_crud": test_product_crud(),
        "warehouse_crud": test_warehouse_crud(),
        "supplier_crud": test_supplier_crud()
    }
    
    # Generate comprehensive report
    generate_report(all_results)
    
    return all_results

if __name__ == "__main__":
    results = main()
