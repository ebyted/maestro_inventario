import os
from sqlalchemy import create_engine, text

DB_URL = os.getenv("DATABASE_URL") or "postgresql://postgres:postgres@localhost:5432/maestro_inventario"

def main():
    print(f"[DEBUG] Using DB_URL: {DB_URL}")
    engine = create_engine(DB_URL)
    with engine.connect() as conn:
        try:
            # Check if table exists
            result = conn.execute(text("""
                SELECT to_regclass('public.activity_log');
            """)).scalar()
            if result:
                print("✅ Table 'activity_log' already exists.")
            else:
                conn.execute(text("""
                    CREATE TABLE activity_log (
                        id SERIAL PRIMARY KEY,
                        user_email VARCHAR(255),
                        action VARCHAR(255) NOT NULL,
                        details TEXT,
                        created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
                    );
                """))
                conn.commit()
                print("✅ Table 'activity_log' created.")
        except Exception as e:
            print(f"❌ Error: {e}")

if __name__ == "__main__":
    main()
