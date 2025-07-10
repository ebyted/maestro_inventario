#!/usr/bin/env python3
"""
Test script for warehouse dashboard functionality
"""
import requests
import json

BASE_URL = "http://127.0.0.1:8020"

def test_warehouse_dashboard():
    """Test warehouse dashboard endpoints"""
    
    print("Testing Warehouse Dashboard Functionality")
    print("=" * 50)
    
    # First, login with an admin user to create a warehouse user
    admin_login_data = {
        "username": "admin",
        "password": "admin123"
    }
    
    print("1. Logging in as admin...")
    response = requests.post(f"{BASE_URL}/auth/login", data=admin_login_data)
    if response.status_code == 200:
        admin_token = response.json()["access_token"]
        print("✓ Admin login successful")
    else:
        print("✗ Admin login failed")
        return
    
    # Create a warehouse user (almacenista)
    warehouse_user_data = {
        "username": "almacenista1",
        "email": "almacenista1@ejemplo.com",
        "full_name": "Juan Pérez - Almacenista",
        "password": "almacen123",
        "role": "almacenista",
        "is_active": True
    }
    
    print("2. Creating warehouse user...")
    headers = {"Authorization": f"Bearer {admin_token}"}
    response = requests.post(f"{BASE_URL}/auth/register", 
                           json=warehouse_user_data, 
                           headers=headers)
    if response.status_code in [200, 201]:
        print("✓ Warehouse user created successfully")
    elif response.status_code == 400 and "already registered" in response.text:
        print("✓ Warehouse user already exists")
    else:
        print(f"✗ Failed to create warehouse user: {response.status_code} - {response.text}")
    
    # Login with warehouse user
    warehouse_login_data = {
        "username": "almacenista1",
        "password": "almacen123"
    }
    
    print("3. Logging in as warehouse user...")
    response = requests.post(f"{BASE_URL}/auth/login", data=warehouse_login_data)
    if response.status_code == 200:
        warehouse_token = response.json()["access_token"]
        print("✓ Warehouse user login successful")
    else:
        print("✗ Warehouse user login failed")
        return
    
    # Test warehouse dashboard access
    print("4. Testing warehouse dashboard access...")
    headers = {"Authorization": f"Bearer {warehouse_token}"}
    response = requests.get(f"{BASE_URL}/warehouse-dashboard", headers=headers)
    if response.status_code == 200:
        print("✓ Warehouse dashboard accessible")
    else:
        print(f"✗ Warehouse dashboard access failed: {response.status_code}")
    
    # Test user movements API
    print("5. Testing user movements API...")
    response = requests.get(f"{BASE_URL}/api/user-movements", headers=headers)
    if response.status_code == 200:
        movements = response.json()
        print(f"✓ User movements API working - {len(movements)} movements found")
    else:
        print(f"✗ User movements API failed: {response.status_code}")
    
    # Test movement creation endpoint (we'll simulate the form data)
    print("6. Testing movement creation...")
    movement_data = {
        "movement_type": "IN",
        "warehouse_id": "1",  # Assuming warehouse 1 exists
        "product_id": "1",    # Assuming product 1 exists
        "quantity": "10.5",
        "reference": "TEST-001",
        "notes": "Test entry from automated test"
    }
    
    response = requests.post(f"{BASE_URL}/warehouse-movement", 
                           data=movement_data, 
                           headers=headers)
    if response.status_code in [200, 302]:  # 302 is redirect after successful form submission
        print("✓ Movement creation endpoint working")
    else:
        print(f"✗ Movement creation failed: {response.status_code} - {response.text}")
    
    print("\nTest completed!")

if __name__ == "__main__":
    try:
        test_warehouse_dashboard()
    except requests.exceptions.ConnectionError:
        print("Error: Could not connect to server. Make sure the backend is running on http://127.0.0.1:8020")
    except Exception as e:
        print(f"Error during testing: {e}")
