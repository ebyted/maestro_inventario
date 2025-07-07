import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Alert,
  TextInput,
  ActivityIndicator,
  Modal,
  FlatList,
  Animated,
} from 'react-native';
import { useTranslation } from 'react-i18next';
import Icon from 'react-native-vector-icons/MaterialIcons';

type Props = {
  navigation: any;
  route: any;
};

interface Product {
  id: number;
  name: string;
  sku: string;
  variants: ProductVariant[];
}

interface ProductVariant {
  id: number;
  attributes: any;
  price: number;
  cost: number;
}

interface Unit {
  id: number;
  name: string;
  symbol: string;
}

interface Warehouse {
  id: number;
  name: string;
}

interface MovementItem {
  id: string;
  product_variant_id: number;
  product_name?: string;
  unit_id: number;
  unit_name?: string;
  quantity: string;
  cost_per_unit?: string;
  unit_price?: string;
  quantity_adjustment?: string;
  cost_adjustment?: string;
  expiry_date?: string;
  batch_number?: string;
  notes?: string;
  reason?: string;
}

interface SelectionModalData {
  visible: boolean;
  type: 'warehouse' | 'product' | 'unit' | 'supplier' | 'customer';
  items: any[];
  onSelect: (item: any) => void;
  currentItemId?: string;
}

