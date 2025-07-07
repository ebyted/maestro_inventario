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
}

interface MovementItem {
  product_variant_id: number;
  product_name: string;
  variant_info: string;
  quantity: number;
  unit_cost?: number;
  notes?: string;
}

interface InventoryMovementScreenProps {
  navigation: any;
  route: {
    params: {
      movementType: 'entry' | 'exit' | 'adjustment';
    };
  };
}

const InventoryMovementScreen: React.FC<InventoryMovementScreenProps> = ({ 
  navigation, 
  route 
}) => {
  const { t } = useTranslation();
  const { movementType } = route.params;
  
  const [loading, setLoading] = useState(false);
  const [warehouses, setWarehouses] = useState<Warehouse[]>([]);
  const [selectedWarehouse, setSelectedWarehouse] = useState<Warehouse | null>(null);
  const [movementItems, setMovementItems] = useState<MovementItem[]>([]);
  const [reference, setReference] = useState('');
  const [notes, setNotes] = useState('');
  const [showProductSelector, setShowProductSelector] = useState(false);
  const [products, setProducts] = useState<Product[]>([]);
  const [searchQuery, setSearchQuery] = useState('');

  useEffect(() => {
    loadWarehouses();
    loadProducts();
  }, []);

  const loadWarehouses = async () => {
    try {
      const response = await apiService.get('/warehouses');
      setWarehouses(response.data);
      if (response.data.length > 0) {
        setSelectedWarehouse(response.data[0]);
      }
    } catch (error) {
      console.error('Error loading warehouses:', error);
      Alert.alert(t('common.error'), t('inventory.errors.loadWarehousesFailed'));
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

  const getMovementTitle = () => {
    switch (movementType) {
      case 'entry':
        return t('inventory.movements.entry');
      case 'exit':
        return t('inventory.movements.exit');
      case 'adjustment':
        return t('inventory.movements.adjustment');
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
      default:
        return 'swap-horizontal';
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
      default:
        return theme.colors.textSecondary;
    }
  };

  const addProduct = (product: Product, variant: any) => {
    const existingItemIndex = movementItems.findIndex(
      item => item.product_variant_id === variant.id
    );

    if (existingItemIndex >= 0) {
      Alert.alert(
        t('inventory.errors.productAlreadyAdded'),
        t('inventory.errors.productAlreadyAddedDescription')
      );
      return;
    }

    const variantInfo = variant.attributes 
      ? Object.keys(variant.attributes).map(key => `${key}: ${variant.attributes[key]}`).join(', ')
      : t('inventory.defaultVariant');

    const newItem: MovementItem = {
      product_variant_id: variant.id,
      product_name: product.name,
      variant_info: variantInfo,
      quantity: 1,
      unit_cost: movementType === 'entry' ? 0 : undefined,
      notes: '',
    };

    setMovementItems([...movementItems, newItem]);
    setShowProductSelector(false);
  };

  const updateMovementItem = (index: number, field: keyof MovementItem, value: any) => {
    const updated = [...movementItems];
    updated[index] = { ...updated[index], [field]: value };
    setMovementItems(updated);
  };

  const removeMovementItem = (index: number) => {
    const updated = movementItems.filter((_, i) => i !== index);
    setMovementItems(updated);
  };

  const validateMovement = () => {
    if (!selectedWarehouse) {
      Alert.alert(t('common.error'), t('inventory.errors.selectWarehouse'));
      return false;
    }

    if (movementItems.length === 0) {
      Alert.alert(t('common.error'), t('inventory.errors.noItemsAdded'));
      return false;
    }

    for (const item of movementItems) {
      if (item.quantity <= 0) {
        Alert.alert(t('common.error'), t('inventory.errors.invalidQuantity'));
        return false;
      }

      if (movementType === 'entry' && (item.unit_cost === undefined || item.unit_cost < 0)) {
        Alert.alert(t('common.error'), t('inventory.errors.invalidUnitCost'));
        return false;
      }
    }

    return true;
  };

  const processMovement = async () => {
    if (!validateMovement()) return;

    try {
      setLoading(true);

      const movementData = {
        warehouse_id: selectedWarehouse!.id,
        movement_type: movementType,
        reference,
        notes,
        items: movementItems.map(item => ({
          product_variant_id: item.product_variant_id,
          quantity: item.quantity,
          unit_cost: item.unit_cost,
          notes: item.notes,
        })),
      };

      await apiService.post('/inventory/movements', movementData);

      // Mostrar notificación visual de éxito
      Alert.alert(
        '🎉 ¡Éxito!',
        `✅ ${t('inventory.movements.processedSuccessfully')}`,
        [
          {
            text: 'Ir al Dashboard',
            onPress: () => {
              // Navegar al Dashboard (Home) después de procesar exitosamente
              navigation.navigate('Dashboard');
            },
          },
        ]
      );
    } catch (error) {
      console.error('Error processing movement:', error);
      Alert.alert(t('common.error'), t('inventory.errors.processingFailed'));
    } finally {
      setLoading(false);
    }
  };

  const filteredProducts = products.filter(product =>
    product.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    product.sku?.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const renderWarehouseSelector = () => (
    <View style={styles.section}>
      <Text style={styles.sectionTitle}>{t('inventory.warehouse')}</Text>
      <View style={styles.warehouseContainer}>
        {warehouses.map((warehouse) => (
          <TouchableOpacity
            key={warehouse.id}
            style={[
              styles.warehouseOption,
              selectedWarehouse?.id === warehouse.id && styles.warehouseOptionSelected,
            ]}
            onPress={() => setSelectedWarehouse(warehouse)}
          >
            <Text style={[
              styles.warehouseOptionText,
              selectedWarehouse?.id === warehouse.id && styles.warehouseOptionTextSelected,
            ]}>
              {warehouse.name}
            </Text>
          </TouchableOpacity>
        ))}
      </View>
    </View>
  );

  const renderMovementInfo = () => (
    <View style={styles.section}>
      <Text style={styles.sectionTitle}>{t('inventory.movementInfo')}</Text>
      
      <View style={styles.inputGroup}>
        <Text style={styles.inputLabel}>{t('inventory.reference')}</Text>
        <TextInput
          style={styles.input}
          value={reference}
          onChangeText={setReference}
          placeholder={t('inventory.referencePlaceholder')}
          placeholderTextColor={theme.colors.textSecondary}
        />
      </View>

      <View style={styles.inputGroup}>
        <Text style={styles.inputLabel}>{t('inventory.notes')}</Text>
        <TextInput
          style={[styles.input, styles.notesInput]}
          value={notes}
          onChangeText={setNotes}
          placeholder={t('inventory.notesPlaceholder')}
          placeholderTextColor={theme.colors.textSecondary}
          multiline
          numberOfLines={3}
        />
      </View>
    </View>
  );

  const renderMovementItems = () => (
    <View style={styles.section}>
      <View style={styles.sectionHeader}>
        <Text style={styles.sectionTitle}>{t('inventory.items')}</Text>
        <TouchableOpacity
          style={styles.addButton}
          onPress={() => setShowProductSelector(true)}
        >
          <Ionicons name="add" size={20} color={theme.colors.white} />
          <Text style={styles.addButtonText}>{t('inventory.addProduct')}</Text>
        </TouchableOpacity>
      </View>

      {movementItems.map((item, index) => (
        <View key={index} style={styles.itemCard}>
          <View style={styles.itemHeader}>
            <View style={styles.itemInfo}>
              <Text style={styles.itemName}>{item.product_name}</Text>
              <Text style={styles.itemVariant}>{item.variant_info}</Text>
            </View>
            <TouchableOpacity
              style={styles.removeButton}
              onPress={() => removeMovementItem(index)}
            >
              <Ionicons name="trash" size={20} color={theme.colors.error} />
            </TouchableOpacity>
          </View>

          <View style={styles.itemInputs}>
            <View style={styles.quantityContainer}>
              <Text style={styles.inputLabel}>{t('inventory.quantity')}</Text>
              <TextInput
                style={styles.quantityInput}
                value={item.quantity.toString()}
                onChangeText={(text) => updateMovementItem(index, 'quantity', parseInt(text) || 0)}
                keyboardType="numeric"
                placeholder="0"
              />
            </View>

            {movementType === 'entry' && (
              <View style={styles.costContainer}>
                <Text style={styles.inputLabel}>{t('inventory.unitCost')}</Text>
                <TextInput
                  style={styles.costInput}
                  value={item.unit_cost?.toString() || ''}
                  onChangeText={(text) => updateMovementItem(index, 'unit_cost', parseFloat(text) || 0)}
                  keyboardType="numeric"
                  placeholder="0.00"
                />
              </View>
            )}
          </View>

          <View style={styles.itemNotesContainer}>
            <Text style={styles.inputLabel}>{t('inventory.itemNotes')}</Text>
            <TextInput
              style={styles.itemNotesInput}
              value={item.notes || ''}
              onChangeText={(text) => updateMovementItem(index, 'notes', text)}
              placeholder={t('inventory.itemNotesPlaceholder')}
              placeholderTextColor={theme.colors.textSecondary}
            />
          </View>
        </View>
      ))}
    </View>
  );

  const renderProductSelector = () => (
    <Modal
      visible={showProductSelector}
      animationType="slide"
      presentationStyle="pageSheet"
      onRequestClose={() => setShowProductSelector(false)}
    >
      <SafeAreaView style={styles.modalContainer}>
        <View style={styles.modalHeader}>
          <TouchableOpacity onPress={() => setShowProductSelector(false)}>
            <Ionicons name="close" size={24} color={theme.colors.text} />
          </TouchableOpacity>
          <Text style={styles.modalTitle}>{t('inventory.selectProduct')}</Text>
          <View style={{ width: 24 }} />
        </View>

        <View style={styles.searchContainer}>
          <TextInput
            style={styles.searchInput}
            value={searchQuery}
            onChangeText={setSearchQuery}
            placeholder={t('inventory.searchProducts')}
            placeholderTextColor={theme.colors.textSecondary}
          />
        </View>

        <ScrollView style={styles.productsList}>
          {filteredProducts.map((product) => (
            <View key={product.id} style={styles.productCard}>
              <Text style={styles.productName}>{product.name}</Text>
              {product.sku && <Text style={styles.productSku}>SKU: {product.sku}</Text>}
              
              {product.variants.map((variant) => (
                <TouchableOpacity
                  key={variant.id}
                  style={styles.variantOption}
                  onPress={() => addProduct(product, variant)}
                >
                  <View style={styles.variantInfo}>
                    <Text style={styles.variantText}>
                      {variant.attributes 
                        ? Object.keys(variant.attributes).map(key => `${key}: ${variant.attributes[key]}`).join(', ')
                        : t('inventory.defaultVariant')
                      }
                    </Text>
                    <Text style={styles.currentStock}>
                      {t('inventory.currentStock')}: {variant.current_stock}
                    </Text>
                  </View>
                  <Ionicons name="add-circle" size={24} color={theme.colors.primary} />
                </TouchableOpacity>
              ))}
            </View>
          ))}
        </ScrollView>
      </SafeAreaView>
    </Modal>
  );

  return (
    <SafeAreaView style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <Ionicons name="arrow-back" size={24} color={theme.colors.text} />
        </TouchableOpacity>
        <View style={styles.headerTitle}>
          <Ionicons 
            name={getMovementIcon() as any} 
            size={24} 
            color={getMovementColor()} 
          />
          <Text style={styles.headerText}>{getMovementTitle()}</Text>
        </View>
        <View style={{ width: 24 }} />
      </View>

      <ScrollView style={styles.content}>
        {renderWarehouseSelector()}
        {renderMovementInfo()}
        {renderMovementItems()}
      </ScrollView>

      {/* Footer */}
      <View style={styles.footer}>
        <TouchableOpacity
          style={[styles.processButton, { backgroundColor: getMovementColor() }]}
          onPress={processMovement}
          disabled={loading}
        >
          {loading ? (
            <ActivityIndicator color={theme.colors.white} />
          ) : (
            <>
              <Ionicons name="checkmark" size={20} color={theme.colors.white} />
              <Text style={styles.processButtonText}>
                {t('inventory.processMovement')}
              </Text>
            </>
          )}
        </TouchableOpacity>
      </View>

      {renderProductSelector()}
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: theme.colors.background,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    paddingVertical: 12,
    backgroundColor: theme.colors.white,
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.border,
  },
  headerTitle: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  headerText: {
    fontSize: 18,
    fontWeight: '600',
    color: theme.colors.text,
  },
  content: {
    flex: 1,
    paddingHorizontal: 16,
  },
  section: {
    backgroundColor: theme.colors.white,
    borderRadius: 8,
    padding: 16,
    marginVertical: 8,
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: theme.colors.text,
    marginBottom: 12,
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
  },
  warehouseContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  warehouseOption: {
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 20,
    backgroundColor: theme.colors.lightGray,
    borderWidth: 1,
    borderColor: theme.colors.border,
  },
  warehouseOptionSelected: {
    backgroundColor: theme.colors.primary,
    borderColor: theme.colors.primary,
  },
  warehouseOptionText: {
    color: theme.colors.text,
    fontSize: 14,
    fontWeight: '500',
  },
  warehouseOptionTextSelected: {
    color: theme.colors.white,
  },
  inputGroup: {
    marginBottom: 16,
  },
  inputLabel: {
    fontSize: 14,
    fontWeight: '500',
    color: theme.colors.text,
    marginBottom: 6,
  },
  input: {
    borderWidth: 1,
    borderColor: theme.colors.border,
    borderRadius: 8,
    paddingHorizontal: 12,
    paddingVertical: 10,
    fontSize: 16,
    color: theme.colors.text,
    backgroundColor: theme.colors.white,
  },
  notesInput: {
    height: 80,
    textAlignVertical: 'top',
  },
  addButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: theme.colors.primary,
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: 6,
    gap: 4,
  },
  addButtonText: {
    color: theme.colors.white,
    fontSize: 14,
    fontWeight: '500',
  },
  itemCard: {
    borderWidth: 1,
    borderColor: theme.colors.border,
    borderRadius: 8,
    padding: 12,
    marginBottom: 12,
  },
  itemHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: 12,
  },
  itemInfo: {
    flex: 1,
  },
  itemName: {
    fontSize: 16,
    fontWeight: '600',
    color: theme.colors.text,
  },
  itemVariant: {
    fontSize: 14,
    color: theme.colors.textSecondary,
    marginTop: 2,
  },
  removeButton: {
    padding: 4,
  },
  itemInputs: {
    flexDirection: 'row',
    gap: 12,
    marginBottom: 12,
  },
  quantityContainer: {
    flex: 1,
  },
  quantityInput: {
    borderWidth: 1,
    borderColor: theme.colors.border,
    borderRadius: 6,
    paddingHorizontal: 10,
    paddingVertical: 8,
    fontSize: 16,
    textAlign: 'center',
  },
  costContainer: {
    flex: 1,
  },
  costInput: {
    borderWidth: 1,
    borderColor: theme.colors.border,
    borderRadius: 6,
    paddingHorizontal: 10,
    paddingVertical: 8,
    fontSize: 16,
    textAlign: 'right',
  },
  itemNotesContainer: {
    marginTop: 8,
  },
  itemNotesInput: {
    borderWidth: 1,
    borderColor: theme.colors.border,
    borderRadius: 6,
    paddingHorizontal: 10,
    paddingVertical: 8,
    fontSize: 14,
  },
  footer: {
    padding: 16,
    backgroundColor: theme.colors.white,
    borderTopWidth: 1,
    borderTopColor: theme.colors.border,
  },
  processButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 14,
    borderRadius: 8,
    gap: 8,
  },
  processButtonText: {
    color: theme.colors.white,
    fontSize: 16,
    fontWeight: '600',
  },
  modalContainer: {
    flex: 1,
    backgroundColor: theme.colors.background,
  },
  modalHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    paddingVertical: 12,
    backgroundColor: theme.colors.white,
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.border,
  },
  modalTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: theme.colors.text,
  },
  searchContainer: {
    paddingHorizontal: 16,
    paddingVertical: 12,
    backgroundColor: theme.colors.white,
  },
  searchInput: {
    borderWidth: 1,
    borderColor: theme.colors.border,
    borderRadius: 8,
    paddingHorizontal: 12,
    paddingVertical: 10,
    fontSize: 16,
    backgroundColor: theme.colors.white,
  },
  productsList: {
    flex: 1,
    paddingHorizontal: 16,
  },
  productCard: {
    backgroundColor: theme.colors.white,
    borderRadius: 8,
    padding: 16,
    marginVertical: 4,
    borderWidth: 1,
    borderColor: theme.colors.border,
  },
  productName: {
    fontSize: 16,
    fontWeight: '600',
    color: theme.colors.text,
    marginBottom: 4,
  },
  productSku: {
    fontSize: 14,
    color: theme.colors.textSecondary,
    marginBottom: 8,
  },
  variantOption: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: 8,
    paddingHorizontal: 12,
    borderRadius: 6,
    backgroundColor: theme.colors.lightGray,
    marginVertical: 2,
  },
  variantInfo: {
    flex: 1,
  },
  variantText: {
    fontSize: 14,
    color: theme.colors.text,
    fontWeight: '500',
  },
  currentStock: {
    fontSize: 12,
    color: theme.colors.textSecondary,
    marginTop: 2,
  },
});

export default InventoryMovementScreen;
