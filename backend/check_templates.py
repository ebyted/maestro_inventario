import os
import sys
sys.path.append('.')

try:
    from app.api.v1.endpoints.admin_panel import templates_dir
    print(f"Templates directory: {templates_dir}")
    print(f"Directory exists: {os.path.exists(templates_dir)}")
    if os.path.exists(templates_dir):
        files = os.listdir(templates_dir)
        print(f"Files in directory: {files}")
    else:
        print("Directory not found")
except Exception as e:
    print(f"Error: {e}")
