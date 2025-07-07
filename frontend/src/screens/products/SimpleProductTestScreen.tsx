import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  ActivityIndicator,
  Alert,
  TouchableOpacity,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { apiService } from '../../services/apiService';

interface SimpleProduct {
  id: number;
  name: string;
  sku?: string;
  category?: string;
  brand?: string;
  is_active: boolean;
}

const SimpleProductTestScreen: React.FC = () => {
  const [products, setProducts] = useState<SimpleProduct[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    loadProducts();
  }, []);

  const loadProducts = async () => {
    try {
      setLoading(true);
      setError(null);
      console.log('Cargando productos...');
      
      const response = await apiService.get('/products', {
        params: { limit: 10 }
      });
      
      console.log('Respuesta del API:', response.data);
      setProducts(response.data || []);
      
    } catch (error: any) {
      console.error('Error loading products:', error);
      setError(error.message || 'Error desconocido');
      Alert.alert('Error', `Error al cargar productos: ${error.message}`);
    } finally {
      setLoading(false);
    }
  };

  const renderProduct = ({ item }: { item: SimpleProduct }) => (
    <View style={styles.productCard}>
      <Text style={styles.productName}>{item.name || 'Sin nombre'}</Text>
      <Text style={styles.productSku}>SKU: {item.sku || 'N/A'}</Text>
      <Text style={styles.productCategory}>Categoría: {item.category || 'Sin categoría'}</Text>
      <Text style={styles.productBrand}>Marca: {item.brand || 'Sin marca'}</Text>
      <Text style={[styles.productStatus, { color: item.is_active ? 'green' : 'red' }]}>
        {item.is_active ? 'Activo' : 'Inactivo'}
      </Text>
    </View>
  );

  if (loading) {
    return (
      <SafeAreaView style={styles.container}>
        <ActivityIndicator size="large" color="#0000ff" />
        <Text style={styles.loadingText}>Cargando productos...</Text>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Prueba de Productos</Text>
        <TouchableOpacity style={styles.refreshButton} onPress={loadProducts}>
          <Text style={styles.refreshButtonText}>🔄 Recargar</Text>
        </TouchableOpacity>
      </View>

      {error && (
        <View style={styles.errorContainer}>
          <Text style={styles.errorText}>❌ Error: {error}</Text>
        </View>
      )}

      <View style={styles.statsContainer}>
        <Text style={styles.statsText}>Total productos: {products.length}</Text>
      </View>

      <FlatList
        data={products}
        renderItem={renderProduct}
        keyExtractor={(item) => item.id.toString()}
        contentContainerStyle={styles.listContainer}
        ListEmptyComponent={
          <View style={styles.emptyContainer}>
            <Text style={styles.emptyText}>
              {error ? 'Error al cargar productos' : 'No hay productos disponibles'}
            </Text>
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
    fontSize: 20,
    fontWeight: 'bold',
  },
  refreshButton: {
    backgroundColor: '#007bff',
    padding: 8,
    borderRadius: 4,
  },
  refreshButtonText: {
    color: 'white',
    fontSize: 14,
  },
  loadingText: {
    textAlign: 'center',
    marginTop: 10,
    fontSize: 16,
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
    margin: 16,
    borderRadius: 4,
  },
  statsText: {
    fontSize: 16,
    fontWeight: 'bold',
    textAlign: 'center',
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
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  productSku: {
    fontSize: 14,
    color: '#666',
    marginBottom: 2,
  },
  productCategory: {
    fontSize: 14,
    color: '#666',
    marginBottom: 2,
  },
  productBrand: {
    fontSize: 14,
    color: '#666',
    marginBottom: 2,
  },
  productStatus: {
    fontSize: 14,
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
  },
});

export default SimpleProductTestScreen;
