@echo off
echo ========================================
echo   MAESTRO INVENTARIO - Docker Setup
echo ========================================
echo.

echo 1. Verificando Docker...
docker --version
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Docker no encontrado
    echo Instala Docker Desktop desde: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

echo.
echo 2. Creando contenedor PostgreSQL...
docker run --name maestro-postgres ^
  -e POSTGRES_PASSWORD=postgres ^
  -e POSTGRES_USER=postgres ^
  -e POSTGRES_DB=maestro_inventario ^
  -p 5432:5432 ^
  -d postgres:15

if %ERRORLEVEL% EQU 0 (
    echo ✅ Contenedor PostgreSQL creado exitosamente
    echo Esperando que la base de datos esté lista...
    timeout /t 10 /nobreak > nul
) else (
    echo ⚠️  El contenedor ya existe o hay un error
    echo Intentando iniciar contenedor existente...
    docker start maestro-postgres
)

echo.
echo 3. Verificando conexión...
timeout /t 5 /nobreak > nul
docker exec maestro-postgres psql -U postgres -d maestro_inventario -c "SELECT version();"

echo.
echo 4. Instalando dependencias...
cd /d "%~dp0"
pip install psycopg2-binary alembic sqlalchemy

echo.
echo 5. Aplicando migraciones...
alembic upgrade head

REM =========================================
REM  SECCIÓN DE STATUS Y DATOS DE CONEXIÓN BD
REM =========================================
echo.
echo --------- STATUS DE CONEXIÓN BD ---------
docker exec maestro-postgres psql -U postgres -d maestro_inventario -c "\conninfo"
echo.
echo --------- INFO DE LA BASE DE DATOS ---------
docker exec maestro-postgres psql -U postgres -d maestro_inventario -c "SELECT current_database(), current_user, inet_server_addr(), inet_server_port();"
echo.

echo.
echo ========================================
echo   CONFIGURACIÓN COMPLETADA
echo ========================================
echo PostgreSQL corriendo en: localhost:5432
echo Base de datos: maestro_inventario
echo Usuario: postgres
echo Password: postgres
echo.
echo Para detener: docker stop maestro-postgres
echo Para reiniciar: docker start maestro-postgres
echo ========================================

pause
