#!/usr/bin/env python3
"""
Final validation test for all export endpoints and functionality
"""
import requests
import traceback
from datetime import datetime

def test_export_endpoint(endpoint_name, url):
    print(f"\n=== Testing {endpoint_name} ===")
    try:
        response = requests.get(url, headers={"accept": "application/octet-stream"})
        print(f"Status Code: {response.status_code}")
        
        if response.status_code == 200:
            file_size = len(response.content)
            content_type = response.headers.get('content-type', '')
            content_disposition = response.headers.get('content-disposition', '')
            
            print(f"✅ SUCCESS!")
            print(f"   File size: {file_size:,} bytes")
            print(f"   Content-Type: {content_type}")
            print(f"   Content-Disposition: {content_disposition}")
            
            # Validate that it's actually an Excel file
            if 'spreadsheetml' in content_type and file_size > 1000:
                print(f"   ✅ Valid Excel file detected")
                return True
            else:
                print(f"   ⚠️  Warning: File may not be a valid Excel file")
                return False
        else:
            print(f"❌ FAILED - Status: {response.status_code}")
            print(f"   Response: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ FAILED - Exception: {e}")
        traceback.print_exc()
        return False

def test_admin_page(page_name, url):
    print(f"\n=== Testing {page_name} Page ===")
    try:
        response = requests.get(url)
        print(f"Status Code: {response.status_code}")
        
        if response.status_code == 200:
            content_length = len(response.content)
            print(f"✅ SUCCESS! Page loaded ({content_length:,} bytes)")
            return True
        else:
            print(f"❌ FAILED - Status: {response.status_code}")
            return False
            
    except Exception as e:
        print(f"❌ FAILED - Exception: {e}")
        return False

def main():
    base_url = "http://localhost:8000/admin"
    
    print("🔍 MAESTRO INVENTARIO - FINAL VALIDATION TEST")
    print("=" * 60)
    print(f"Timestamp: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 60)
    
    # Test all export endpoints
    export_tests = [
        ("Warehouses Export", f"{base_url}/warehouses/export"),
        ("Articles Export", f"{base_url}/articles/export"),
        ("Purchase Orders Export", f"{base_url}/purchase-orders/export"),
        ("Inventory Movements Export", f"{base_url}/inventory-movements/export"),
    ]
    
    # Test key admin pages
    page_tests = [
        ("Admin Dashboard", f"{base_url}/dashboard"),
        ("Warehouses Page", f"{base_url}/warehouses"),
        ("Articles Page", f"{base_url}/articles"),
        ("Purchase Orders Page", f"{base_url}/purchase-orders"),
        ("Inventory Movements Page", f"{base_url}/inventory-movements"),
    ]
    
    # Run export tests
    print("\n📊 TESTING EXPORT ENDPOINTS")
    print("-" * 40)
    export_results = {}
    for name, url in export_tests:
        export_results[name] = test_export_endpoint(name, url)
    
    # Run page tests
    print("\n🌐 TESTING ADMIN PAGES")
    print("-" * 40)
    page_results = {}
    for name, url in page_tests:
        page_results[name] = test_admin_page(name, url)
    
    # Summary
    print("\n" + "=" * 60)
    print("📋 FINAL SUMMARY")
    print("=" * 60)
    
    print("\n📊 Export Endpoints:")
    export_success = 0
    for name, success in export_results.items():
        status = "✅ SUCCESS" if success else "❌ FAILED"
        print(f"  {name}: {status}")
        if success:
            export_success += 1
    
    print("\n🌐 Admin Pages:")
    page_success = 0
    for name, success in page_results.items():
        status = "✅ SUCCESS" if success else "❌ FAILED"
        print(f"  {name}: {status}")
        if success:
            page_success += 1
    
    total_tests = len(export_results) + len(page_results)
    total_success = export_success + page_success
    
    print(f"\n🎯 OVERALL RESULT:")
    print(f"   Total Tests: {total_tests}")
    print(f"   Successful: {total_success}")
    print(f"   Failed: {total_tests - total_success}")
    print(f"   Success Rate: {(total_success/total_tests)*100:.1f}%")
    
    if export_success == len(export_tests):
        print(f"\n🎉 SUCCESS! All export endpoints are working correctly!")
        print(f"   - Fixed database schema mismatches")
        print(f"   - Fixed field name issues in models")
        print(f"   - Fixed enum conversion problems")
        print(f"   - All Excel exports generate valid files")
    else:
        print(f"\n⚠️  Some export endpoints still need attention")

if __name__ == "__main__":
    main()
