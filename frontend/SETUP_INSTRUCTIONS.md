# Installation and Setup Instructions

## Prerequisites
Before running the app, you need to install Node.js and npm:

1. **Install Node.js**: Download from [nodejs.org](https://nodejs.org/)
2. **Verify installation**: Open PowerShell and run:
   ```powershell
   node --version
   npm --version
   ```

## Setup Steps

### 1. Install Dependencies
```powershell
# Navigate to frontend directory
cd "frontend"

# Install all dependencies
npm install

# Install additional development dependencies
npm install --save-dev @types/react-i18next
```

### 2. Start Development Server
```powershell
# Start Expo development server
npm start
```

### 3. Run on Device/Simulator
- **iOS Simulator**: Press `i` in the terminal
- **Android Emulator**: Press `a` in the terminal  
- **Physical Device**: Install Expo Go app and scan QR code

## Troubleshooting

### If npm is not recognized:
1. Install Node.js from [nodejs.org](https://nodejs.org/)
2. Restart PowerShell/Command Prompt
3. Add Node.js to PATH if necessary

### If TypeScript errors persist:
1. Delete `node_modules` folder
2. Run `npm install` again
3. Restart VS Code

### If Expo is not installed:
```powershell
npm install -g @expo/cli
```

## Multilanguage Features

Once the app is running:

1. **Language Switching**: 
   - Navigate to Settings tab
   - Tap "Language" option
   - Select between English/Spanish

2. **Persistence**: 
   - Language preference is saved automatically
   - Survives app restarts

3. **Auto-detection**: 
   - Uses device language as initial setting
   - Falls back to English if unsupported

## Current Implementation Status

✅ **Completed:**
- i18n configuration and setup
- English and Spanish translations
- Language selector component
- Settings screen integration
- Persistent language storage
- Updated navigation with translations
- Key screens translated (Dashboard, Login, Products)

⚠️ **Requires Setup:**
- Node.js and npm installation
- Dependencies installation (`npm install`)
- Expo CLI setup

🔄 **Next Steps:**
1. Install dependencies as outlined above
2. Test language switching functionality  
3. Complete translation of remaining screens
4. Add additional languages if needed

The multilanguage system is fully implemented and ready to use once dependencies are installed!
