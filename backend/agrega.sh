#!/bin/bash

# Nombre del contenedor y base de datos
CONTAINER_NAME="maestro-postgres"
DB_NAME="maestro_inventario"
DB_USER="postgres"
DB_PASSWORD="postgres"

echo "🚀 Conectando a $CONTAINER_NAME en la base $DB_NAME"

# 1. Agrega la columna hashed_password si no existe
docker exec -i $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME -c "
DO \$\$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name='users' AND column_name='hashed_password'
    ) THEN
        ALTER TABLE users ADD COLUMN hashed_password VARCHAR;
    END IF;
END
\$\$;
"

# 2. Copia los valores actuales de password_hash
docker exec -i $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME -c "
UPDATE users SET hashed_password = password_hash WHERE password_hash IS NOT NULL;
"

# 3. Verificación
docker exec -i $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME -c "
SELECT id, email, hashed_password FROM users;
"

# 4. (Opcional) Eliminar el campo viejo si ya no se necesita
# docker exec -i $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME -c "
# ALTER TABLE users DROP COLUMN password_hash;
# "
