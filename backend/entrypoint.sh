#!/bin/bash
set -e

# Esperar a que la base de datos esté lista
echo "Esperando a que PostgreSQL esté listo..."
until pg_isready -h db -p 5432 -U postgres; do
  sleep 2
done

echo "PostgreSQL está listo."

# Comprobar si la tabla businesses existe y si hay migraciones aplicadas
EXISTS=$(PGPASSWORD=postgres psql -h db -U postgres -d maestro_inventario -tAc "SELECT to_regclass('public.businesses') IS NOT NULL;")
ALEMBIC_VERSION=$(PGPASSWORD=postgres psql -h db -U postgres -d maestro_inventario -tAc "SELECT COUNT(*) FROM information_schema.tables WHERE table_name = 'alembic_version';")

#: Si la tabla businesses no existe, restaurar el backup y hacer stamp de alembic
#if [ "$EXISTS" = "f" ]; then
#  echo "La base de datos está vacía. Restaurando backup.sql..."
#  if [ -f /app/backup.sql ]; then
#    PGPASSWORD=postgres psql -h db -U postgres -d maestro_inventario -f /app/backup.sql
#    alembic stamp head
#  else
#    echo "No se encontró /app/backup.sql."
#    exit 1
#  fi
#else
#  # Si la tabla alembic_version no existe, crearla y hacer stamp
#  if [ "$ALEMBIC_VERSION" = "0" ]; then
#    echo "No hay tabla alembic_version. Ejecutando alembic stamp head..."
#    alembic stamp head
#  else
#    echo "La base de datos ya tiene datos y migraciones. Ejecutando alembic upgrade head..."
#    alembic upgrade head
#  fi
#fi

# Iniciar la aplicación
exec python main_production.py
