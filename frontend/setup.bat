@echo off
echo.
echo 🚀 Maestro Inventario - Setup Script
echo ===================================
echo.

echo 📋 Checking prerequisites...
echo.

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed!
    echo.
    echo Please install Node.js from: https://nodejs.org/
    echo After installation, restart this script.
    echo.
    pause
    exit /b 1
) else (
    echo ✅ Node.js is installed
    node --version
)

REM Check if npm is available
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm is not available!
    echo Please ensure Node.js is properly installed.
    echo.
    pause
    exit /b 1
) else (
    echo ✅ npm is available
    npm --version
)

echo.
echo 📦 Installing dependencies...
echo.

REM Install dependencies
npm install
if %errorlevel% neq 0 (
    echo ❌ Failed to install dependencies!
    echo.
    pause
    exit /b 1
)

echo.
echo 🔧 Installing additional development dependencies...
echo.

REM Install dev dependencies
npm install --save-dev @types/react-i18next
if %errorlevel% neq 0 (
    echo ⚠️ Warning: Could not install additional type definitions
    echo The app should still work correctly.
)

echo.
echo ✅ Setup completed successfully!
echo.
echo 🎯 Next steps:
echo   1. Run: npm start
echo   2. Use Expo Go app on your phone to scan QR code
echo   3. Or press 'i' for iOS simulator, 'a' for Android emulator
echo.
echo 🌐 Multilanguage features:
echo   - Navigate to Settings tab to change language
echo   - Switch between English and Spanish
echo   - Language preference is saved automatically
echo.
pause
