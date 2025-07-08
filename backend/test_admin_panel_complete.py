#!/usr/bin/env python3
"""
Comprehensive test script for the Admin Panel functionality.
Tests all CRUD operations and export functionality.
"""

import requests
import json
import time
from typing import Dict, Any
import json as _json
from datetime import datetime as _dt

BASE_URL = "http://localhost:8020"

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

def get_auth_token():
    login_url = f"{BASE_URL}/api/v1/auth/login"
    login_data = {"email": "admin@maestro.com", "password": "admin123"}
    headers = {"Content-Type": "application/json"}
    try:
        resp = requests.post(login_url, json=login_data, headers=headers)
        if resp.status_code == 200 and "access_token" in resp.json():
            print("[AUTH] Login succeeded with JSON email/password and explicit header.")
            return resp.json()["access_token"]
        else:
            print(f"[AUTH ERROR] JSON email/password failed: {resp.status_code} - {resp.text}")
    except Exception as e:
        print(f"[AUTH ERROR] Exception during JSON email/password: {e}")
    return None

# Store token globally for use in all protected requests
AUTH_TOKEN = get_auth_token()

def get_auth_headers():
    if AUTH_TOKEN:
        return {"Authorization": f"Bearer {AUTH_TOKEN}"}
    return {}

def test_api_endpoints():
    """Test core API endpoints (use token for protected endpoints)"""
    api_endpoints = [
        ("/docs", False),
        ("/openapi.json", False),
        ("/api/v1/products/", True),
        ("/api/v1/inventory/movements", True),
        ("/api/v1/suppliers/", True),
        ("/api/v1/warehouses/", True)
    ]
    print("\nTesting API endpoints...")
    results = {}
    for endpoint, protected in api_endpoints:
        try:
            headers = get_auth_headers() if protected else {}
            response = requests.get(f"{BASE_URL}{endpoint}", headers=headers)
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
    """Test create, update, and delete product (CRUD) con validación de contenido"""
    print("\nTesting product CRUD endpoints...")
    headers = {"Content-Type": "application/json"}
    headers.update(get_auth_headers())
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
    # Validación de contenido creado
    create_content_ok = (
        create_json is not None and
        create_json.get("name") == product_data["name"] and
        create_json.get("sku") == product_data["sku"]
    )
    # 2. Update
    product_id = create_json.get("id") if create_json else None
    update_data = {"name": "Test Product API Updated"}
    update_resp = requests.put(f"{BASE_URL}/api/v1/products/{product_id}", data=json.dumps(update_data), headers=headers) if product_id else None
    print(f"Update: {update_resp.status_code if update_resp else 'N/A'}")
    # Validación de contenido actualizado
    update_content_ok = False
    if update_resp and update_resp.status_code == 200:
        try:
            update_json = update_resp.json()
            update_content_ok = update_json.get("name") == update_data["name"]
        except Exception:
            pass
    # 3. Delete
    delete_resp = requests.delete(f"{BASE_URL}/api/v1/products/{product_id}", headers=get_auth_headers()) if product_id else None
    print(f"Delete: {delete_resp.status_code if delete_resp else 'N/A'}")
    delete_content_ok = delete_resp and delete_resp.status_code == 200
    return {
        "create": {"status_code": create_resp.status_code, "success": create_resp.status_code == 200 and create_content_ok, "id": product_id, "content_ok": create_content_ok},
        "update": {"status_code": update_resp.status_code if update_resp else None, "success": update_resp and update_resp.status_code == 200 and update_content_ok, "content_ok": update_content_ok},
        "delete": {"status_code": delete_resp.status_code if delete_resp else None, "success": delete_content_ok}
    }

def test_warehouse_crud():
    """Test create, update, and delete warehouse (CRUD) con validación de contenido"""
    print("\nTesting warehouse CRUD endpoints...")
    headers = {"Content-Type": "application/json"}
    headers.update(get_auth_headers())
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
    # Validación de contenido creado
    create_content_ok = (
        create_json is not None and
        create_json.get("name") == warehouse_data["name"] and
        create_json.get("location") == warehouse_data["location"]
    )
    # 2. Update
    warehouse_id = create_json.get("id") if create_json else None
    update_data = {"name": "Test Warehouse Updated"}
    update_resp = requests.put(f"{BASE_URL}/api/v1/warehouses/{warehouse_id}", data=json.dumps(update_data), headers=headers) if warehouse_id else None
    print(f"Update: {update_resp.status_code if update_resp else 'N/A'}")
    # Validación de contenido actualizado
    update_content_ok = False
    if update_resp and update_resp.status_code == 200:
        try:
            update_json = update_resp.json()
            update_content_ok = update_json.get("name") == update_data["name"]
        except Exception:
            pass
    # 3. Delete
    delete_resp = requests.delete(f"{BASE_URL}/api/v1/warehouses/{warehouse_id}", headers=get_auth_headers()) if warehouse_id else None
    print(f"Delete: {delete_resp.status_code if delete_resp else 'N/A'}")
    delete_content_ok = delete_resp and delete_resp.status_code == 200
    return {
        "create": {"status_code": create_resp.status_code, "success": create_resp.status_code == 200 and create_content_ok, "id": warehouse_id, "content_ok": create_content_ok},
        "update": {"status_code": update_resp.status_code if update_resp else None, "success": update_resp and update_resp.status_code == 200 and update_content_ok, "content_ok": update_content_ok},
        "delete": {"status_code": delete_resp.status_code if delete_resp else None, "success": delete_content_ok}
    }

