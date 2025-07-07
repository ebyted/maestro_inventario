#!/bin/bash
set -e

# Esperar a que la base de datos esté lista
echo "Esperando a que PostgreSQL esté listo..."
until pg_isready -h db -p 5432 -U postgres; do
  sleep 2
done

echo "PostgreSQL está listo."

# Comprobar si la tabla businesses existe
EXISTS=$(PGPASSWORD=postgres12 psql -h db -U postgres -d maestro_inventario -tAc "SELECT to_regclass('public.businesses') IS NOT NULL;")

if [ "$EXISTS" = "f" ]; then
  echo "La base de datos está vacía. Restaurando backup.sql..."
  if [ -f /app/backup.sql ]; then
    PGPASSWORD=postgres psql -h db -U postgres -d maestro_inventario -f /app/backup.sql
    alembic stamp head
  else
    echo "No se encontró /app/backup.sql."
    exit 1
  fi
else
  echo "La base de datos ya tiene datos. Ejecutando alembic upgrade head..."
  alembic upgrade head
fi

# Iniciar la aplicación
exec python main.py
