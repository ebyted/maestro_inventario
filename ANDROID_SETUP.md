# Configuración de Android SDK para Expo

## Pasos para configurar Android:

### 1. Descargar e Instalar Android Studio
- Ve a: https://developer.android.com/studio
- Descarga e instala Android Studio
- Durante la instalación, asegúrate de instalar:
  - Android SDK
  - Android SDK Platform-Tools
  - Android Virtual Device (AVD)

### 2. Configurar Variables de Entorno
Después de instalar Android Studio, agrega estas variables de entorno:

```bash
# En Windows (PowerShell)
$env:ANDROID_HOME = "C:\Users\$env:USERNAME\AppData\Local\Android\Sdk"
$env:PATH += ";$env:ANDROID_HOME\platform-tools;$env:ANDROID_HOME\tools;$env:ANDROID_HOME\tools\bin"
```

O agrega permanentemente en el sistema:
- ANDROID_HOME: C:\Users\[tu-usuario]\AppData\Local\Android\Sdk
- Agregar a PATH: %ANDROID_HOME%\platform-tools

### 3. Verificar Instalación
```bash
adb --version
```

### 4. Crear AVD (Emulador)
- Abre Android Studio
- Ve a Tools > AVD Manager
- Crea un nuevo dispositivo virtual
- Ejecuta el emulador

### 5. Alternativa: Usar dispositivo físico
- Habilita "Opciones de desarrollador" en tu Android
- Activa "Depuración USB"
- Conecta tu dispositivo
- Instala la app Expo Go desde Play Store
- Escanea el código QR que muestra Expo
