import React, { useState, useEffect, useMemo } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  ActivityIndicator,
  Alert,
  TouchableOpacity,
  RefreshControl,
  TextInput
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import AsyncStorage from '@react-native-async-storage/async-storage';

interface Product {
  id: number;
  name: string;
  sku?: string;
  category?: string;
  brand?: string;
  is_active: boolean;
}

const DebugProductsScreen: React.FC<{ navigation: any }> = ({ navigation }) => {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [refreshing, setRefreshing] = useState(false);
  const [debugInfo, setDebugInfo] = useState<string[]>([]);
  
  // Estados para búsqueda
  const [searchText, setSearchText] = useState('');
  const [searchFilter, setSearchFilter] = useState<'all' | 'sku' | 'name' | 'category' | 'brand'>('all');

  // Productos filtrados usando useMemo para optimización
  const filteredProducts = useMemo(() => {
    if (!searchText.trim()) {
      return products;
    }

    const searchLower = searchText.toLowerCase().trim();
    
    return products.filter(product => {
      switch (searchFilter) {
        case 'sku':
          return product.sku?.toLowerCase().includes(searchLower);
        case 'name':
          return product.name?.toLowerCase().includes(searchLower);
        case 'category':
          return product.category?.toLowerCase().includes(searchLower);
        case 'brand':
          return product.brand?.toLowerCase().includes(searchLower);
        case 'all':
        default:
          return (
            product.name?.toLowerCase().includes(searchLower) ||
            product.sku?.toLowerCase().includes(searchLower) ||
            product.category?.toLowerCase().includes(searchLower) ||
            product.brand?.toLowerCase().includes(searchLower)
          );
      }
    });
  }, [products, searchText, searchFilter]);

  const addDebugInfo = (info: string) => {
    setDebugInfo(prev => [...prev, `${new Date().toLocaleTimeString()}: ${info}`]);
    console.log(info);
  };

  useEffect(() => {
    loadProducts();
  }, []);

  const loadProducts = async () => {
    try {
      setLoading(true);
      setError(null);
      addDebugInfo('🔄 Iniciando carga de productos...');

      // Verificar si hay token
      const token = await AsyncStorage.getItem('token');
      addDebugInfo(`🔑 Token encontrado: ${token ? 'SÍ' : 'NO'}`);

      if (!token) {
        // Intentar login automático
        addDebugInfo('🔐 Intentando login automático...');
        const loginSuccess = await autoLogin();
        if (!loginSuccess) {
          throw new Error('No se pudo hacer login automático');
        }
      }

      // Hacer petición a productos (cargar más productos para la búsqueda)
      const finalToken = await AsyncStorage.getItem('token');
      addDebugInfo('🌐 Haciendo petición al API...');
      
      const response = await fetch('http://localhost:8000/api/v1/products?limit=100', {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${finalToken}`
        }
      });

      addDebugInfo(`📡 Respuesta del API: ${response.status} ${response.statusText}`);

      if (!response.ok) {
        const errorText = await response.text();
        addDebugInfo(`❌ Error del API: ${errorText}`);
        throw new Error(`HTTP ${response.status}: ${errorText}`);
      }

      const data = await response.json();
      addDebugInfo(`✅ Productos recibidos: ${data.length}`);
      
      setProducts(data);
      
    } catch (error: any) {
      const errorMsg = error.message || 'Error desconocido';
      addDebugInfo(`❌ Error: ${errorMsg}`);
      setError(errorMsg);
      Alert.alert('Error', errorMsg);
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  const autoLogin = async (): Promise<boolean> => {
    try {
      addDebugInfo('🔐 Haciendo login con admin@maestro.com...');
      
      const response = await fetch('http://localhost:8000/api/v1/auth/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          email: 'admin@maestro.com',
          password: 'admin123'
        })
      });

      if (response.ok) {
        const data = await response.json();
        await AsyncStorage.setItem('token', data.access_token);
        addDebugInfo('✅ Login exitoso, token guardado');
        return true;
      } else {
        const errorText = await response.text();
        addDebugInfo(`❌ Error en login: ${response.status} - ${errorText}`);
        return false;
      }
    } catch (error: any) {
      addDebugInfo(`❌ Error de red en login: ${error.message}`);
      return false;
    }
  };

  const onRefresh = () => {
    setRefreshing(true);
    setDebugInfo([]);
    loadProducts();
  };

  const renderSearchBar = () => (
    <View style={styles.searchContainer}>
      {/* Campo de búsqueda */}
      <View style={styles.searchInputContainer}>
        <Text style={styles.searchIcon}>🔍</Text>
        <TextInput
          style={styles.searchInput}
          placeholder="Buscar productos..."
          value={searchText}
          onChangeText={setSearchText}
          placeholderTextColor="#999"
        />
        {searchText.length > 0 && (
          <TouchableOpacity onPress={() => setSearchText('')} style={styles.clearButton}>
            <Text style={styles.clearButtonText}>✖</Text>
          </TouchableOpacity>
        )}
      </View>
      
      {/* Filtros de búsqueda */}
      <View style={styles.filterContainer}>
        {[
          { key: 'all', label: 'Todo', icon: '🔍' },
          { key: 'sku', label: 'SKU', icon: '🏷️' },
          { key: 'name', label: 'Nombre', icon: '📝' },
          { key: 'category', label: 'Categoría', icon: '📂' },
          { key: 'brand', label: 'Marca', icon: '🏢' }
        ].map((filter) => (
          <TouchableOpacity
            key={filter.key}
            style={[
              styles.filterButton,
              searchFilter === filter.key && styles.filterButtonActive
            ]}
            onPress={() => setSearchFilter(filter.key as any)}
          >
            <Text style={styles.filterIcon}>{filter.icon}</Text>
            <Text style={[
              styles.filterText,
              searchFilter === filter.key && styles.filterTextActive
            ]}>
              {filter.label}
            </Text>
          </TouchableOpacity>
        ))}
      </View>
    </View>
  );

  const renderProduct = ({ item }: { item: Product }) => (
    <View style={styles.productCard}>
      <Text style={styles.productName}>{item.name || 'Sin nombre'}</Text>
      <Text style={styles.productInfo}>SKU: {item.sku || 'N/A'}</Text>
      <Text style={styles.productInfo}>Categoría: {item.category || 'Sin categoría'}</Text>
      <Text style={styles.productInfo}>Marca: {item.brand || 'Sin marca'}</Text>
      <Text style={[styles.productStatus, { color: item.is_active ? 'green' : 'red' }]}>
        {item.is_active ? '✅ Activo' : '❌ Inactivo'}
      </Text>
    </View>
  );

  const renderDebugInfo = () => (
    <View style={styles.debugContainer}>
      <Text style={styles.debugTitle}>🔍 Debug Info:</Text>
      {debugInfo.slice(-5).map((info, index) => (
        <Text key={index} style={styles.debugText}>{info}</Text>
      ))}
    </View>
  );

  if (loading && !refreshing) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color="#0000ff" />
          <Text style={styles.loadingText}>Cargando productos...</Text>
          {renderDebugInfo()}
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>🔧 Debug - Productos</Text>
        <TouchableOpacity style={styles.refreshButton} onPress={onRefresh}>
          <Text style={styles.refreshButtonText}>🔄</Text>
        </TouchableOpacity>
      </View>

      {/* Barra de búsqueda */}
      {renderSearchBar()}

      {/* Debug Info */}
      {renderDebugInfo()}

      {/* Error */}
      {error && (
        <View style={styles.errorContainer}>
          <Text style={styles.errorText}>❌ {error}</Text>
        </View>
      )}

      {/* Stats */}
      <View style={styles.statsContainer}>
        <Text style={styles.statsText}>
          📊 Total: {products.length} | Filtrados: {filteredProducts.length} | Activos: {filteredProducts.filter(p => p.is_active).length}
        </Text>
        {searchText && (
          <Text style={styles.searchResultText}>
            🔍 Búsqueda: "{searchText}" en {searchFilter === 'all' ? 'todos los campos' : searchFilter}
          </Text>
        )}
      </View>

      {/* Products List */}
      <FlatList
        data={filteredProducts}
        renderItem={renderProduct}
        keyExtractor={(item) => item.id.toString()}
        contentContainerStyle={styles.listContainer}
        refreshControl={
          <RefreshControl
            refreshing={refreshing}
            onRefresh={onRefresh}
          />
        }
        ListEmptyComponent={
          <View style={styles.emptyContainer}>
            <Text style={styles.emptyText}>
              {error ? '❌ Error al cargar' : searchText ? '🔍 No se encontraron productos' : '📦 No hay productos'}
            </Text>
            {searchText && (
              <TouchableOpacity onPress={() => setSearchText('')} style={styles.clearSearchButton}>
                <Text style={styles.clearSearchButtonText}>Limpiar búsqueda</Text>
              </TouchableOpacity>
            )}
          </View>
        }
      />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  loadingText: {
    marginTop: 10,
    fontSize: 16,
    color: '#666',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 16,
    backgroundColor: 'white',
    borderBottomWidth: 1,
    borderBottomColor: '#ddd',
  },
  headerTitle: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  refreshButton: {
    padding: 8,
  },
  refreshButtonText: {
    fontSize: 20,
  },
  // Estilos para búsqueda
  searchContainer: {
    backgroundColor: 'white',
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#ddd',
  },
  searchInputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#f8f9fa',
    borderRadius: 8,
    paddingHorizontal: 12,
    marginBottom: 12,
  },
  searchIcon: {
    fontSize: 16,
    marginRight: 8,
    color: '#666',
  },
  searchInput: {
    flex: 1,
    paddingVertical: 12,
    fontSize: 16,
    color: '#333',
  },
  clearButton: {
    padding: 4,
  },
  clearButtonText: {
    fontSize: 14,
    color: '#666',
  },
  filterContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
  },
  filterButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#f8f9fa',
    paddingHorizontal: 12,
    paddingVertical: 6,
    marginRight: 8,
    marginBottom: 8,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: '#ddd',
  },
  filterButtonActive: {
    backgroundColor: '#007bff',
    borderColor: '#007bff',
  },
  filterIcon: {
    fontSize: 12,
    marginRight: 4,
  },
  filterText: {
    fontSize: 12,
    color: '#666',
  },
  filterTextActive: {
    color: 'white',
  },
  debugContainer: {
    backgroundColor: '#f8f9fa',
    padding: 12,
    margin: 16,
    borderRadius: 4,
    borderLeftWidth: 4,
    borderLeftColor: '#007bff',
  },
  debugTitle: {
    fontWeight: 'bold',
    marginBottom: 4,
  },
  debugText: {
    fontSize: 12,
    color: '#666',
    fontFamily: 'monospace',
  },
  errorContainer: {
    backgroundColor: '#f8d7da',
    padding: 12,
    margin: 16,
    borderRadius: 4,
  },
  errorText: {
    color: '#721c24',
    textAlign: 'center',
  },
  statsContainer: {
    backgroundColor: 'white',
    padding: 12,
    marginHorizontal: 16,
    borderRadius: 4,
  },
  statsText: {
    textAlign: 'center',
    fontWeight: 'bold',
  },
  searchResultText: {
    textAlign: 'center',
    fontSize: 12,
    color: '#666',
    marginTop: 4,
  },
  listContainer: {
    padding: 16,
  },
  productCard: {
    backgroundColor: 'white',
    padding: 16,
    marginBottom: 12,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#ddd',
  },
  productName: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  productInfo: {
    fontSize: 14,
    color: '#666',
    marginBottom: 2,
  },
  productStatus: {
    fontSize: 14,
    fontWeight: 'bold',
    marginTop: 4,
  },
  emptyContainer: {
    padding: 32,
    alignItems: 'center',
  },
  emptyText: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
    marginBottom: 16,
  },
  clearSearchButton: {
    backgroundColor: '#007bff',
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 6,
  },
  clearSearchButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
});

export default DebugProductsScreen;
