#!/usr/bin/env python3
"""
Simple manual test for warehouse dashboard
Run this after starting the server to test the new functionality
"""

def print_test_instructions():
    """Print manual testing instructions"""
    print("WAREHOUSE DASHBOARD - MANUAL TESTING GUIDE")
    print("=" * 50)
    print()
    print("1. START THE SERVER:")
    print("   cd backend")
    print("   python main.py")
    print()
    print("2. CREATE WAREHOUSE USER:")
    print("   - Login to admin panel: http://localhost:8000/admin")
    print("   - Use admin credentials (admin/admin123)")
    print("   - Visit: http://localhost:8000/admin/create-warehouse-user")
    print("   - This creates: username=almacenista1, password=almacen123")
    print()
    print("3. TEST WAREHOUSE DASHBOARD:")
    print("   - Logout from admin")
    print("   - Login with: almacenista1 / almacen123")
    print("   - You should see 'Dashboard de Almacén' link in the sidebar")
    print("   - Visit: http://localhost:8000/warehouse-dashboard")
    print()
    print("4. TEST FUNCTIONALITY:")
    print("   - Register warehouse entries and exits")
    print("   - View movement history")
    print("   - Check metrics and stats")
    print()
    print("5. API ENDPOINTS TO TEST:")
    print("   - GET /warehouse-dashboard (warehouse dashboard page)")
    print("   - POST /warehouse-movement (create movements)")
    print("   - GET /api/user-movements (get user's movements)")
    print()
    print("ROLES THAT CAN ACCESS:")
    print("   - almacenista (warehouse manager)")
    print("   - capturista (data entry clerk)")
    print()
    print("EXPECTED FEATURES:")
    print("   ✓ User-specific metrics")
    print("   ✓ Entry/Exit forms")
    print("   ✓ Movement history table")
    print("   ✓ Warehouse statistics")
    print("   ✓ Role-based access control")
    print("   ✓ Real-time filtering")
    print()

if __name__ == "__main__":
    print_test_instructions()
