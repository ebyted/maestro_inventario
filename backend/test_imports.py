#!/usr/bin/env python3
"""
Test imports and basic functionality of admin_panel components
"""

import sys
import os

# Add the app path to imports
sys.path.append(os.path.join(os.path.dirname(__file__), 'app'))

try:
    print("Testing basic imports...")
    import pandas as pd
    print("✓ pandas imported successfully")
    
    from io import BytesIO
    print("✓ BytesIO imported successfully")
    
    print("Testing pandas DataFrame creation...")
    data = [{'test': 'value'}]
    df = pd.DataFrame(data)
    print("✓ DataFrame created successfully")
    
    print("Testing Excel export...")
    output = BytesIO()
    with pd.ExcelWriter(output, engine='openpyxl') as writer:
        df.to_excel(writer, sheet_name='Test', index=False)
    print("✓ Excel export successful")
    
    # Test database import
    print("Testing database imports...")
    from app.db.database import get_db
    print("✓ get_db imported successfully")
    
    from app.models.models import Supplier
    print("✓ Supplier model imported successfully")
    
    print("\n🎉 All import tests passed!")
    
except Exception as e:
    print(f"❌ Error: {e}")
    import traceback
    traceback.print_exc()
