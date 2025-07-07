import React from 'react';
import SimpleNavigator from './src/navigation/SimpleNavigator';
import './src/i18n'; // Initialize i18n

export default function App() {
  console.log('🚀 App iniciada - Modo Simple');
  
  return <SimpleNavigator />;
}