def test_supplier_crud():
    """Test create, update, and delete supplier (CRUD) con validación de contenido"""
    print("\nTesting supplier CRUD endpoints...")
    headers = {"Content-Type": "application/json"}
    headers.update(get_auth_headers())
    # 1. Create
    supplier_data = {
        "name": f"Test Supplier {int(time.time())}",
        "contact_name": "Contacto Prueba",
        "contact_email": "prueba@example.com",
        "contact_phone": "555-1234",
        "address": "Dirección de prueba",
        "is_active": True,
        "business_id": 1
    }
    create_resp = requests.post(f"{BASE_URL}/api/v1/suppliers/", data=json.dumps(supplier_data), headers=headers)
    try:
        create_json = create_resp.json()
    except Exception:
        create_json = None
    print(f"Create: {create_resp.status_code}")
    # Validación de contenido creado
    create_content_ok = (
        create_json is not None and
        create_json.get("name") == supplier_data["name"] and
        create_json.get("contact_email") == supplier_data["contact_email"]
    )
    # 2. Update
    supplier_id = create_json.get("id") if create_json else None
    update_data = {"name": "Test Supplier Updated"}
    update_resp = requests.put(f"{BASE_URL}/api/v1/suppliers/{supplier_id}", data=json.dumps(update_data), headers=headers) if supplier_id else None
    print(f"Update: {update_resp.status_code if update_resp else 'N/A'}")
    # Validación de contenido actualizado
    update_content_ok = False
    if update_resp and update_resp.status_code == 200:
        try:
            update_json = update_resp.json()
            update_content_ok = update_json.get("name") == update_data["name"]
        except Exception:
            pass
    # 3. Delete
    delete_resp = requests.delete(f"{BASE_URL}/api/v1/suppliers/{supplier_id}", headers=get_auth_headers()) if supplier_id else None
    print(f"Delete: {delete_resp.status_code if delete_resp else 'N/A'}")
    delete_content_ok = delete_resp and delete_resp.status_code == 200
    return {
        "create": {"status_code": create_resp.status_code, "success": create_resp.status_code == 200 and create_content_ok, "id": supplier_id, "content_ok": create_content_ok},
        "update": {"status_code": update_resp.status_code if update_resp else None, "success": update_resp and update_resp.status_code == 200 and update_content_ok, "content_ok": update_content_ok},
        "delete": {"status_code": delete_resp.status_code if delete_resp else None, "success": delete_content_ok}
    }

def test_auth_and_permissions():
    """Test login, token, and protected endpoint access"""
    print("\nTesting authentication and permissions...")
    login_url = f"{BASE_URL}/api/v1/auth/login"
    protected_url = f"{BASE_URL}/api/v1/users/"
    # 1. Login correcto
    login_data = {"email": "admin@maestro.com", "password": "admin123"}
    resp = requests.post(login_url, json=login_data)
    try:
        login_json = resp.json()
    except Exception:
        login_json = None
    token = login_json.get("access_token") if login_json else None
    login_success = resp.status_code == 200 and token is not None
    if not login_success:
        print(f"[AUTH ERROR] Login failed: {resp.status_code} - {resp.text}")
    print(f"Login correcto: {resp.status_code}")
    # 2. Login incorrecto
    bad_login_data = {"email": "admin@maestro.com", "password": "wrongpass"}
    bad_resp = requests.post(login_url, json=bad_login_data)
    bad_login_fail = bad_resp.status_code == 401
    print(f"Login incorrecto: {bad_resp.status_code}")
    # 3. Acceso a endpoint protegido con token
    headers = {"Authorization": f"Bearer {token}"} if token else {}
    prot_resp = requests.get(protected_url, headers=headers)
    prot_access = prot_resp.status_code == 200 and isinstance(prot_resp.json(), list)
    print(f"Acceso protegido con token: {prot_resp.status_code}")
    # 4. Acceso a endpoint protegido sin token
    prot_noauth_resp = requests.get(protected_url)
    prot_noauth_fail = prot_noauth_resp.status_code in (401, 403)
    print(f"Acceso protegido sin token: {prot_noauth_resp.status_code}")
    return {
        "login_success": {"status_code": resp.status_code, "success": login_success},
        "login_fail": {"status_code": bad_resp.status_code, "success": bad_login_fail},
        "protected_access": {"status_code": prot_resp.status_code, "success": prot_access},
        "protected_noauth": {"status_code": prot_noauth_resp.status_code, "success": prot_noauth_fail}
    }

