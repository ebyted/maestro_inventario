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
        "filters": test_filter_endpoints()
    }
    
    # Generate comprehensive report
    generate_report(all_results)
    
    return all_results

if __name__ == "__main__":
    results = main()
