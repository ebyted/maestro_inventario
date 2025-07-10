#!/bin/bash

# Parámetros
CONTENEDOR_LOCAL="maestro-postgres"
CONTENEDOR_VPS="sancho-distribuidora-app-vaekv1-db-1"
DB="maestro_inventario"
USUARIO="postgres"
VPS_USER="root"
VPS_HOST="168.231.67.221"
VPS_PATH="resp.sql"  # Ruta en el VPS donde se copiará el respaldo
VPS_PASS="Arkano-IA2025"

echo "🟢 1. Generando respaldo local..."
docker exec -t $CONTENEDOR_LOCAL pg_dump -U $USUARIO -d $DB --inserts > resp.sql

echo "🟢 2. Copiando respaldo al VPS..."
sshpass -p "$VPS_PASS" scp resp.sql $VPS_USER@$VPS_HOST:$VPS_PATH

echo "🟢 3. Borrando base de datos actual en el VPS..."
sshpass -p "$VPS_PASS" ssh $VPS_USER@$VPS_HOST "docker exec -i $CONTENEDOR_VPS psql -U $USUARIO -d $DB -c 'DROP SCHEMA public CASCADE; CREATE SCHEMA public;'"

echo "🟢 4. Reiniciando el contenedor de la base de datos en el VPS..."
sshpass -p "$VPS_PASS" ssh $VPS_USER@$VPS_HOST "docker down $CONTENEDOR_VPS"

echo "🟢 5. Restaurando respaldo en el VPS..."
#sshpass -p "$VPS_PASS" ssh $VPS_USER@$VPS_HOST "docker exec -i $CONTENEDOR_VPS psql -U $USUARIO -d $DB -f $VPS_PATH"

echo "✅ Proceso completado."