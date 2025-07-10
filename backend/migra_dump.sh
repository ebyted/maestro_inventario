#!/bin/bash
set -euo pipefail

# =====================
# CONFIGURACIÓN INICIAL
# =====================
CONTENEDOR_LOCAL="maestro-postgres"
CONTENEDOR_VPS="sancho-distribuidora-app-vaekv1-db-1"
DB="maestro_inventario"
USUARIO="postgres"
VPS_USER="root"
VPS_HOST="168.231.67.221"
VPS_PATH="backup.dump"  # Ruta en el VPS donde se copiará el respaldo
DOCKER_DB_NAME="maestro_inventario"  # Destino
LOG="migra_dump.log"

# =============
# FUNCIONES
# =============
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG"
}

limpiar() {
    log "Limpiando archivos temporales locales..."
    rm -f ./backup.dump
}

# =============
# INICIO DEL SCRIPT
# =============
log "==== INICIO MIGRACIÓN ===="

# 1. Generar respaldo local
log "1. Generando respaldo local..."
docker exec -t "$CONTENEDOR_LOCAL" pg_dump -U "$USUARIO" -d "$DB" -Fc -f backup.dump

if [ ! -f ./backup.dump ]; then
    log "❌ Error: No se generó el archivo backup.dump"
    exit 1
fi

# 2. Copiar respaldo al VPS
log "2. Copiando respaldo al VPS..."
scp -o StrictHostKeyChecking=no backup.dump "$VPS_USER"@"$VPS_HOST":"$VPS_PATH"

# 3. Borrar base de datos actual en el VPS
log "3. Borrando base de datos actual en el VPS..."
ssh "$VPS_USER@$VPS_HOST" \
  "docker exec -i $CONTENEDOR_VPS psql -U $USUARIO -d $DB -c 'DROP SCHEMA public CASCADE; CREATE SCHEMA public;'"

# 4. Reiniciar el contenedor de la base de datos en el VPS
log "4. Reiniciando el contenedor de la base de datos en el VPS..."
ssh "$VPS_USER@$VPS_HOST" "docker restart $CONTENEDOR_VPS"
sleep 5

# 5. Restaurar el backup en la base de datos DESTINO dentro del contenedor VPS
log "5. Restaurando backup en el VPS..."
ssh "$VPS_USER@$VPS_HOST" "docker cp $VPS_PATH $CONTENEDOR_VPS:/tmp/backup.dump"
ssh "$VPS_USER@$VPS_HOST" "docker exec -i $CONTENEDOR_VPS pg_restore -U $USUARIO -d $DOCKER_DB_NAME /tmp/backup.dump"

# 6. Aplicar migraciones con Alembic (debe ejecutarse en el contenedor de la app, no el de la DB)
log "6. Aplicando migraciones Alembic en el VPS..."
ssh "$VPS_USER@$VPS_HOST" "docker exec -i sancho-distribuidora-app-vaekv1-backend-1 bash -c 'alembic stamp head && alembic upgrade head'"

# 7. Validación final (opcional: conteo de usuarios, tablas, etc.)
log "7. Validando migración (conteo de usuarios)..."
ssh "$VPS_USER@$VPS_HOST" "docker exec -i $CONTENEDOR_VPS psql -U $USUARIO -d $DB -c 'SELECT COUNT(*) FROM users;'"

# 8. Limpieza
limpiar
ssh "$VPS_USER@$VPS_HOST" "rm -f $VPS_PATH"

log "==== MIGRACIÓN COMPLETADA EXITOSAMENTE ===="
echo "✅ Proceso completado. Revisa $LOG para detalles."
