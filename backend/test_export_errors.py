#!/usr/bin/env python3
import requests
import json

def test_export_endpoint(url):
    try:
        response = requests.get(url, timeout=10)
        print(f"=== {url} ===")
        print(f"Status Code: {response.status_code}")
        if response.status_code == 500:
            print(f"Error Content: {response.text}")
        elif response.status_code == 200:
            print("✓ Success")
        print()
    except Exception as e:
        print(f"Exception: {e}")
        print()

# Test the failing export endpoints
base_url = "http://localhost:8000"
failing_exports = [
    "/admin/warehouses/export",
    "/admin/articles/export", 
    "/admin/purchase-orders/export",
    "/admin/inventory-movements/export"
]

print("Testing failing export endpoints:")
for endpoint in failing_exports:
    test_export_endpoint(base_url + endpoint)

# Test the failing filter endpoints
failing_filters = [
    "/admin/purchase-orders?status=pending",
    "/admin/inventory-movements?movement_type=IN"
]

print("Testing failing filter endpoints:")
for endpoint in failing_filters:
    test_export_endpoint(base_url + endpoint)
