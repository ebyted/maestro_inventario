# Multilanguage (i18n) Setup - Maestro Inventario

## Overview
The application now supports multiple languages with runtime language switching. Currently implemented languages:
- English (en) 🇺🇸
- Spanish (es) 🇪🇸

## Features
- ✅ Runtime language switching without app restart
- ✅ Persistent language preference (saved to AsyncStorage)
- ✅ Automatic device language detection as fallback
- ✅ Complete translation coverage for UI strings
- ✅ Settings screen with language selector
- ✅ Easy to add new languages

## How to Use

### Changing Language
1. Navigate to the **Settings** tab in the bottom navigation
2. Tap on **Language** / **Idioma**
3. Select your preferred language from the modal
4. The app will immediately switch to the selected language

### Current Language Support
- **Dashboard**: Welcome messages, quick actions, stats
- **Products**: Search, SKU, categories, etc.
- **Auth**: Login/Register forms and messages
- **Navigation**: All tab and screen titles
- **Settings**: Configuration options
- **Common**: Buttons, alerts, form labels

## Technical Implementation

### Files Structure
```
src/
├── i18n/
│   ├── index.ts              # i18n configuration
│   └── locales/
│       ├── en.json           # English translations
│       └── es.json           # Spanish translations
├── components/
│   ├── LanguageSelector.tsx  # Language selection component
│   └── LanguageDemo.tsx      # Demo component for testing
├── screens/
│   └── SettingsScreen.tsx    # Settings with language options
└── store/slices/
    └── settingsSlice.ts      # Redux state for settings
```

### Key Components

#### i18n Configuration (`src/i18n/index.ts`)
- Initializes i18next with React Native support
- Automatic language detection from device settings
- Fallback to AsyncStorage for user preferences
- Fallback to English if no preference found

#### Language Selector (`src/components/LanguageSelector.tsx`)
- Modal-based language selection
- Radio button interface
- Real-time language switching
- Integrated with Redux for state management

#### Settings Slice (`src/store/slices/settingsSlice.ts`)
- Async thunks for loading/saving settings
- Language persistence with AsyncStorage
- Integration with i18next for language changes

### Usage in Components
```tsx
import { useTranslation } from 'react-i18next';

function MyComponent() {
  const { t } = useTranslation();
  
  return (
    <Text>{t('common.save')}</Text>
  );
}
```

### Adding New Languages

1. **Create translation file**:
   ```
   src/i18n/locales/fr.json  # For French
   ```

2. **Add translations** (copy structure from en.json):
   ```json
   {
     "app": {
       "name": "Maestro Inventario",
       "welcome": "Bienvenue à Maestro Inventario"
     },
     // ... rest of translations
   }
   ```

3. **Update i18n config** (`src/i18n/index.ts`):
   ```tsx
   import fr from './locales/fr.json';
   
   i18n.init({
     resources: {
       en: { translation: en },
       es: { translation: es },
       fr: { translation: fr }, // Add new language
     },
     // ... rest of config
   });
   ```

4. **Update LanguageSelector** component to include new language option.

## Translation Keys Structure

### Main Categories
- `app.*` - Application-wide strings
- `auth.*` - Authentication related
- `navigation.*` - Navigation labels
- `dashboard.*` - Dashboard screen
- `products.*` - Products management
- `inventory.*` - Inventory management
- `sales.*` - Sales and POS
- `business.*` - Business configuration
- `settings.*` - Settings screen
- `common.*` - Common UI elements
- `languages.*` - Language names

### Best Practices
1. **Consistent naming**: Use clear, hierarchical keys
2. **Parameterization**: Use `{{variable}}` for dynamic content
3. **Pluralization**: Consider singular/plural forms
4. **Context**: Group related translations together
5. **Fallbacks**: Always provide English as fallback

## Testing
- Use `LanguageDemo` component to test translations
- Check persistence by closing/reopening the app
- Verify all screens update immediately after language change
- Test with different device languages

## Dependencies
- `react-i18next`: React bindings for i18next
- `i18next`: Internationalization framework
- `expo-localization`: Device language detection
- `@react-native-async-storage/async-storage`: Settings persistence

## Notes
- Language changes are immediate (no app restart required)
- User preferences are preserved between app sessions
- Device language is detected and used as initial preference
- All text should use translation keys (no hardcoded strings)
- Settings tab is now available in the main navigation
