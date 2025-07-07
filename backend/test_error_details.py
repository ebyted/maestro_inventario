#!/usr/bin/env python3
"""
Test script to get detailed error information from failing endpoints
"""

import requests
import json

BASE_URL = "http://localhost:8000"

def test_endpoint_with_details(endpoint):
    """Test endpoint and show detailed error"""
    try:
        response = requests.get(f"{BASE_URL}{endpoint}")
        print(f"\n=== {endpoint} ===")
        print(f"Status Code: {response.status_code}")
        print(f"Headers: {dict(response.headers)}")
        print(f"Content: {response.text}")
        return response
    except Exception as e:
        print(f"Error: {e}")
        return None

# Test failing endpoints
failing_endpoints = [
    "/admin/suppliers/export",
    "/admin/suppliers?search=test",
    "/admin/articles?search=producto"
]

for endpoint in failing_endpoints:
    test_endpoint_with_details(endpoint)
