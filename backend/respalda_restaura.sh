#!/bin/bash
# Script sencillo para respaldar y restaurar una base de datos PostgreSQL entre FUENTE (pg_dump plano) y DESTINO (docker)
# Uso: ./respalda_restaura.sh

# Configuración fuente (local)
USUARIO="postgres"
DB="maestro_inventario"
BACKUP="respaldo_total.sql"

# Configuración destino (VPS)
VPS_USER="root"
VPS_HOST="168.231.67.221"
VPS_PASS="Arkano-IA2025"
CONTENEDOR_DESTINO="sancho-distribuidora-app-vaekv1-db-1"

# 1. Generar respaldo en FUENTE (formato SQL plano con inserts)
echo "[1] Generando respaldo SQL plano en FUENTE..."
pg_dump -U "$USUARIO" -d "$DB" --inserts > "$BACKUP"

if [ ! -f "$BACKUP" ]; then
    echo "❌ Error: No se generó el archivo de respaldo."
    exit 1
fi

echo "Respaldo generado: $BACKUP"

# 2. Copiar respaldo al VPS
echo "[2] Copiando respaldo al VPS..."
sshpass -p "$VPS_PASS" scp -o StrictHostKeyChecking=no "$BACKUP" "$VPS_USER"@"$VPS_HOST":$BACKUP

# 3. Restaurar respaldo en el VPS (DESTINO)
echo "[3] Restaurando respaldo en el VPS..."
sshpass -p "$VPS_PASS" ssh -o StrictHostKeyChecking=no "$VPS_USER"@"$VPS_HOST" "docker exec -i $CONTENEDOR_DESTINO psql -U $USUARIO -d $DB -c 'DROP SCHEMA public CASCADE; CREATE SCHEMA public;'"
sshpass -p "$VPS_PASS" ssh -o StrictHostKeyChecking=no "$VPS_USER"@"$VPS_HOST" "docker exec -i $CONTENEDOR_DESTINO psql -U $USUARIO -d $DB < $BACKUP"

echo "✅ Proceso de respaldo y restauración completado entre FUENTE y DESTINO."
