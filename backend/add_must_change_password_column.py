import os
from sqlalchemy import create_engine, text

DB_URL = os.getenv("DATABASE_URL") or "postgresql://postgres:postgres@localhost:5432/maestro_inventario"

def main():
    print(f"[DEBUG] Using DB_URL: {DB_URL}")
    engine = create_engine(DB_URL)
    with engine.connect() as conn:
        try:
            # Check if column exists
            result = conn.execute(text("""
                SELECT column_name FROM information_schema.columns 
                WHERE table_name='users' AND column_name='must_change_password';
            """)).fetchone()
            if result:
                print("✅ Column 'must_change_password' already exists in 'users' table.")
            else:
                conn.execute(text("""
                    ALTER TABLE users ADD COLUMN must_change_password BOOLEAN DEFAULT FALSE;
                """))
                conn.commit()
                print("✅ Column 'must_change_password' added to 'users' table.")
        except Exception as e:
            print(f"❌ Error: {e}")

if __name__ == "__main__":
    main()
