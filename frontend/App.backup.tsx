import React, { useEffect } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { Provider, useDispatch } from 'react-redux';
import { PaperProvider } from 'react-native-paper';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { store, AppDispatch } from './src/store/store';
import AppNavigator from './src/navigation/AppNavigator';
import { theme } from './src/styles/theme';
import { loadSettings } from './src/store/slices/settingsSlice';
import { login } from './src/store/slices/authSlice';
import './src/i18n'; // Initialize i18n

function AppContent() {
  const dispatch = useDispatch<AppDispatch>();

  useEffect(() => {
    // Load user settings (including language) on app start
    dispatch(loadSettings());
    
    // Auto-login para testing
    autoLogin();
  }, [dispatch]);

  const autoLogin = async () => {
    try {
      console.log('🔐 Intentando auto-login...');
      
      // Verificar si ya hay token
      const existingToken = await AsyncStorage.getItem('token');
      if (existingToken) {
        console.log('✅ Token existente encontrado');
        return;
      }
      
      // Hacer login automático
      const result = await dispatch(login({ 
        email: 'admin@maestro.com', 
        password: 'admin123' 
      }));
      
      if (result.meta.requestStatus === 'fulfilled') {
        console.log('✅ Auto-login exitoso');
      } else {
        console.log('❌ Auto-login falló:', result.payload);
      }
    } catch (error) {
      console.log('❌ Error en auto-login:', error);
    }
  };

  return (
    <PaperProvider theme={theme}>
      <NavigationContainer>
        <AppNavigator />
      </NavigationContainer>
    </PaperProvider>
  );
}

export default function App() {
  return (
    <SafeAreaProvider>
      <Provider store={store}>
        <AppContent />
      </Provider>
    </SafeAreaProvider>
  );
}
