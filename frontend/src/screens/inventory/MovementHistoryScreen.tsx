import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  RefreshControl,
  ActivityIndicator,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import Icon from 'react-native-vector-icons/MaterialIcons';
import { apiService } from '../../services/apiService';

interface Movement {
  id: number;
  movement_type: 'entry' | 'exit' | 'adjustment' | 'transfer';
  warehouse_name: string;
  product_name: string;
  category: string;
  brand: string;
  quantity: number;
  unit_symbol: string;
  reference_number?: string;
  reason?: string;
  created_at: string;
  user_name: string;
  total_value: number;
}

const MovementHistoryScreen: React.FC<{ navigation: any }> = ({ navigation }) => {
  const [movements, setMovements] = useState<Movement[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  useEffect(() => {
    loadMovements();
  }, []);

  const loadMovements = async () => {
    try {
      // Cargar movimientos del backend usando el servicio API
      const data = await apiService.getInventoryMovements();
      console.log('Movimientos cargados del backend:', data);
      
      // Transformar datos del backend al formato esperado
      const transformedMovements: Movement[] = data.map((movement: any) => ({
        id: movement.id,
        movement_type: movement.movement_type,
        warehouse_name: movement.warehouse_name || 'Almacén Principal',
        product_name: movement.product_name,
        category: movement.category,
        brand: movement.brand,
        quantity: movement.quantity,
        unit_symbol: movement.unit_symbol,
        reference_number: movement.reference_number,
        reason: movement.reason,
        created_at: movement.created_at,
        user_name: movement.user_name || 'Usuario',
        total_value: movement.total_value || 0
      }));
      
      setMovements(transformedMovements);
    } catch (error) {
      console.error('Error loading movements:', error);
      
      // Fallback a datos mock en caso de error
      const mockMovements: Movement[] = [
        {
          id: 1,
          movement_type: 'entry',
          warehouse_name: 'Almacén Principal',
          product_name: 'Galaxy S24 Ultra (Negro, 256GB)',
          category: 'Smartphones',
          brand: 'Samsung',
          quantity: 3,
          unit_symbol: 'UND',
          reference_number: 'ENT-001',
          reason: 'Compra de mercadería (datos de ejemplo)',
          created_at: new Date().toISOString(),
          user_name: 'Admin Maestro',
          total_value: 1500.50
        }
      ];
      setMovements(mockMovements);
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  const onRefresh = () => {
    setRefreshing(true);
    loadMovements();
  };

  const getMovementIcon = (type: string) => {
    switch (type) {
      case 'entry': return 'arrow-downward';
      case 'exit': return 'arrow-upward';
      case 'adjustment': return 'tune';
      case 'transfer': return 'swap-horiz';
      default: return 'inventory';
    }
  };

  const getMovementColor = (type: string) => {
    switch (type) {
      case 'entry': return '#28a745';
      case 'exit': return '#dc3545';
      case 'adjustment': return '#ffc107';
      case 'transfer': return '#007bff';
      default: return '#6c757d';
    }
  };

  const getMovementText = (type: string) => {
    switch (type) {
      case 'entry': return 'Entrada';
      case 'exit': return 'Salida';
      case 'adjustment': return 'Ajuste';
      case 'transfer': return 'Transferencia';
      default: return 'Movimiento';
    }
  };

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('es-ES', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('es-ES', {
      style: 'currency',
      currency: 'EUR',
      minimumFractionDigits: 2
    }).format(amount);
  };

  const renderMovementItem = (movement: Movement) => (
    <TouchableOpacity
      key={movement.id}
      style={styles.movementCard}
      onPress={() => {
        // Navegar a detalles del movimiento
        console.log('Ver detalles del movimiento:', movement.id);
      }}
    >
      <View style={styles.movementHeader}>
        <View style={styles.movementType}>
          <Icon
            name={getMovementIcon(movement.movement_type)}
            size={24}
            color={getMovementColor(movement.movement_type)}
          />
          <Text style={[styles.typeText, { color: getMovementColor(movement.movement_type) }]}>
            {getMovementText(movement.movement_type)}
          </Text>
        </View>
        <Text style={styles.dateText}>
          {formatDate(movement.created_at)}
        </Text>
      </View>

      <View style={styles.movementDetails}>
        <Text style={styles.productText}>📱 {movement.product_name}</Text>
        <Text style={styles.categoryBrandText}>🏷️ {movement.category} • {movement.brand}</Text>
        <Text style={styles.warehouseText}>📦 {movement.warehouse_name}</Text>
        
        {movement.reference_number && (
          <Text style={styles.referenceText}>📋 {movement.reference_number}</Text>
        )}
        
        <View style={styles.statsRow}>
          <Text style={styles.quantityText}>
            📊 {movement.quantity} {movement.unit_symbol}
          </Text>
          <Text style={styles.valueText}>
            💰 {formatCurrency(movement.total_value)}
          </Text>
        </View>

        {movement.reason && (
          <Text style={styles.reasonText} numberOfLines={1}>
            💭 {movement.reason}
          </Text>
        )}

        <Text style={styles.userText}>👤 {movement.user_name}</Text>
      </View>
    </TouchableOpacity>
  );

  if (loading) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color="#007bff" />
          <Text style={styles.loadingText}>Cargando historial...</Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity
          style={styles.backButton}
          onPress={() => navigation.goBack()}
        >
          <Icon name="arrow-back" size={24} color="#333" />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>Historial de Movimientos</Text>
        <TouchableOpacity
          style={styles.refreshButton}
          onPress={onRefresh}
        >
          <Icon name="refresh" size={24} color="#007bff" />
        </TouchableOpacity>
      </View>

      {/* Summary */}
      <View style={styles.summary}>
        <Text style={styles.summaryText}>
          📊 Total: {movements.length} movimiento{movements.length !== 1 ? 's' : ''}
        </Text>
      </View>

      {/* Movements List */}
      <ScrollView
        style={styles.scrollView}
        showsVerticalScrollIndicator={false}
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
        }
      >
        {movements.length === 0 ? (
          <View style={styles.emptyContainer}>
            <Icon name="inventory" size={64} color="#ccc" />
            <Text style={styles.emptyText}>No hay movimientos registrados</Text>
            <Text style={styles.emptySubtext}>
              Los movimientos que realices aparecerán aquí
            </Text>
          </View>
        ) : (
          movements.map(renderMovementItem)
        )}

        <View style={styles.bottomSpace} />
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f8f9fa',
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  loadingText: {
    marginTop: 16,
    fontSize: 16,
    color: '#666',
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    paddingVertical: 12,
    backgroundColor: '#fff',
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  backButton: {
    padding: 8,
  },
  headerTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#333',
    flex: 1,
    textAlign: 'center',
  },
  refreshButton: {
    padding: 8,
  },
  summary: {
    backgroundColor: '#fff',
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  summaryText: {
    fontSize: 14,
    color: '#666',
    textAlign: 'center',
  },
  scrollView: {
    flex: 1,
    padding: 16,
  },
  movementCard: {
    backgroundColor: '#fff',
    borderRadius: 12,
    padding: 16,
    marginBottom: 12,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  movementHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
  },
  movementType: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  typeText: {
    fontSize: 16,
    fontWeight: 'bold',
    marginLeft: 8,
  },
  dateText: {
    fontSize: 12,
    color: '#666',
  },
  movementDetails: {
    gap: 6,
  },
  warehouseText: {
    fontSize: 14,
    color: '#333',
    fontWeight: '500',
  },
  productText: {
    fontSize: 15,
    color: '#333',
    fontWeight: 'bold',
    marginBottom: 2,
  },
  categoryBrandText: {
    fontSize: 13,
    color: '#666',
    marginBottom: 4,
  },
  referenceText: {
    fontSize: 14,
    color: '#666',
  },
  statsRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  quantityText: {
    fontSize: 14,
    color: '#666',
    fontWeight: '500',
  },
  valueText: {
    fontSize: 14,
    fontWeight: 'bold',
    color: '#28a745',
  },
  reasonText: {
    fontSize: 14,
    color: '#666',
    fontStyle: 'italic',
  },
  userText: {
    fontSize: 12,
    color: '#999',
    textAlign: 'right',
  },
  emptyContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingVertical: 64,
  },
  emptyText: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#999',
    marginTop: 16,
    textAlign: 'center',
  },
  emptySubtext: {
    fontSize: 14,
    color: '#ccc',
    marginTop: 8,
    textAlign: 'center',
  },
  bottomSpace: {
    height: 32,
  },
});

export default MovementHistoryScreen;
