@echo off
echo ========================================
echo   INSTALACION MAESTRO INVENTARIO
echo   Base de Datos PostgreSQL + Backend
echo ========================================
echo.

echo 1. Descargando PostgreSQL...
echo Ve a: https://www.postgresql.org/download/windows/
echo Instala PostgreSQL 15+ con estas configuraciones:
echo   - Usuario: postgres
echo   - Password: postgres
echo   - Puerto: 5432
echo   - Crear base de datos: maestro_inventario
echo.

echo 2. Verificar instalacion...
pause
psql --version
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: PostgreSQL no encontrado
    echo Instala PostgreSQL antes de continuar
    pause
    exit /b 1
)

echo.
echo 3. Creando base de datos...
createdb -U postgres maestro_inventario
if %ERRORLEVEL% EQU 0 (
    echo ✅ Base de datos creada exitosamente
) else (
    echo ⚠️  La base de datos ya existe o hay un error
)

echo.
echo 4. Instalando dependencias de Python...
cd /d "%~dp0"
pip install psycopg2-binary alembic sqlalchemy

echo.
echo 5. Creando migraciones...
alembic upgrade head
if %ERRORLEVEL% EQU 0 (
    echo ✅ Migraciones aplicadas exitosamente
) else (
    echo ❌ Error en migraciones
)

echo.
echo 6. Iniciando servidor...
python main.py

pause