def test_error_scenarios():
    """Test error scenarios: invalid data and unauthorized access"""
    print("\nTesting error scenarios...")
    headers = {"Content-Type": "application/json"}
    headers.update(get_auth_headers())
    # 1. Crear producto con datos inválidos (falta nombre)
    bad_product = {"sku": "BADSKU", "business_id": 1}
    resp_prod = requests.post(f"{BASE_URL}/api/v1/products/", data=json.dumps(bad_product), headers=headers)
    prod_fail = resp_prod.status_code in (400, 422)
    # 2. Crear almacén sin nombre
    bad_warehouse = {"location": "Sin nombre", "business_id": 1}
    resp_wh = requests.post(f"{BASE_URL}/api/v1/warehouses/", data=json.dumps(bad_warehouse), headers=headers)
    wh_fail = resp_wh.status_code in (400, 422)
    # 3. Crear supplier sin nombre
    bad_supplier = {"contact_email": "bad@bad.com", "business_id": 1}
    resp_sup = requests.post(f"{BASE_URL}/api/v1/suppliers/", data=json.dumps(bad_supplier), headers=headers)
    sup_fail = resp_sup.status_code in (400, 422)
    # 4. Acceso no autorizado a endpoint protegido
    prot_url = f"{BASE_URL}/api/v1/users/"
    prot_resp = requests.get(prot_url, headers=get_auth_headers())
    prot_fail = prot_resp.status_code in (401, 403)
    return {
        "bad_product": {"status_code": resp_prod.status_code, "success": prod_fail},
        "bad_warehouse": {"status_code": resp_wh.status_code, "success": wh_fail},
        "bad_supplier": {"status_code": resp_sup.status_code, "success": sup_fail},
        "protected_noauth": {"status_code": prot_resp.status_code, "success": prot_fail}
    }

def generate_report(results: dict):
    print("="*60)
    print("COMPREHENSIVE ADMIN PANEL TEST REPORT")
    print("="*60)
    overall_score = 0
    overall_total = 0
    for category, tests in results.items():
        print(f"{category.upper()}:")
        print("-"*40)
        score = 0
        total = 0
        # If tests is not a dict of endpoints, wrap it as a single result
        if not isinstance(tests, dict) or (isinstance(tests, dict) and not any(isinstance(v, dict) for v in tests.values())):
            tests = {category: tests}
        for endpoint, result in tests.items():
            total += 1
            if result is None:
                result = {"status_code": None, "success": False}
            elif isinstance(result, int):
                result = {"status_code": result, "success": result == 200}
            if result.get('success', False):
                print(f"  ✓ PASS {endpoint}\n    Status: {result.get('status_code')}")
                score += 1
            else:
                print(f"  ✗ FAIL {endpoint}\n    Status: {result.get('status_code')}")
        print(f"  Category Score: {score}/{total}")
        overall_score += score
        overall_total += total
    # Guardar JSON
    now = _dt.now().strftime('%Y%m%d_%H%M%S')
    json_path = f"test_report_{now}.json"
    html_path = f"test_report_{now}.html"
    with open(json_path, "w", encoding="utf-8") as f:
        _json.dump(results, f, indent=2, ensure_ascii=False)
    # Guardar HTML
    with open(html_path, "w", encoding="utf-8") as f:
        f.write(f"<html><head><title>Test Report {now}</title></head><body>")
        f.write(f"<h1>Comprehensive Admin Panel Test Report</h1>")
        if overall_score == overall_total:
            f.write('<h2 style="color:green">🎉 ALL TESTS PASSED! The admin panel is fully functional.</h2>')
        elif overall_score > overall_total * 0.8:
            f.write('<h2 style="color:orange">✅ Most tests passed. Minor issues may exist.</h2>')
        else:
            f.write('<h2 style="color:red">⚠️  Several tests failed. Please review the issues.</h2>')
        f.write("<hr>")
        for category, tests in results.items():
            f.write(f"<h2>{category.upper()}</h2><ul>")
            # Same logic as above for single result
            if not isinstance(tests, dict) or (isinstance(tests, dict) and not any(isinstance(v, dict) for v in tests.values())):
                tests = {category: tests}
            for endpoint, result in tests.items():
                if result is None:
                    result = {"status_code": None, "success": False}
                elif isinstance(result, int):
                    result = {"status_code": result, "success": result == 200}
                status = "PASS" if result.get('success', False) else "FAIL"
                f.write(f"<li>{status} {endpoint} - Status: {result.get('status_code')}</li>")
            f.write("</ul><hr>")
        f.write(f"<b>OVERALL SCORE: {overall_score}/{overall_total} ({overall_score/overall_total*100:.1f}%)</b>")
        f.write("</body></html>")
    print(f"\nTest report saved as {json_path} and {html_path}\n")

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
        "supplier_crud": test_supplier_crud(),
        "auth_permissions": test_auth_and_permissions(),
        "error_scenarios": test_error_scenarios()
    }
    
    # Generate comprehensive report
    generate_report(all_results)
    
    return all_results

if __name__ == "__main__":
    results = main()
