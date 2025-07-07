#!/usr/bin/env python3
import requests
import traceback

def test_filter_endpoint(endpoint_name, url, params=None):
    print(f"\n=== Testing {endpoint_name} ===")
    try:
        response = requests.get(url, params=params)
        print(f"Status Code: {response.status_code}")
        if response.status_code == 200:
            print(f"Success! Response: {response.json()}")
        else:
            print(f"Error response: {response.text}")
        return response.status_code == 200
    except Exception as e:
        print(f"Exception occurred: {e}")
        traceback.print_exc()
        return False

def main():
    base_url = "http://localhost:8000/admin"
    
    # Test filter endpoints with various parameters
    tests = [
        ("Purchase Order Filter - Pending", f"{base_url}/api/purchase-orders", {"status": "pending"}),
        ("Purchase Order Filter - Draft", f"{base_url}/api/purchase-orders", {"status": "draft"}),
        ("Inventory Movement Filter - Entry", f"{base_url}/api/inventory-movements", {"movement_type": "entry"}),
        ("Inventory Movement Filter - Exit", f"{base_url}/api/inventory-movements", {"movement_type": "exit"}),
    ]
    
    results = {}
    for name, url, params in tests:
        results[name] = test_filter_endpoint(name, url, params)
    
    print("\n=== FILTER TESTS SUMMARY ===")
    for name, success in results.items():
        status = "✓ SUCCESS" if success else "✗ FAILED"
        print(f"{name}: {status}")

if __name__ == "__main__":
    main()
