import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TextInput,
  TouchableOpacity,
  Alert,
  ActivityIndicator,
  Modal,
  Animated,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { theme } from '../../styles/theme';
import { useTranslation } from 'react-i18next';
import { apiService } from '../../services/apiService';

interface Product {
  id: number;
  name: string;
  sku?: string;
  current_stock: number;
  variants: Array<{
    id: number;
    attributes?: any;
    current_stock: number;
  }>;
}

interface Warehouse {
  id: number;
  name: string;
  code: string;
  is_active: boolean;
}

interface Unit {
  id: number;
  name: string;
  symbol: string;
}

interface MovementFormData {
  warehouse_id: number | null;
  product_variant_id: number | null;
  unit_id: number | null;
  quantity: number;
  reason?: string;
  notes?: string;
  // Campos específicos para entrada
  cost_per_unit?: number;
  supplier_id?: number;
  expiry_date?: string;
  batch_number?: string;
  // Campos específicos para salida
  customer_id?: number;
  destination_warehouse_id?: number;
  // Campos específicos para ajuste
  current_quantity?: number;
  actual_quantity?: number;
  adjustment_type?: string;
}

interface InventoryMovementFormScreenProps {
  navigation: any;
  route: {
    params: {
      movementType: 'entry' | 'exit' | 'adjustment' | 'transfer';
    };
  };
}

