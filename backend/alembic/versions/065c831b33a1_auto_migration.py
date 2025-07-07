"""Update userrole enum values to uppercase

Revision ID: 065c831b33a1
Revises: ec46e98132fb
Create Date: 2025-07-06 19:49:57.176236

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = '065c831b33a1'
down_revision = 'ec46e98132fb'
branch_labels = None
depends_on = None

# Enum values (update as needed)
old_userrole = postgresql.ENUM(
    'admin', 'manager', 'employee', 'viewer', 'almacenista', 'capturista',
    name='userrole'
)
new_userrole = postgresql.ENUM(
    'ADMIN', 'MANAGER', 'EMPLOYEE', 'VIEWER', 'ALMACENISTA', 'CAPTURISTA',
    name='userrole'
)

def upgrade():
    # 1. Renombrar el tipo enum antiguo
    op.execute("ALTER TYPE userrole RENAME TO userrole_old;")
    # 2. Crear el nuevo tipo enum
    new_userrole.create(op.get_bind())
    # 3. Cambiar ambas columnas a VARCHAR temporalmente
    op.execute("ALTER TABLE users ALTER COLUMN role TYPE VARCHAR;")
    op.execute("ALTER TABLE business_users ALTER COLUMN role TYPE VARCHAR;")
    # 4. Actualizar datos a mayúsculas en ambas tablas
    op.execute("UPDATE users SET role = UPPER(role);")
    op.execute("UPDATE business_users SET role = UPPER(role);")
    # 5. Cambiar ambas columnas al nuevo tipo enum
    op.execute("ALTER TABLE users ALTER COLUMN role TYPE userrole USING role::userrole;")
    op.execute("ALTER TABLE business_users ALTER COLUMN role TYPE userrole USING role::userrole;")
    # 6. Eliminar el tipo enum antiguo
    op.execute("DROP TYPE userrole_old;")

def downgrade():
    # 1. Renombrar el tipo enum actual
    op.execute("ALTER TYPE userrole RENAME TO userrole_new;")
    # 2. Recrear el tipo enum antiguo
    old_userrole.create(op.get_bind())
    # 3. Cambiar ambas columnas a VARCHAR temporalmente
    op.execute("ALTER TABLE users ALTER COLUMN role TYPE VARCHAR;")
    op.execute("ALTER TABLE business_users ALTER COLUMN role TYPE VARCHAR;")
    # 4. Actualizar datos a minúsculas en ambas tablas
    op.execute("UPDATE users SET role = LOWER(role);")
    op.execute("UPDATE business_users SET role = LOWER(role);")
    # 5. Cambiar ambas columnas al tipo enum antiguo
    op.execute("ALTER TABLE users ALTER COLUMN role TYPE userrole USING role::userrole;")
    op.execute("ALTER TABLE business_users ALTER COLUMN role TYPE userrole USING role::userrole;")
    # 6. Eliminar el tipo enum nuevo
    op.execute("DROP TYPE userrole_new;")
