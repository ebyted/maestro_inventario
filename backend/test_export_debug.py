#!/usr/bin/env python3
import requests
import traceback

def test_export_endpoint(endpoint_name, url):
    print(f"\n=== Testing {endpoint_name} ===")
    try:
        response = requests.get(url, headers={"accept": "application/octet-stream"})
        print(f"Status Code: {response.status_code}")
        print(f"Headers: {dict(response.headers)}")
        if response.status_code == 200:
            print(f"Success! File size: {len(response.content)} bytes")
        else:
            print(f"Error response: {response.text}")
        return response.status_code == 200
    except Exception as e:
        print(f"Exception occurred: {e}")
        traceback.print_exc()
        return False

def main():
    base_url = "http://127.0.0.1:8020/admin"
    
    endpoints = [
        ("Warehouses Export", f"{base_url}/warehouses/export"),
        ("Articles Export", f"{base_url}/articles/export"),
        ("Purchase Orders Export", f"{base_url}/purchase-orders/export"),
        ("Inventory Movements Export", f"{base_url}/inventory-movements/export"),
    ]
    
    results = {}
    for name, url in endpoints:
        results[name] = test_export_endpoint(name, url)
    
    print("\n=== SUMMARY ===")
    for name, success in results.items():
        status = "✓ SUCCESS" if success else "✗ FAILED"
        print(f"{name}: {status}")

if __name__ == "__main__":
    main()
