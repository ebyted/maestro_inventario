import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Provider } from 'react-redux';
import { store } from './src/store/store';
import SimpleNavigator from './src/navigation/SimpleNavigator';
import './src/i18n'; // Initialize i18n

interface ErrorBoundaryState {
  hasError: boolean;
  error: Error | null;
}

interface ErrorBoundaryProps {
  children: React.ReactNode;
}

// Error boundary component
class ErrorBoundary extends React.Component<ErrorBoundaryProps, ErrorBoundaryState> {
  constructor(props: ErrorBoundaryProps) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error: Error): ErrorBoundaryState {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('🔥 App Error:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return (
        <View style={styles.errorContainer}>
          <Text style={styles.errorTitle}>😵 Error en la aplicación</Text>
          <Text style={styles.errorText}>
            {this.state.error?.message || 'Error desconocido'}
          </Text>
          <Text style={styles.errorHelp}>
            Revisa la consola para más detalles
          </Text>
        </View>
      );
    }

    return this.props.children;
  }
}

export default function App() {
  console.log('🚀 App iniciada - Modo Simple con Error Boundary y Redux');
  
  try {
    return (
      <Provider store={store}>
        <ErrorBoundary>
          <SimpleNavigator />
        </ErrorBoundary>
      </Provider>
    );
  } catch (error: any) {
    console.error('🔥 Error crítico en App:', error);
    return (
      <View style={styles.errorContainer}>
        <Text style={styles.errorTitle}>💥 Error Crítico</Text>
        <Text style={styles.errorText}>
          No se pudo inicializar la aplicación
        </Text>
        <Text style={styles.errorHelp}>
          Error: {error?.message || 'Error desconocido'}
        </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  errorContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
    backgroundColor: '#f8f9fa',
  },
  errorTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 16,
    color: '#dc3545',
  },
  errorText: {
    fontSize: 16,
    marginBottom: 12,
    textAlign: 'center',
    color: '#6c757d',
  },
  errorHelp: {
    fontSize: 14,
    textAlign: 'center',
    color: '#6c757d',
    fontStyle: 'italic',
  },
});
