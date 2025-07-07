import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  ActivityIndicator,
  Alert,
  TextInput,
  TouchableOpacity,
  ScrollView
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { useTranslation } from 'react-i18next';
import AsyncStorage from '@react-native-async-storage/async-storage';

interface Product {
  id: number;
  name: string;
  sku: string;
  category?: string;
  brand?: string;
  stock?: number;
  minStock?: number;
  price?: number;
  is_active: boolean;
}

export default function ProductCatalogSimpleScreen({ navigation }: any) {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [searchText, setSearchText] = useState('');
  const { t } = useTranslation();

  useEffect(() => {
    loadProducts();
  }, []);

  const loadProducts = async () => {
    try {
      setLoading(true);
      setError(null);

      // Verificar si hay token
      const token = await AsyncStorage.getItem('token');

      if (!token) {
        // Intentar login automático
        const loginSuccess = await autoLogin();
        if (!loginSuccess) {
          throw new Error('No se pudo hacer login automático');
        }
      }

      // Hacer petición a productos
      const finalToken = await AsyncStorage.getItem('token');
      
      const response = await fetch('http://localhost:8000/api/v1/products?limit=50', {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${finalToken}`
        }
      });

      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`HTTP ${response.status}: ${errorText}`);
      }

      const data = await response.json();
      setProducts(data);
      
    } catch (error: any) {
      const errorMsg = error.message || 'Error desconocido';
      setError(errorMsg);
      Alert.alert('Error', errorMsg);
    } finally {
      setLoading(false);
    }
  };

  const autoLogin = async (): Promise<boolean> => {
    try {
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
        return true;
      } else {
        return false;
      }
    } catch (error: any) {
      return false;
    }
  };

  const filteredProducts = products.filter(product =>
    product.name.toLowerCase().includes(searchText.toLowerCase()) ||
    product.sku.toLowerCase().includes(searchText.toLowerCase()) ||
    (product.category && product.category.toLowerCase().includes(searchText.toLowerCase())) ||
    (product.brand && product.brand.toLowerCase().includes(searchText.toLowerCase()))
  );

  const getStockColor = (stock: number, minStock: number) => {
    if (stock === 0) return '#dc3545'; // Rojo sin stock
    if (stock <= minStock) return '#ffc107'; // Amarillo stock bajo
    return '#28a745'; // Verde stock normal
  };

  const getStockIcon = (stock: number, minStock: number) => {
    if (stock === 0) return 'alert-circle';
    if (stock <= minStock) return 'warning';
    return 'checkmark-circle';
  };

  const renderProduct = ({ item }: { item: Product }) => (
    <TouchableOpacity style={styles.productCard} onPress={() => {
      // Navegar al detalle del producto
      navigation.navigate('ProductDetail', { productId: item.id });
    }}>
      <View style={styles.productHeader}>
        <Text style={styles.productName} numberOfLines={2}>{item.name}</Text>
        <Text style={styles.productSku}>SKU: {item.sku}</Text>
      </View>
      
      <View style={styles.productDetails}>
        <View style={styles.productInfo}>
          <Text style={styles.productCategory}>
            📂 {item.category || 'Sin categoría'}
          </Text>
          <Text style={styles.productBrand}>
            🏢 {item.brand || 'Sin marca'}
          </Text>
        </View>
        
        {item.stock !== undefined && item.minStock !== undefined && (
          <View style={styles.stockInfo}>
            <Ionicons 
              name={getStockIcon(item.stock, item.minStock)} 
              size={16} 
              color={getStockColor(item.stock, item.minStock)} 
            />
            <Text style={[styles.stockText, { color: getStockColor(item.stock, item.minStock) }]}>
              Stock: {item.stock}
            </Text>
          </View>
        )}
        
        {item.price && (
          <Text style={styles.productPrice}>
            💰 ${item.price.toFixed(2)}
          </Text>
        )}
      </View>
      
      <View style={styles.productStatus}>
        <Text style={[styles.statusText, { color: item.is_active ? '#28a745' : '#dc3545' }]}>
          {item.is_active ? '✅ Activo' : '❌ Inactivo'}
        </Text>
      </View>
    </TouchableOpacity>
  );

  if (loading) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color="#0000ff" />
          <Text style={styles.loadingText}>Cargando productos...</Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>📦 Catálogo de Productos</Text>
        <TouchableOpacity style={styles.refreshButton} onPress={loadProducts}>
          <Ionicons name="refresh" size={24} color="#007bff" />
        </TouchableOpacity>
      </View>

      {/* Search Bar */}
      <View style={styles.searchContainer}>
        <View style={styles.searchInputContainer}>
          <Ionicons name="search" size={20} color="#666" style={styles.searchIcon} />
          <TextInput
            style={styles.searchInput}
            placeholder="Buscar por nombre, SKU, categoría o marca..."
            value={searchText}
            onChangeText={setSearchText}
            placeholderTextColor="#999"
          />
          {searchText.length > 0 && (
            <TouchableOpacity onPress={() => setSearchText('')} style={styles.clearButton}>
              <Ionicons name="close-circle" size={20} color="#666" />
            </TouchableOpacity>
          )}
        </View>
      </View>

      {/* Stats */}
      <View style={styles.statsContainer}>
        <Text style={styles.statsText}>
          📊 Total: {products.length} | Mostrados: {filteredProducts.length}
        </Text>
        {searchText && (
          <Text style={styles.searchResultText}>
            🔍 Búsqueda: "{searchText}"
          </Text>
        )}
      </View>

      {/* Error */}
      {error && (
        <View style={styles.errorContainer}>
          <Text style={styles.errorText}>❌ {error}</Text>
          <TouchableOpacity style={styles.retryButton} onPress={loadProducts}>
            <Text style={styles.retryButtonText}>Reintentar</Text>
          </TouchableOpacity>
        </View>
      )}

      {/* Products List */}
      <FlatList
        data={filteredProducts}
        renderItem={renderProduct}
        keyExtractor={(item) => item.id.toString()}
        contentContainerStyle={styles.listContainer}
        showsVerticalScrollIndicator={false}
        ListEmptyComponent={
          <View style={styles.emptyContainer}>
            <Text style={styles.emptyText}>
              {error ? '❌ Error al cargar productos' : 
               searchText ? '🔍 No se encontraron productos' : 
               '📦 No hay productos disponibles'}
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
}

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
    color: '#333',
  },
  refreshButton: {
    padding: 8,
  },
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
  },
  searchIcon: {
    marginRight: 8,
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
  statsContainer: {
    backgroundColor: 'white',
    padding: 12,
    marginHorizontal: 16,
    marginTop: 8,
    borderRadius: 4,
  },
  statsText: {
    textAlign: 'center',
    fontWeight: 'bold',
    color: '#333',
  },
  searchResultText: {
    textAlign: 'center',
    fontSize: 12,
    color: '#666',
    marginTop: 4,
  },
  errorContainer: {
    backgroundColor: '#f8d7da',
    padding: 16,
    margin: 16,
    borderRadius: 8,
    alignItems: 'center',
  },
  errorText: {
    color: '#721c24',
    textAlign: 'center',
    marginBottom: 8,
  },
  retryButton: {
    backgroundColor: '#dc3545',
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 4,
  },
  retryButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  listContainer: {
    padding: 16,
  },
  productCard: {
    backgroundColor: 'white',
    padding: 16,
    marginBottom: 12,
    borderRadius: 12,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 3.84,
    elevation: 5,
  },
  productHeader: {
    marginBottom: 8,
  },
  productName: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 4,
  },
  productSku: {
    fontSize: 12,
    color: '#666',
    fontFamily: 'monospace',
  },
  productDetails: {
    marginBottom: 8,
  },
  productInfo: {
    marginBottom: 4,
  },
  productCategory: {
    fontSize: 14,
    color: '#666',
    marginBottom: 2,
  },
  productBrand: {
    fontSize: 14,
    color: '#666',
    marginBottom: 4,
  },
  stockInfo: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 4,
  },
  stockText: {
    fontSize: 14,
    fontWeight: 'bold',
    marginLeft: 4,
  },
  productPrice: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#28a745',
  },
  productStatus: {
    alignItems: 'flex-end',
  },
  statusText: {
    fontSize: 12,
    fontWeight: 'bold',
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