const InventoryMovementFormScreen: React.FC<InventoryMovementFormScreenProps> = ({ 
  navigation, 
  route 
}) => {
  const { t } = useTranslation();
  const { movementType } = route.params;
  
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [warehouses, setWarehouses] = useState<Warehouse[]>([]);
  const [products, setProducts] = useState<Product[]>([]);
  const [units, setUnits] = useState<Unit[]>([]);
  
  const [formData, setFormData] = useState<MovementFormData>({
    warehouse_id: null,
    product_variant_id: null,
    unit_id: null,
    quantity: 0,
  });

  const [showWarehouseSelector, setShowWarehouseSelector] = useState(false);
  const [showProductSelector, setShowProductSelector] = useState(false);
  const [showUnitSelector, setShowUnitSelector] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');

  // Notificación de éxito
  const [showSuccessNotification, setShowSuccessNotification] = useState(false);
  const [successAnimation] = useState(new Animated.Value(0));
  const [successMessage, setSuccessMessage] = useState('');

  useEffect(() => {
    loadInitialData();
  }, []);

  const showSuccessMessage = (message: string) => {
    setSuccessMessage(message);
    setShowSuccessNotification(true);
    
    // Animar entrada
    Animated.sequence([
      Animated.timing(successAnimation, {
        toValue: 1,
        duration: 300,
        useNativeDriver: true,
      }),
      Animated.delay(2500), // Mostrar por 2.5 segundos
      Animated.timing(successAnimation, {
        toValue: 0,
        duration: 300,
        useNativeDriver: true,
      }),
    ]).start(() => {
      setShowSuccessNotification(false);
      // Navegar al Dashboard después de la animación
      setTimeout(() => {
        navigation.navigate('Dashboard');
      }, 100);
    });
  };

  const loadInitialData = async () => {
    setLoading(true);
    try {
      await Promise.all([
        loadWarehouses(),
        loadProducts(),
        loadUnits(),
      ]);
    } catch (error) {
      console.error('Error loading initial data:', error);
      Alert.alert(t('common.error'), t('common.loadDataError'));
    } finally {
      setLoading(false);
    }
  };

  const loadWarehouses = async () => {
    try {
      const response = await apiService.get('/warehouses', {
        params: { status: 'active' }
      });
      setWarehouses(response.data);
    } catch (error) {
      console.error('Error loading warehouses:', error);
    }
  };

  const loadProducts = async () => {
    try {
      const response = await apiService.get('/inventory/products', {
        params: { 
          search: searchQuery,
          status: 'active',
          limit: 50 
        }
      });
      setProducts(response.data);
    } catch (error) {
      console.error('Error loading products:', error);
    }
  };

  const loadUnits = async () => {
    try {
      const response = await apiService.get('/units');
      setUnits(response.data);
    } catch (error) {
      console.error('Error loading units:', error);
    }
  };

  const getMovementTitle = () => {
    switch (movementType) {
      case 'entry':
        return t('inventory.movements.entry');
      case 'exit':
        return t('inventory.movements.exit');
      case 'adjustment':
        return t('inventory.movements.adjustment');
      case 'transfer':
        return t('inventory.movements.transfer');
      default:
        return t('inventory.movements.movement');
    }
  };

  const getMovementIcon = () => {
    switch (movementType) {
      case 'entry':
        return 'arrow-down-circle';
      case 'exit':
        return 'arrow-up-circle';
      case 'adjustment':
        return 'sync-circle';
      case 'transfer':
        return 'swap-horizontal';
      default:
        return 'document';
    }
  };

  const getMovementColor = () => {
    switch (movementType) {
      case 'entry':
        return theme.colors.success;
      case 'exit':
        return theme.colors.warning;
      case 'adjustment':
        return theme.colors.primary;
      case 'transfer':
        return theme.colors.primary;
      default:
        return theme.colors.textSecondary;
    }
  };

  const validateForm = () => {
    if (!formData.warehouse_id) {
      Alert.alert(t('common.error'), t('inventory.errors.warehouseRequired'));
      return false;
    }

    if (!formData.product_variant_id) {
      Alert.alert(t('common.error'), t('inventory.errors.productRequired'));
      return false;
    }

    if (!formData.unit_id) {
      Alert.alert(t('common.error'), t('inventory.errors.unitRequired'));
      return false;
    }

    if (formData.quantity <= 0) {
      Alert.alert(t('common.error'), t('inventory.errors.quantityRequired'));
      return false;
    }

    // Validaciones específicas por tipo de movimiento
    if (movementType === 'transfer' && !formData.destination_warehouse_id) {
      Alert.alert(t('common.error'), t('inventory.errors.destinationWarehouseRequired'));
      return false;
    }

    if (movementType === 'transfer' && formData.warehouse_id === formData.destination_warehouse_id) {
      Alert.alert(t('common.error'), t('inventory.errors.sameWarehouseTransfer'));
      return false;
    }

    return true;
  };

  const submitMovement = async () => {
    if (!validateForm()) return;

    setSaving(true);
    try {
      let endpoint = '';
      let payload = {};

      switch (movementType) {
        case 'entry':
          endpoint = '/inventory/movements/entry';
          payload = {
            warehouse_id: formData.warehouse_id,
            product_variant_id: formData.product_variant_id,
            unit_id: formData.unit_id,
            quantity: formData.quantity,
            cost_per_unit: formData.cost_per_unit,
            supplier_id: formData.supplier_id,
            expiry_date: formData.expiry_date,
            batch_number: formData.batch_number,
            reason: formData.reason,
            notes: formData.notes,
          };
          break;

        case 'exit':
          endpoint = '/inventory/movements/exit';
          payload = {
            warehouse_id: formData.warehouse_id,
            product_variant_id: formData.product_variant_id,
            unit_id: formData.unit_id,
            quantity: formData.quantity,
            customer_id: formData.customer_id,
            reason: formData.reason,
            notes: formData.notes,
          };
          break;

        case 'adjustment':
          endpoint = '/inventory/movements/adjustment';
          payload = {
            warehouse_id: formData.warehouse_id,
            product_variant_id: formData.product_variant_id,
            unit_id: formData.unit_id,
            current_quantity: formData.current_quantity,
            actual_quantity: formData.actual_quantity,
            adjustment_type: formData.adjustment_type || 'physical_count',
            unit_cost: formData.cost_per_unit,
            reason: formData.reason,
            notes: formData.notes,
          };
          break;

        case 'transfer':
          endpoint = '/inventory/movements/transfer';
          payload = {
            source_warehouse_id: formData.warehouse_id,
            destination_warehouse_id: formData.destination_warehouse_id,
            product_variant_id: formData.product_variant_id,
            unit_id: formData.unit_id,
            quantity: formData.quantity,
            reason: formData.reason,
            notes: formData.notes,
          };
          break;
      }

      await apiService.post(endpoint, payload);
      
      // Mostrar notificación visual de éxito
      const movementTypeText = movementType === 'entry' ? 'Entrada' : 
                              movementType === 'exit' ? 'Salida' : 
                              movementType === 'adjustment' ? 'Ajuste' : 'Movimiento';
      
      Alert.alert(
        '🎉 ¡Éxito!',
        `✅ ${movementTypeText} de inventario guardada exitosamente`,
        [
          {
            text: 'Ir al Dashboard',
            onPress: () => {
              navigation.navigate('Dashboard');
            },
          },
        ]
      );
    } catch (error) {
      console.error('Error submitting movement:', error);
      Alert.alert(t('common.error'), t('inventory.movements.errorMessage'));
    } finally {
      setSaving(false);
    }
  };

  const getSelectedWarehouse = () => {
    return warehouses.find(w => w.id === formData.warehouse_id);
  };

  const getSelectedProduct = () => {
    for (const product of products) {
      const variant = product.variants?.find(v => v.id === formData.product_variant_id);
      if (variant) {
        return { product, variant };
      }
    }
    return null;
  };

  const getSelectedUnit = () => {
    return units.find(u => u.id === formData.unit_id);
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color={theme.colors.primary} />
          <Text style={styles.loadingText}>{t('common.loading')}</Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity 
          style={styles.backButton}
          onPress={() => navigation.goBack()}
        >
          <Ionicons name="arrow-back" size={24} color={theme.colors.text} />
        </TouchableOpacity>
        
        <View style={styles.headerContent}>
          <Ionicons 
            name={getMovementIcon() as any} 
            size={24} 
            color={getMovementColor()} 
          />
          <Text style={styles.headerTitle}>{getMovementTitle()}</Text>
        </View>
      </View>

      <ScrollView style={styles.content} showsVerticalScrollIndicator={false}>
        {/* Selección de Almacén */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>
            {t('inventory.warehouse')} *
          </Text>
          <TouchableOpacity
            style={[
              styles.selector,
              !formData.warehouse_id && styles.selectorError
            ]}
            onPress={() => setShowWarehouseSelector(true)}
          >
            <View style={styles.selectorContent}>
              <Ionicons name="business" size={20} color={theme.colors.textSecondary} />
              <Text style={styles.selectorText}>
                {getSelectedWarehouse()?.name || t('inventory.selectWarehouse')}
              </Text>
            </View>
            <Ionicons name="chevron-down" size={20} color={theme.colors.textSecondary} />
          </TouchableOpacity>
        </View>

        {/* Selección de Producto */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>
            {t('inventory.product')} *
          </Text>
          <TouchableOpacity
            style={[
              styles.selector,
              !formData.product_variant_id && styles.selectorError
            ]}
            onPress={() => setShowProductSelector(true)}
          >
            <View style={styles.selectorContent}>
              <Ionicons name="cube" size={20} color={theme.colors.textSecondary} />
              <Text style={styles.selectorText}>
                {getSelectedProduct()?.product.name || t('inventory.selectProduct')}
              </Text>
            </View>
            <Ionicons name="chevron-down" size={20} color={theme.colors.textSecondary} />
          </TouchableOpacity>
        </View>

        {/* Cantidad y Unidad */}
        <View style={styles.row}>
          <View style={[styles.section, styles.flex1]}>
            <Text style={styles.sectionTitle}>
              {t('inventory.quantity')} *
            </Text>
            <TextInput
              style={[
                styles.input,
                formData.quantity <= 0 && styles.inputError
              ]}
              value={formData.quantity.toString()}
              onChangeText={(text) => {
                const quantity = parseFloat(text) || 0;
                setFormData(prev => ({ ...prev, quantity }));
              }}
              keyboardType="numeric"
              placeholder="0"
              placeholderTextColor={theme.colors.textSecondary}
            />
          </View>

          <View style={[styles.section, styles.flex1, styles.ml8]}>
            <Text style={styles.sectionTitle}>
              {t('inventory.unit')} *
            </Text>
            <TouchableOpacity
              style={[
                styles.selector,
                !formData.unit_id && styles.selectorError
              ]}
              onPress={() => setShowUnitSelector(true)}
            >
              <Text style={styles.selectorText}>
                {getSelectedUnit()?.symbol || t('inventory.selectUnit')}
              </Text>
              <Ionicons name="chevron-down" size={16} color={theme.colors.textSecondary} />
            </TouchableOpacity>
          </View>
        </View>

        {/* Campos específicos por tipo de movimiento */}
        {movementType === 'entry' && (
          <>
            <View style={styles.section}>
              <Text style={styles.sectionTitle}>
                {t('inventory.costPerUnit')}
              </Text>
              <TextInput
                style={styles.input}
                value={formData.cost_per_unit?.toString() || ''}
                onChangeText={(text) => {
                  const cost = parseFloat(text) || undefined;
                  setFormData(prev => ({ ...prev, cost_per_unit: cost }));
                }}
                keyboardType="numeric"
                placeholder="0.00"
                placeholderTextColor={theme.colors.textSecondary}
              />
            </View>

            <View style={styles.section}>
              <Text style={styles.sectionTitle}>
                {t('inventory.batchNumber')}
              </Text>
              <TextInput
                style={styles.input}
                value={formData.batch_number || ''}
                onChangeText={(text) => setFormData(prev => ({ ...prev, batch_number: text }))}
                placeholder={t('inventory.enterBatchNumber')}
                placeholderTextColor={theme.colors.textSecondary}
              />
            </View>
          </>
        )}

        {movementType === 'transfer' && (
          <View style={styles.section}>
            <Text style={styles.sectionTitle}>
              {t('inventory.destinationWarehouse')} *
            </Text>
            <TouchableOpacity
              style={[
                styles.selector,
                !formData.destination_warehouse_id && styles.selectorError
              ]}
              onPress={() => {
                // Similar al selector de almacén principal pero filtrado
                setShowWarehouseSelector(true);
              }}
            >
              <View style={styles.selectorContent}>
                <Ionicons name="business" size={20} color={theme.colors.textSecondary} />
                <Text style={styles.selectorText}>
                  {warehouses.find(w => w.id === formData.destination_warehouse_id)?.name || 
                   t('inventory.selectDestinationWarehouse')}
                </Text>
              </View>
              <Ionicons name="chevron-down" size={20} color={theme.colors.textSecondary} />
            </TouchableOpacity>
          </View>
        )}

        {/* Razón */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>
            {t('inventory.reason')}
          </Text>
          <TextInput
            style={styles.input}
            value={formData.reason || ''}
            onChangeText={(text) => setFormData(prev => ({ ...prev, reason: text }))}
            placeholder={t('inventory.enterReason')}
            placeholderTextColor={theme.colors.textSecondary}
          />
        </View>

        {/* Notas */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>
            {t('inventory.notes')}
          </Text>
          <TextInput
            style={[styles.input, styles.textArea]}
            value={formData.notes || ''}
            onChangeText={(text) => setFormData(prev => ({ ...prev, notes: text }))}
            placeholder={t('inventory.enterNotes')}
            placeholderTextColor={theme.colors.textSecondary}
            multiline
            numberOfLines={3}
            textAlignVertical="top"
          />
        </View>
      </ScrollView>

      <View style={styles.footer}>
        <TouchableOpacity
          style={[styles.button, styles.submitButton]}
          onPress={submitMovement}
          disabled={saving}
        >
          {saving ? (
            <ActivityIndicator size="small" color={theme.colors.white} />
          ) : (
            <>
              <Ionicons name="checkmark" size={20} color={theme.colors.white} />
              <Text style={styles.submitButtonText}>
                {t('inventory.movements.submit')}
              </Text>
            </>
          )}
        </TouchableOpacity>
      </View>

      {/* Modal de selección de almacén */}
      <Modal
        visible={showWarehouseSelector}
        animationType="slide"
        transparent={true}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <View style={styles.modalHeader}>
              <Text style={styles.modalTitle}>
                {t('inventory.selectWarehouse')}
              </Text>
              <TouchableOpacity onPress={() => setShowWarehouseSelector(false)}>
                <Ionicons name="close" size={24} color={theme.colors.text} />
              </TouchableOpacity>
            </View>
            
            <ScrollView style={styles.modalList}>
              {warehouses.map((warehouse) => (
                <TouchableOpacity
                  key={warehouse.id}
                  style={styles.modalItem}
                  onPress={() => {
                    setFormData(prev => ({ ...prev, warehouse_id: warehouse.id }));
                    setShowWarehouseSelector(false);
                  }}
                >
                  <View style={styles.modalItemContent}>
                    <Ionicons name="business" size={20} color={theme.colors.primary} />
                    <View style={styles.modalItemText}>
                      <Text style={styles.modalItemTitle}>{warehouse.name}</Text>
                      <Text style={styles.modalItemSubtitle}>{warehouse.code}</Text>
                    </View>
                  </View>
                  {formData.warehouse_id === warehouse.id && (
                    <Ionicons name="checkmark" size={20} color={theme.colors.success} />
                  )}
                </TouchableOpacity>
              ))}
            </ScrollView>
          </View>
        </View>
      </Modal>

      {/* Modal de selección de producto */}
      <Modal
        visible={showProductSelector}
        animationType="slide"
        transparent={true}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <View style={styles.modalHeader}>
              <Text style={styles.modalTitle}>
                {t('inventory.selectProduct')}
              </Text>
              <TouchableOpacity onPress={() => setShowProductSelector(false)}>
                <Ionicons name="close" size={24} color={theme.colors.text} />
              </TouchableOpacity>
            </View>
            
            <TextInput
              style={styles.searchInput}
              value={searchQuery}
              onChangeText={setSearchQuery}
              placeholder={t('common.search')}
              placeholderTextColor={theme.colors.textSecondary}
            />
            
            <ScrollView style={styles.modalList}>
              {products.map((product) => (
                <View key={product.id}>
                  {product.variants?.map((variant) => (
                    <TouchableOpacity
                      key={variant.id}
                      style={styles.modalItem}
                      onPress={() => {
                        setFormData(prev => ({ 
                          ...prev, 
                          product_variant_id: variant.id 
                        }));
                        setShowProductSelector(false);
                      }}
                    >
                      <View style={styles.modalItemContent}>
                        <Ionicons name="cube" size={20} color={theme.colors.primary} />
                        <View style={styles.modalItemText}>
                          <Text style={styles.modalItemTitle}>{product.name}</Text>
                          <Text style={styles.modalItemSubtitle}>
                            {t('inventory.currentStock')}: {variant.current_stock}
                          </Text>
                        </View>
                      </View>
                      {formData.product_variant_id === variant.id && (
                        <Ionicons name="checkmark" size={20} color={theme.colors.success} />
                      )}
                    </TouchableOpacity>
                  ))}
                </View>
              ))}
            </ScrollView>
          </View>
        </View>
      </Modal>

      {/* Modal de selección de unidad */}
      <Modal
        visible={showUnitSelector}
        animationType="slide"
        transparent={true}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <View style={styles.modalHeader}>
              <Text style={styles.modalTitle}>
                {t('inventory.selectUnit')}
              </Text>
              <TouchableOpacity onPress={() => setShowUnitSelector(false)}>
                <Ionicons name="close" size={24} color={theme.colors.text} />
              </TouchableOpacity>
            </View>
            
            <ScrollView style={styles.modalList}>
              {units.map((unit) => (
                <TouchableOpacity
                  key={unit.id}
                  style={styles.modalItem}
                  onPress={() => {
                    setFormData(prev => ({ ...prev, unit_id: unit.id }));
                    setShowUnitSelector(false);
                  }}
                >
                  <View style={styles.modalItemContent}>
                    <Ionicons name="scale" size={20} color={theme.colors.primary} />
                    <View style={styles.modalItemText}>
                      <Text style={styles.modalItemTitle}>{unit.name}</Text>
                      <Text style={styles.modalItemSubtitle}>{unit.symbol}</Text>
                    </View>
                  </View>
                  {formData.unit_id === unit.id && (
                    <Ionicons name="checkmark" size={20} color={theme.colors.success} />
                  )}
                </TouchableOpacity>
              ))}
            </ScrollView>
          </View>
        </View>
      </Modal>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: theme.colors.background,
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  loadingText: {
    marginTop: 16,
    fontSize: 16,
    color: theme.colors.textSecondary,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.border,
    backgroundColor: theme.colors.white,
  },
  backButton: {
    padding: 8,
    marginRight: 8,
  },
  headerContent: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  headerTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: theme.colors.text,
    marginLeft: 8,
  },
  content: {
    flex: 1,
    padding: 16,
  },
  section: {
    marginBottom: 16,
  },
  sectionTitle: {
    fontSize: 14,
    fontWeight: '500',
    color: theme.colors.text,
    marginBottom: 8,
  },
  selector: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: 12,
    backgroundColor: theme.colors.white,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: theme.colors.border,
  },
  selectorError: {
    borderColor: theme.colors.error,
  },
  selectorContent: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  selectorText: {
    fontSize: 16,
    color: theme.colors.text,
    marginLeft: 8,
  },
  input: {
    padding: 12,
    backgroundColor: theme.colors.white,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: theme.colors.border,
    fontSize: 16,
    color: theme.colors.text,
  },
  inputError: {
    borderColor: theme.colors.error,
  },
  textArea: {
    height: 80,
    paddingTop: 12,
  },
  row: {
    flexDirection: 'row',
  },
  flex1: {
    flex: 1,
  },
  ml8: {
    marginLeft: 8,
  },
  footer: {
    padding: 16,
    backgroundColor: theme.colors.white,
    borderTopWidth: 1,
    borderTopColor: theme.colors.border,
  },
  button: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 16,
    borderRadius: 8,
  },
  submitButton: {
    backgroundColor: theme.colors.primary,
  },
  submitButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: theme.colors.white,
    marginLeft: 8,
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    justifyContent: 'flex-end',
  },
  modalContent: {
    backgroundColor: theme.colors.white,
    borderTopLeftRadius: 16,
    borderTopRightRadius: 16,
    maxHeight: '70%',
  },
  modalHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.border,
  },
  modalTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: theme.colors.text,
  },
  searchInput: {
    margin: 16,
    marginBottom: 0,
    padding: 12,
    backgroundColor: theme.colors.background,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: theme.colors.border,
    fontSize: 16,
    color: theme.colors.text,
  },
  modalList: {
    flex: 1,
  },
  modalItem: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.border,
  },
  modalItemContent: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  modalItemText: {
    marginLeft: 12,
    flex: 1,
  },
  modalItemTitle: {
    fontSize: 16,
    fontWeight: '500',
    color: theme.colors.text,
  },
  modalItemSubtitle: {
    fontSize: 14,
    color: theme.colors.textSecondary,
    marginTop: 2,
  },
});

export default InventoryMovementFormScreen;
