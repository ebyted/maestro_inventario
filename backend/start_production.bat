@echo off
echo ========================================
echo   MAESTRO INVENTARIO - PRODUCCION
echo   Base de Datos PostgreSQL + Backend
echo ========================================
echo.

echo Selecciona una opcion:
echo 1. Usar PostgreSQL local (requiere instalacion manual)
echo 2. Usar Docker PostgreSQL (recomendado)
echo 3. Solo inicializar base de datos existente
echo.
set /p choice="Ingresa tu opcion (1-3): "

if "%choice%"=="1" (
    echo.
    echo Configurando PostgreSQL local...
    call setup_database.bat
) else if "%choice%"=="2" (
    echo.
    echo Configurando Docker PostgreSQL...
    call setup_docker.bat
) else if "%choice%"=="3" (
    echo.
    echo Inicializando base de datos existente...
    goto :init_only
) else (
    echo Opcion invalida
    pause
    exit /b 1
)

:init_only
echo.
echo ========================================
echo   INICIALIZANDO DATOS
echo ========================================

echo 1. Instalando dependencias de Python...
pip install -r requirements.txt

echo.
echo 2. Aplicando migraciones...
alembic upgrade head
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Error en migraciones
    echo Revisa la configuracion de base de datos en .env
    pause
    exit /b 1
)

echo.
echo 3. Inicializando datos por defecto...
python init_db.py
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Error inicializando datos
    pause
    exit /b 1
)

echo.
echo 4. Iniciando servidor de produccion...
echo.
echo ========================================
echo   SERVIDOR INICIADO
echo ========================================
echo API: http://localhost:8000
echo Documentacion: http://localhost:8000/docs
echo.
echo Credenciales:
echo Email: admin@maestro.com
echo Password: 123456
echo ========================================
echo.

python main_production.py

pause
