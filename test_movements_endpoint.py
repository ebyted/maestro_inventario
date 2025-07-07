import requests
import json

# Test the movements endpoint
base_url = "http://localhost:8000"

# First, let's get a token (we'll need to authenticate)
login_data = {
    "username": "admin@example.com",
    "password": "admin123"
}

try:
    # Login
    login_response = requests.post(f"{base_url}/api/v1/auth/login", data=login_data)
    print(f"Login status: {login_response.status_code}")
    
    if login_response.status_code == 200:
        token_data = login_response.json()
        token = token_data.get("access_token")
        print(f"Got token: {token[:20]}...")
        
        # Test movements endpoint
        headers = {
            "Authorization": f"Bearer {token}",
            "accept": "application/json"
        }
        
        movements_response = requests.get(f"{base_url}/api/v1/inventory/movements", headers=headers)
        print(f"Movements endpoint status: {movements_response.status_code}")
        
        if movements_response.status_code == 200:
            movements = movements_response.json()
            print(f"Found {len(movements)} movements")
            if movements:
                print("First movement:", json.dumps(movements[0], indent=2, default=str))
            else:
                print("No movements found")
        else:
            print("Error response:", movements_response.text)
    else:
        print("Login failed:", login_response.text)

except Exception as e:
    print(f"Error: {e}")