const InventoryMultiItemFormScreen: React.FC<Props> = ({ navigation, route }) => {
  const { t } = useTranslation();
  const { movementType } = route.params || { movementType: 'entry' };
  
  const [loading, setLoading] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  
  // Notificación de éxito
  const [showSuccessNotification, setShowSuccessNotification] = useState(false);
  const [successAnimation] = useState(new Animated.Value(0));
  const [successMessage, setSuccessMessage] = useState('');
  
  // Form data
  const [warehouseId, setWarehouseId] = useState<number | null>(null);
  const [warehouseName, setWarehouseName] = useState<string>('');
  const [supplierId, setSupplierId] = useState<number | null>(null);
  const [supplierName, setSupplierName] = useState<string>('');
  const [customerId, setCustomerId] = useState<number | null>(null);
  const [customerName, setCustomerName] = useState<string>('');
  const [destinationWarehouseId, setDestinationWarehouseId] = useState<number | null>(null);
  const [destinationWarehouseName, setDestinationWarehouseName] = useState<string>('');
  const [referenceNumber, setReferenceNumber] = useState('');
  const [reason, setReason] = useState('');
  const [notes, setNotes] = useState('');
  
  // Items
  const [items, setItems] = useState<MovementItem[]>([]);
  
  // Data for dropdowns
  const [products, setProducts] = useState<Product[]>([]);
  const [units, setUnits] = useState<Unit[]>([]);
  const [warehouses, setWarehouses] = useState<Warehouse[]>([]);
  const [suppliers, setSuppliers] = useState<any[]>([]);
  const [customers, setCustomers] = useState<any[]>([]);

  // Selection modal
  const [selectionModal, setSelectionModal] = useState<SelectionModalData>({
    visible: false,
    type: 'warehouse',
    items: [],
    onSelect: () => {},
  });

  useEffect(() => {
    loadInitialData();
    addNewItem(); // Start with one item
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
      // Mock data - replace with actual API calls
      setWarehouses([
        { id: 1, name: 'Almacén Principal' },
        { id: 2, name: 'Almacén Secundario' },
      ]);
      
      setUnits([
        { id: 1, name: 'Unidad', symbol: 'un' },
        { id: 2, name: 'Kilogramo', symbol: 'kg' },
        { id: 3, name: 'Litro', symbol: 'L' },
      ]);
      
      setProducts([
        {
          id: 1,
          name: 'Producto A',
          sku: 'SKU-001',
          variants: [{ id: 1, attributes: {}, price: 100, cost: 75 }]
        },
        {
          id: 2,
          name: 'Producto B',
          sku: 'SKU-002',
          variants: [{ id: 2, attributes: {}, price: 200, cost: 150 }]
        },
        {
          id: 3,
          name: 'Producto C',
          sku: 'SKU-003',
          variants: [{ id: 3, attributes: {}, price: 150, cost: 100 }]
        },
      ]);
      
      if (movementType === 'entry') {
        setSuppliers([
          { id: 1, name: 'Proveedor A' },
          { id: 2, name: 'Proveedor B' },
        ]);
      }
      
      if (movementType === 'exit') {
        setCustomers([
          { id: 1, name: 'Cliente A' },
          { id: 2, name: 'Cliente B' },
        ]);
      }
    } catch (error) {
      console.error('Error loading data:', error);
      Alert.alert('Error', 'No se pudieron cargar los datos');
    } finally {
      setLoading(false);
    }
  };

  const addNewItem = () => {
    const newItem: MovementItem = {
      id: Date.now().toString(),
      product_variant_id: 0,
      unit_id: 0,
      quantity: '',
    };
    
    if (movementType === 'entry') {
      newItem.cost_per_unit = '';
      newItem.batch_number = '';
    } else if (movementType === 'exit') {
      newItem.unit_price = '';
    } else if (movementType === 'adjustment') {
      newItem.quantity_adjustment = '';
      newItem.cost_adjustment = '';
    }
    
    setItems([...items, newItem]);
  };

  const removeItem = (itemId: string) => {
    if (items.length <= 1) {
      Alert.alert('Error', 'Debe tener al menos un producto');
      return;
    }
    setItems(items.filter(item => item.id !== itemId));
  };

  const updateItem = (itemId: string, field: keyof MovementItem, value: any) => {
    setItems(items.map(item => 
      item.id === itemId ? { ...item, [field]: value } : item
    ));
  };

  const openSelectionModal = (
    type: SelectionModalData['type'],
    onSelect: (item: any) => void,
    currentItemId?: string
  ) => {
    let modalItems: any[] = [];
    
    switch (type) {
      case 'warehouse':
        modalItems = warehouses;
        break;
      case 'product':
        modalItems = [];
        products.forEach(product => {
          product.variants.forEach(variant => {
            modalItems.push({
              id: variant.id,
              name: `${product.name} (${product.sku})`,
              product,
              variant
            });
          });
        });
        break;
      case 'unit':
        modalItems = units.map(unit => ({
          id: unit.id,
          name: `${unit.name} (${unit.symbol})`
        }));
        break;
      case 'supplier':
        modalItems = suppliers;
        break;
      case 'customer':
        modalItems = customers;
        break;
    }

    setSelectionModal({
      visible: true,
      type,
      items: modalItems,
      onSelect,
      currentItemId
    });
  };

  const closeSelectionModal = () => {
    setSelectionModal(prev => ({ ...prev, visible: false }));
  };

  const validateForm = (): boolean => {
    if (!warehouseId) {
      Alert.alert('Error', 'Seleccione un almacén');
      return false;
    }

    if (items.length === 0) {
      Alert.alert('Error', 'Debe agregar al menos un producto');
      return false;
    }

    for (const item of items) {
      if (!item.product_variant_id || item.product_variant_id === 0) {
        Alert.alert('Error', 'Seleccione un producto para todos los items');
        return false;
      }
      
      if (!item.unit_id || item.unit_id === 0) {
        Alert.alert('Error', 'Seleccione una unidad para todos los items');
        return false;
      }

      const quantity = movementType === 'adjustment' ? 
        parseFloat(item.quantity_adjustment || '0') : 
        parseFloat(item.quantity || '0');
        
      if (isNaN(quantity) || quantity === 0) {
        Alert.alert('Error', 'Ingrese cantidades válidas para todos los items');
        return false;
      }
    }

    return true;
  };

  const handleSubmit = async () => {
    if (!validateForm()) return;

    setSubmitting(true);
    try {
      const baseData = {
        warehouse_id: warehouseId,
        reference_number: referenceNumber || undefined,
        reason: reason || undefined,
        notes: notes || undefined,
      };

      let endpoint = '';
      let requestData: any = { ...baseData };

      if (movementType === 'entry') {
        endpoint = '/inventory/entries/multi';
        requestData.supplier_id = supplierId || undefined;
        requestData.items = items.map(item => ({
          product_variant_id: item.product_variant_id,
          unit_id: item.unit_id,
          quantity: parseFloat(item.quantity),
          cost_per_unit: item.cost_per_unit ? parseFloat(item.cost_per_unit) : undefined,
          batch_number: item.batch_number || undefined,
          notes: item.notes || undefined,
        }));
      } else if (movementType === 'exit') {
        endpoint = '/inventory/exits/multi';
        requestData.customer_id = customerId || undefined;
        requestData.destination_warehouse_id = destinationWarehouseId || undefined;
        requestData.items = items.map(item => ({
          product_variant_id: item.product_variant_id,
          unit_id: item.unit_id,
          quantity: parseFloat(item.quantity),
          unit_price: item.unit_price ? parseFloat(item.unit_price) : undefined,
          notes: item.notes || undefined,
        }));
      } else if (movementType === 'adjustment') {
        endpoint = '/inventory/adjustments/multi';
        requestData.items = items.map(item => ({
          product_variant_id: item.product_variant_id,
          unit_id: item.unit_id,
          quantity_adjustment: parseFloat(item.quantity_adjustment || '0'),
          cost_adjustment: item.cost_adjustment ? parseFloat(item.cost_adjustment) : undefined,
          reason: item.reason || undefined,
          notes: item.notes || undefined,
        }));
      }

      console.log('Submitting:', requestData);
      
      // Llamar al API real del backend
      const response = await fetch(`http://localhost:8000/api/v1${endpoint}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(requestData),
      });
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      const result = await response.json();
      console.log('Success response:', result);
      
      // Mostrar notificación de éxito personalizada
      showSuccessMessage(`✅ ${getMovementTypeTitle()} creado exitosamente`);
    } catch (error) {
      console.error('Error submitting:', error);
      Alert.alert('Error', 'No se pudo guardar el movimiento');
    } finally {
      setSubmitting(false);
    }
  };

  const getMovementTypeTitle = () => {
    switch (movementType) {
      case 'entry':
        return 'Entrada de Inventario Multi-Item';
      case 'exit':
        return 'Salida de Inventario Multi-Item';
      case 'adjustment':
        return 'Ajuste de Inventario Multi-Item';
      default:
        return 'Movimiento de Inventario Multi-Item';
    }
  };

  const renderSelectionModal = () => (
    <Modal
      visible={selectionModal.visible}
      transparent={true}
      animationType="slide"
      onRequestClose={closeSelectionModal}
    >
      <View style={styles.modalOverlay}>
        <View style={styles.modalContainer}>
          <View style={styles.modalHeader}>
            <Text style={styles.modalTitle}>
              Seleccionar {selectionModal.type === 'warehouse' ? 'Almacén' :
                         selectionModal.type === 'product' ? 'Producto' :
                         selectionModal.type === 'unit' ? 'Unidad' :
                         selectionModal.type === 'supplier' ? 'Proveedor' : 'Cliente'}
            </Text>
            <TouchableOpacity onPress={closeSelectionModal}>
              <Icon name="close" size={24} color="#333" />
            </TouchableOpacity>
          </View>
          
          <FlatList
            data={selectionModal.items}
            keyExtractor={(item) => item.id.toString()}
            renderItem={({ item }) => (
              <TouchableOpacity
                style={styles.modalItem}
                onPress={() => {
                  selectionModal.onSelect(item);
                  closeSelectionModal();
                }}
              >
                <Text style={styles.modalItemText}>{item.name}</Text>
              </TouchableOpacity>
            )}
          />
        </View>
      </View>
    </Modal>
  );

  const renderSuccessNotification = () => {
    if (!showSuccessNotification) return null;

    return (
      <Animated.View
        style={[
          styles.successNotification,
          {
            opacity: successAnimation,
            transform: [
              {
                translateY: successAnimation.interpolate({
                  inputRange: [0, 1],
                  outputRange: [-100, 0],
                }),
              },
            ],
          },
        ]}
      >
        <View style={styles.successContent}>
          <Icon name="check-circle" size={32} color="#fff" />
          <Text style={styles.successText}>{successMessage}</Text>
        </View>
      </Animated.View>
    );
  };

  const renderItemForm = (item: MovementItem, index: number) => {
    return (
      <View key={item.id} style={styles.itemContainer}>
        <View style={styles.itemHeader}>
          <Text style={styles.itemTitle}>Producto {index + 1}</Text>
          {items.length > 1 && (
            <TouchableOpacity
              onPress={() => removeItem(item.id)}
              style={styles.removeButton}
            >
              <Icon name="delete" size={24} color="#dc3545" />
            </TouchableOpacity>
          )}
        </View>

        {/* Product Selection */}
        <View style={styles.formGroup}>
          <Text style={styles.label}>Producto *</Text>
          <TouchableOpacity
            style={styles.selectButton}
            onPress={() => openSelectionModal('product', (selectedProduct) => {
              updateItem(item.id, 'product_variant_id', selectedProduct.id);
              updateItem(item.id, 'product_name', selectedProduct.name);
            }, item.id)}
          >
            <Text style={[styles.selectButtonText, !item.product_name && styles.placeholderText]}>
              {item.product_name || 'Seleccionar producto...'}
            </Text>
            <Icon name="arrow-drop-down" size={24} color="#666" />
          </TouchableOpacity>
        </View>

        {/* Unit Selection */}
        <View style={styles.formGroup}>
          <Text style={styles.label}>Unidad *</Text>
          <TouchableOpacity
            style={styles.selectButton}
            onPress={() => openSelectionModal('unit', (selectedUnit) => {
              updateItem(item.id, 'unit_id', selectedUnit.id);
              updateItem(item.id, 'unit_name', selectedUnit.name);
            }, item.id)}
          >
            <Text style={[styles.selectButtonText, !item.unit_name && styles.placeholderText]}>
              {item.unit_name || 'Seleccionar unidad...'}
            </Text>
            <Icon name="arrow-drop-down" size={24} color="#666" />
          </TouchableOpacity>
        </View>

        {/* Quantity */}
        {movementType !== 'adjustment' && (
          <View style={styles.formGroup}>
            <Text style={styles.label}>Cantidad *</Text>
            <TextInput
              style={styles.input}
              value={item.quantity}
              onChangeText={(value) => updateItem(item.id, 'quantity', value)}
              keyboardType="numeric"
              placeholder="0.00"
            />
          </View>
        )}

        {/* Adjustment Quantity */}
        {movementType === 'adjustment' && (
          <View style={styles.formGroup}>
            <Text style={styles.label}>Ajuste de Cantidad *</Text>
            <TextInput
              style={styles.input}
              value={item.quantity_adjustment}
              onChangeText={(value) => updateItem(item.id, 'quantity_adjustment', value)}
              keyboardType="numeric"
              placeholder="0.00 (+ agregar, - quitar)"
            />
          </View>
        )}

        {/* Cost per unit (entries) */}
        {movementType === 'entry' && (
          <View style={styles.formGroup}>
            <Text style={styles.label}>Costo por Unidad</Text>
            <TextInput
              style={styles.input}
              value={item.cost_per_unit}
              onChangeText={(value) => updateItem(item.id, 'cost_per_unit', value)}
              keyboardType="numeric"
              placeholder="0.00"
            />
          </View>
        )}

        {/* Unit price (exits) */}
        {movementType === 'exit' && (
          <View style={styles.formGroup}>
            <Text style={styles.label}>Precio de Venta</Text>
            <TextInput
              style={styles.input}
              value={item.unit_price}
              onChangeText={(value) => updateItem(item.id, 'unit_price', value)}
              keyboardType="numeric"
              placeholder="0.00"
            />
          </View>
        )}

        {/* Cost adjustment (adjustments) */}
        {movementType === 'adjustment' && (
          <View style={styles.formGroup}>
            <Text style={styles.label}>Ajuste de Costo</Text>
            <TextInput
              style={styles.input}
              value={item.cost_adjustment}
              onChangeText={(value) => updateItem(item.id, 'cost_adjustment', value)}
              keyboardType="numeric"
              placeholder="0.00"
            />
          </View>
        )}

        {/* Batch number (entries) */}
        {movementType === 'entry' && (
          <View style={styles.formGroup}>
            <Text style={styles.label}>Número de Lote</Text>
            <TextInput
              style={styles.input}
              value={item.batch_number}
              onChangeText={(value) => updateItem(item.id, 'batch_number', value)}
              placeholder="Ej: LOTE-001"
            />
          </View>
        )}

        {/* Item reason (adjustments) */}
        {movementType === 'adjustment' && (
          <View style={styles.formGroup}>
            <Text style={styles.label}>Razón del Ajuste</Text>
            <TextInput
              style={styles.input}
              value={item.reason}
              onChangeText={(value) => updateItem(item.id, 'reason', value)}
              placeholder="Razón específica para este producto"
            />
          </View>
        )}

        {/* Item notes */}
        <View style={styles.formGroup}>
          <Text style={styles.label}>Notas del Producto</Text>
          <TextInput
            style={[styles.input, styles.textArea]}
            value={item.notes}
            onChangeText={(value) => updateItem(item.id, 'notes', value)}
            placeholder="Notas adicionales..."
            multiline
            numberOfLines={2}
          />
        </View>
      </View>
    );
  };

  if (loading) {
    return (
      <View style={styles.centerContainer}>
        <ActivityIndicator size="large" color="#007bff" />
        <Text style={styles.loadingText}>Cargando datos...</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        <Text style={styles.title}>{getMovementTypeTitle()}</Text>

        {/* Warehouse Selection */}
        <View style={styles.formGroup}>
          <Text style={styles.label}>Almacén *</Text>
          <TouchableOpacity
            style={styles.selectButton}
            onPress={() => openSelectionModal('warehouse', (selectedWarehouse) => {
              setWarehouseId(selectedWarehouse.id);
              setWarehouseName(selectedWarehouse.name);
            })}
          >
            <Text style={[styles.selectButtonText, !warehouseName && styles.placeholderText]}>
              {warehouseName || 'Seleccionar almacén...'}
            </Text>
            <Icon name="arrow-drop-down" size={24} color="#666" />
          </TouchableOpacity>
        </View>

        {/* Supplier (entries only) */}
        {movementType === 'entry' && (
          <View style={styles.formGroup}>
            <Text style={styles.label}>Proveedor</Text>
            <TouchableOpacity
              style={styles.selectButton}
              onPress={() => openSelectionModal('supplier', (selectedSupplier) => {
                setSupplierId(selectedSupplier.id);
                setSupplierName(selectedSupplier.name);
              })}
            >
              <Text style={[styles.selectButtonText, !supplierName && styles.placeholderText]}>
                {supplierName || 'Sin proveedor'}
              </Text>
              <Icon name="arrow-drop-down" size={24} color="#666" />
            </TouchableOpacity>
          </View>
        )}

        {/* Customer (exits only) */}
        {movementType === 'exit' && (
          <View style={styles.formGroup}>
            <Text style={styles.label}>Cliente</Text>
            <TouchableOpacity
              style={styles.selectButton}
              onPress={() => openSelectionModal('customer', (selectedCustomer) => {
                setCustomerId(selectedCustomer.id);
                setCustomerName(selectedCustomer.name);
              })}
            >
              <Text style={[styles.selectButtonText, !customerName && styles.placeholderText]}>
                {customerName || 'Sin cliente'}
              </Text>
              <Icon name="arrow-drop-down" size={24} color="#666" />
            </TouchableOpacity>
          </View>
        )}

        {/* Destination Warehouse (exits/transfers only) */}
        {movementType === 'exit' && (
          <View style={styles.formGroup}>
            <Text style={styles.label}>Almacén Destino</Text>
            <TouchableOpacity
              style={styles.selectButton}
              onPress={() => openSelectionModal('warehouse', (selectedWarehouse) => {
                if (selectedWarehouse.id !== warehouseId) {
                  setDestinationWarehouseId(selectedWarehouse.id);
                  setDestinationWarehouseName(selectedWarehouse.name);
                } else {
                  Alert.alert('Error', 'El almacén destino debe ser diferente al almacén origen');
                }
              })}
            >
              <Text style={[styles.selectButtonText, !destinationWarehouseName && styles.placeholderText]}>
                {destinationWarehouseName || 'Sin destino específico'}
              </Text>
              <Icon name="arrow-drop-down" size={24} color="#666" />
            </TouchableOpacity>
          </View>
        )}

        {/* Reference Number */}
        <View style={styles.formGroup}>
          <Text style={styles.label}>Número de Referencia</Text>
          <TextInput
            style={styles.input}
            value={referenceNumber}
            onChangeText={setReferenceNumber}
            placeholder="Ej: FAC-001, ORD-123"
          />
        </View>

        {/* Reason */}
        <View style={styles.formGroup}>
          <Text style={styles.label}>Razón</Text>
          <TextInput
            style={styles.input}
            value={reason}
            onChangeText={setReason}
            placeholder="Razón del movimiento"
          />
        </View>

        {/* General Notes */}
        <View style={styles.formGroup}>
          <Text style={styles.label}>Notas Generales</Text>
          <TextInput
            style={[styles.input, styles.textArea]}
            value={notes}
            onChangeText={setNotes}
            placeholder="Notas adicionales..."
            multiline
            numberOfLines={3}
          />
        </View>

        {/* Items Section */}
        <View style={styles.itemsSection}>
          <View style={styles.itemsHeader}>
            <Text style={styles.itemsTitle}>Productos</Text>
            <TouchableOpacity onPress={addNewItem} style={styles.addButton}>
              <Icon name="add" size={24} color="#007bff" />
              <Text style={styles.addButtonText}>Agregar</Text>
            </TouchableOpacity>
          </View>

          {items.map((item, index) => renderItemForm(item, index))}
        </View>

        {/* Submit Button */}
        <TouchableOpacity
          style={[styles.submitButton, submitting && styles.disabledButton]}
          onPress={handleSubmit}
          disabled={submitting}
        >
          {submitting ? (
            <ActivityIndicator color="#fff" />
          ) : (
            <Text style={styles.submitButtonText}>
              {movementType === 'entry' ? 'Registrar Entrada' :
               movementType === 'exit' ? 'Registrar Salida' :
               'Registrar Ajuste'}
            </Text>
          )}
        </TouchableOpacity>

        <View style={styles.bottomSpace} />
      </ScrollView>

      {renderSelectionModal()}
      {renderSuccessNotification()}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f8f9fa',
  },
  centerContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#f8f9fa',
  },
  loadingText: {
    marginTop: 10,
    fontSize: 16,
    color: '#666',
  },
  scrollView: {
    flex: 1,
    padding: 16,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 20,
    textAlign: 'center',
  },
  formGroup: {
    marginBottom: 16,
  },
  label: {
    fontSize: 16,
    fontWeight: '500',
    color: '#333',
    marginBottom: 8,
  },
  input: {
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    padding: 12,
    fontSize: 16,
    backgroundColor: '#fff',
  },
  textArea: {
    height: 80,
    textAlignVertical: 'top',
  },
  selectButton: {
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    padding: 12,
    backgroundColor: '#fff',
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  selectButtonText: {
    fontSize: 16,
    color: '#333',
  },
  placeholderText: {
    color: '#999',
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  modalContainer: {
    backgroundColor: '#fff',
    borderRadius: 12,
    margin: 20,
    maxHeight: '80%',
    minWidth: '80%',
  },
  modalHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  modalTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#333',
  },
  modalItem: {
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  modalItemText: {
    fontSize: 16,
    color: '#333',
  },
  itemsSection: {
    marginTop: 20,
  },
  itemsHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  itemsTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#333',
  },
  addButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#e3f2fd',
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: 6,
  },
  addButtonText: {
    marginLeft: 4,
    color: '#007bff',
    fontWeight: '500',
  },
  itemContainer: {
    backgroundColor: '#fff',
    borderRadius: 12,
    padding: 16,
    marginBottom: 16,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  itemHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  itemTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#007bff',
  },
  removeButton: {
    padding: 4,
  },
  submitButton: {
    backgroundColor: '#007bff',
    paddingVertical: 16,
    borderRadius: 8,
    alignItems: 'center',
    marginTop: 20,
  },
  disabledButton: {
    backgroundColor: '#6c757d',
  },
  submitButtonText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: 'bold',
  },
  bottomSpace: {
    height: 20,
  },
  // Estilos para notificación de éxito
  successNotification: {
    position: 'absolute',
    top: 50,
    left: 20,
    right: 20,
    zIndex: 1000,
    elevation: 1000,
  },
  successContent: {
    backgroundColor: '#28a745',
    borderRadius: 12,
    padding: 16,
    flexDirection: 'row',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 8,
    elevation: 8,
  },
  successText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '600',
    marginLeft: 12,
    flex: 1,
  },
});

export default InventoryMultiItemFormScreen;
