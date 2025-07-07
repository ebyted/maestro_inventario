import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  Alert,
  Modal,
  ScrollView,
  TextInput,
  ActivityIndicator,
} from 'react-native';
import { useSelector, useDispatch } from 'react-redux';
import { RootState, AppDispatch } from '../../store/store';
import {
  fetchPurchaseOrders,
  createPurchaseOrder,
  updatePurchaseOrderStatus,
  cancelPurchaseOrder,
  setFilters,
} from '../../store/slices/purchaseOrdersSlice';
import { fetchSuppliers } from '../../store/slices/suppliersSlice';
import { fetchProducts } from '../../store/slices/productSlice';
import { theme } from '../../styles/theme';
import { useTranslation } from 'react-i18next';
import { MaterialIcons } from '@expo/vector-icons';
import {
  PurchaseOrder,
  PurchaseOrderCreate,
  PurchaseOrderStatus,
  PurchaseOrderItemCreate,
} from '../../types';

const PurchaseOrdersScreen: React.FC = () => {
  const dispatch = useDispatch<AppDispatch>();
  const { purchaseOrders, loading, filters } = useSelector((state: RootState) => state.purchaseOrders);
  const { suppliers } = useSelector((state: RootState) => state.suppliers);
  const { selectedBusiness, warehouses } = useSelector((state: RootState) => state.business);
  const { products } = useSelector((state: RootState) => state.products);
  const { t } = useTranslation();

  const [modalVisible, setModalVisible] = useState(false);
  const [formData, setFormData] = useState<PurchaseOrderCreate>({
    supplier_id: 0,
    warehouse_id: 0,
    order_date: new Date().toISOString().split('T')[0],
    items: [],
  });
  const [currentItem, setCurrentItem] = useState<PurchaseOrderItemCreate>({
    product_variant_id: 0,
    quantity_ordered: 0,
    unit_cost: 0,
  });
  const [showProductPicker, setShowProductPicker] = useState(false);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (selectedBusiness) {
      dispatch(fetchPurchaseOrders({ businessId: selectedBusiness.id, params: filters }));
      dispatch(fetchSuppliers(selectedBusiness.id));
      dispatch(fetchProducts(selectedBusiness.id));
    }
  }, [dispatch, selectedBusiness, filters]);

  const getStatusColor = (status: PurchaseOrderStatus) => {
    switch (status) {
      case PurchaseOrderStatus.DRAFT:
        return '#6B7280';
      case PurchaseOrderStatus.PENDING:
        return '#F59E0B';
      case PurchaseOrderStatus.APPROVED:
        return '#3B82F6';
      case PurchaseOrderStatus.ORDERED:
        return '#8B5CF6';
      case PurchaseOrderStatus.PARTIALLY_RECEIVED:
        return '#F97316';
      case PurchaseOrderStatus.RECEIVED:
        return '#10B981';
      case PurchaseOrderStatus.CANCELLED:
        return '#EF4444';
      default:
        return '#6B7280';
    }
  };

  const getStatusText = (status: PurchaseOrderStatus) => {
    switch (status) {
      case PurchaseOrderStatus.DRAFT:
        return 'Borrador';
      case PurchaseOrderStatus.PENDING:
        return 'Pendiente';
      case PurchaseOrderStatus.APPROVED:
        return 'Aprobada';
      case PurchaseOrderStatus.ORDERED:
        return 'Ordenada';
      case PurchaseOrderStatus.PARTIALLY_RECEIVED:
        return 'Parcialmente Recibida';
      case PurchaseOrderStatus.RECEIVED:
        return 'Recibida';
      case PurchaseOrderStatus.CANCELLED:
        return 'Cancelada';
      default:
        return status;
    }
  };

  const handleStatusUpdate = async (purchaseOrder: PurchaseOrder, newStatus: PurchaseOrderStatus) => {
    try {
      await dispatch(updatePurchaseOrderStatus({
        purchaseOrderId: purchaseOrder.id,
        status: newStatus
      })).unwrap();
      Alert.alert('Éxito', 'Estado actualizado correctamente');
    } catch (error) {
      Alert.alert('Error', 'Error al actualizar el estado');
    }
  };

  const handleCancel = async (purchaseOrder: PurchaseOrder) => {
    Alert.alert(
      'Confirmar cancelación',
      `¿Estás seguro de que quieres cancelar la orden ${purchaseOrder.order_number}?`,
      [
        { text: 'No', style: 'cancel' },
        {
          text: 'Sí, cancelar',
          style: 'destructive',
          onPress: async () => {
            try {
              await dispatch(cancelPurchaseOrder(purchaseOrder.id)).unwrap();
              Alert.alert('Éxito', 'Orden cancelada correctamente');
            } catch (error) {
              Alert.alert('Error', 'Error al cancelar la orden');
            }
          },
        },
      ]
    );
  };

  const handleSave = async () => {
    // Validaciones más detalladas
    if (!formData.supplier_id) {
      Alert.alert('Error', 'Debes seleccionar un proveedor');
      return;
    }

    if (!formData.warehouse_id) {
      Alert.alert('Error', 'Debes seleccionar un almacén');
      return;
    }

    if (formData.items.length === 0) {
      Alert.alert('Error', 'Debes agregar al menos un producto');
      return;
    }

    if (!selectedBusiness) {
      Alert.alert('Error', 'No hay negocio seleccionado');
      return;
    }

    // Validar que todos los items tengan datos válidos
    const invalidItems = formData.items.filter(item => 
      !item.product_variant_id || 
      item.quantity_ordered <= 0 || 
      item.unit_cost <= 0
    );

    if (invalidItems.length > 0) {
      Alert.alert('Error', 'Todos los productos deben tener cantidad y costo válidos');
      return;
    }

    try {
      setSaving(true);
      await dispatch(createPurchaseOrder({
        purchaseOrder: formData,
        businessId: selectedBusiness.id
      })).unwrap();
      Alert.alert('Éxito', 'Orden de compra creada correctamente');
      setModalVisible(false);
      resetForm();
    } catch (error) {
      console.error('Error creating purchase order:', error);
      Alert.alert('Error', 'Error al crear la orden de compra. Inténtalo de nuevo.');
    } finally {
      setSaving(false);
    }
  };

  const resetForm = () => {
    setFormData({
      supplier_id: 0,
      warehouse_id: 0,
      order_date: new Date().toISOString().split('T')[0],
      items: [],
    });
    setCurrentItem({
      product_variant_id: 0,
      quantity_ordered: 0,
      unit_cost: 0,
    });
    setShowProductPicker(false);
  };

  const addItem = () => {
    if (!currentItem.product_variant_id) {
      Alert.alert('Error', 'Debes seleccionar un producto');
      return;
    }

    if (currentItem.quantity_ordered <= 0) {
      Alert.alert('Error', 'La cantidad debe ser mayor a 0');
      return;
    }

    if (currentItem.unit_cost <= 0) {
      Alert.alert('Error', 'El costo debe ser mayor a 0');
      return;
    }

    // Verificar si el producto ya está en la lista
    const existingItemIndex = formData.items.findIndex(
      item => item.product_variant_id === currentItem.product_variant_id
    );

    if (existingItemIndex >= 0) {
      // Si ya existe, actualizar la cantidad
      const updatedItems = [...formData.items];
      updatedItems[existingItemIndex].quantity_ordered += currentItem.quantity_ordered;
      setFormData({ ...formData, items: updatedItems });
    } else {
      // Si no existe, agregarlo
      setFormData({
        ...formData,
        items: [...formData.items, currentItem]
      });
    }

    // Limpiar el formulario
    setCurrentItem({
      product_variant_id: 0,
      quantity_ordered: 0,
      unit_cost: 0,
    });
  };

  const removeItem = (index: number) => {
    const updatedItems = formData.items.filter((_, i) => i !== index);
    setFormData({ ...formData, items: updatedItems });
  };

  const renderPurchaseOrder = ({ item }: { item: PurchaseOrder }) => (
    <View style={styles.orderCard}>
      <View style={styles.orderHeader}>
        <View style={styles.orderInfo}>
          <Text style={styles.orderNumber}>{item.order_number}</Text>
          <Text style={styles.supplierName}>{item.supplier?.name}</Text>
        </View>
        <View style={[styles.statusBadge, { backgroundColor: getStatusColor(item.status) }]}>
          <Text style={styles.statusText}>{getStatusText(item.status)}</Text>
        </View>
      </View>

      <View style={styles.orderDetails}>
        <Text style={styles.orderDetail}>
          <Text style={styles.label}>Fecha: </Text>
          {new Date(item.order_date).toLocaleDateString()}
        </Text>
        <Text style={styles.orderDetail}>
          <Text style={styles.label}>Total: </Text>
          ${item.total_amount.toFixed(2)}
        </Text>
        {item.expected_delivery_date && (
          <Text style={styles.orderDetail}>
            <Text style={styles.label}>Entrega esperada: </Text>
            {new Date(item.expected_delivery_date).toLocaleDateString()}
          </Text>
        )}
      </View>

      <View style={styles.orderActions}>
        {item.status === PurchaseOrderStatus.DRAFT && (
          <TouchableOpacity
            style={[styles.actionButton, { backgroundColor: theme.colors.primary }]}
            onPress={() => handleStatusUpdate(item, PurchaseOrderStatus.PENDING)}
          >
            <Text style={styles.actionButtonText}>Enviar</Text>
          </TouchableOpacity>
        )}
        {item.status === PurchaseOrderStatus.PENDING && (
          <TouchableOpacity
            style={[styles.actionButton, { backgroundColor: '#10B981' }]}
            onPress={() => handleStatusUpdate(item, PurchaseOrderStatus.APPROVED)}
          >
            <Text style={styles.actionButtonText}>Aprobar</Text>
          </TouchableOpacity>
        )}
        {item.status !== PurchaseOrderStatus.CANCELLED && item.status !== PurchaseOrderStatus.RECEIVED && (
          <TouchableOpacity
            style={[styles.actionButton, { backgroundColor: theme.colors.error }]}
            onPress={() => handleCancel(item)}
          >
            <Text style={styles.actionButtonText}>Cancelar</Text>
          </TouchableOpacity>
        )}
      </View>
    </View>
  );

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Órdenes de Compra</Text>
        <TouchableOpacity
          style={styles.addButton}
          onPress={() => setModalVisible(true)}
        >
          <MaterialIcons name="add" size={24} color="white" />
        </TouchableOpacity>
      </View>

      {/* Filters */}
      <View style={styles.filters}>
        <TouchableOpacity
          style={[styles.filterButton, !filters.status && styles.filterButtonActive]}
          onPress={() => dispatch(setFilters({ status: undefined }))}
        >
          <Text style={styles.filterButtonText}>Todas</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[styles.filterButton, filters.status === PurchaseOrderStatus.DRAFT && styles.filterButtonActive]}
          onPress={() => dispatch(setFilters({ status: PurchaseOrderStatus.DRAFT }))}
        >
          <Text style={styles.filterButtonText}>Borrador</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[styles.filterButton, filters.status === PurchaseOrderStatus.PENDING && styles.filterButtonActive]}
          onPress={() => dispatch(setFilters({ status: PurchaseOrderStatus.PENDING }))}
        >
          <Text style={styles.filterButtonText}>Pendientes</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[styles.filterButton, filters.status === PurchaseOrderStatus.RECEIVED && styles.filterButtonActive]}
          onPress={() => dispatch(setFilters({ status: PurchaseOrderStatus.RECEIVED }))}
        >
          <Text style={styles.filterButtonText}>Recibidas</Text>
        </TouchableOpacity>
      </View>

      <FlatList
        data={purchaseOrders}
        renderItem={renderPurchaseOrder}
        keyExtractor={(item) => item.id.toString()}
        contentContainerStyle={styles.list}
        refreshing={loading}
        onRefresh={() => selectedBusiness && dispatch(fetchPurchaseOrders({
          businessId: selectedBusiness.id,
          params: filters 
        }))}
      />

      <Modal
        visible={modalVisible}
        animationType="slide"
        presentationStyle="pageSheet"
      >
        <View style={styles.modalContainer}>
          <View style={styles.modalHeader}>
            <TouchableOpacity onPress={() => setModalVisible(false)}>
              <MaterialIcons name="close" size={24} color={theme.colors.text} />
            </TouchableOpacity>
            <Text style={styles.modalTitle}>Nueva Orden de Compra</Text>
            <TouchableOpacity 
              onPress={handleSave}
              disabled={saving}
              style={{ opacity: saving ? 0.6 : 1 }}
            >
              {saving ? (
                <ActivityIndicator size="small" color={theme.colors.primary} />
              ) : (
                <Text style={styles.saveButton}>Guardar</Text>
              )}
            </TouchableOpacity>
          </View>

          <ScrollView style={styles.modalContent}>
            <View style={styles.formGroup}>
              <Text style={styles.label}>Proveedor *</Text>
              <View style={styles.pickerContainer}>
                {suppliers.map(supplier => (
                  <TouchableOpacity
                    key={supplier.id}
                    style={[
                      styles.pickerOption,
                      formData.supplier_id === supplier.id && styles.pickerOptionSelected
                    ]}
                    onPress={() => setFormData({ ...formData, supplier_id: supplier.id })}
                  >
                    <Text style={styles.pickerOptionText}>{supplier.name}</Text>
                  </TouchableOpacity>
                ))}
              </View>
            </View>

            <View style={styles.formGroup}>
              <Text style={styles.label}>Almacén *</Text>
              <View style={styles.pickerContainer}>
                {warehouses
                  .filter(warehouse => warehouse.business_id === selectedBusiness?.id && warehouse.is_active)
                  .map(warehouse => (
                    <TouchableOpacity
                      key={warehouse.id}
                      style={[
                        styles.pickerOption,
                        formData.warehouse_id === warehouse.id && styles.pickerOptionSelected
                      ]}
                      onPress={() => setFormData({ ...formData, warehouse_id: warehouse.id })}
                    >
                      <Text style={styles.pickerOptionText}>{warehouse.name}</Text>
                    </TouchableOpacity>
                  ))}
              </View>
            </View>

            <View style={styles.formGroup}>
              <Text style={styles.label}>Fecha de orden</Text>
              <TextInput
                style={styles.input}
                value={formData.order_date}
                onChangeText={(text) => setFormData({ ...formData, order_date: text })}
                placeholder="YYYY-MM-DD"
              />
            </View>

            <View style={styles.formGroup}>
              <Text style={styles.label}>Productos</Text>
              
              {/* Current items */}
              {formData.items.map((item, index) => {
                const product = products.find(p => p.id === item.product_variant_id);
                return (
                  <View key={index} style={styles.itemRow}>
                    <Text style={styles.itemText}>
                      {product ? product.name : `Producto ID: ${item.product_variant_id}`} - 
                      Cantidad: {item.quantity_ordered} - 
                      Costo: ${item.unit_cost.toFixed(2)}
                    </Text>
                    <TouchableOpacity onPress={() => removeItem(index)}>
                      <MaterialIcons name="delete" size={20} color={theme.colors.error} />
                    </TouchableOpacity>
                  </View>
                );
              })}

              {/* Add new item */}
              <View style={styles.addItemSection}>
                <Text style={styles.subLabel}>Agregar producto</Text>
                
                {/* Product Selector */}
                <View style={styles.formGroup}>
                  <Text style={styles.label}>Producto *</Text>
                  <TouchableOpacity
                    style={styles.input}
                    onPress={() => setShowProductPicker(true)}
                  >
                    <Text style={[
                      styles.pickerOptionText,
                      !currentItem.product_variant_id && { color: theme.colors.textSecondary }
                    ]}>
                      {currentItem.product_variant_id
                        ? products.find(p => p.id === currentItem.product_variant_id)?.name || 'Producto seleccionado'
                        : 'Seleccionar producto'
                      }
                    </Text>
                  </TouchableOpacity>
                </View>

                <View style={styles.row}>
                  <TextInput
                    style={[styles.input, styles.flex1]}
                    placeholder="Cantidad"
                    value={currentItem.quantity_ordered > 0 ? currentItem.quantity_ordered.toString() : ''}
                    onChangeText={(text) => setCurrentItem({
                      ...currentItem,
                      quantity_ordered: parseFloat(text) || 0
                    })}
                    keyboardType="numeric"
                  />
                  <TextInput
                    style={[styles.input, styles.flex1]}
                    placeholder="Costo unitario"
                    value={currentItem.unit_cost > 0 ? currentItem.unit_cost.toString() : ''}
                    onChangeText={(text) => setCurrentItem({
                      ...currentItem,
                      unit_cost: parseFloat(text) || 0
                    })}
                    keyboardType="numeric"
                  />
                  <TouchableOpacity
                    style={styles.addItemButton}
                    onPress={addItem}
                  >
                    <MaterialIcons name="add" size={20} color="white" />
                  </TouchableOpacity>
                </View>
              </View>
            </View>
          </ScrollView>
        </View>
      </Modal>

      {/* Product Picker Modal */}
      <Modal
        visible={showProductPicker}
        animationType="slide"
        presentationStyle="pageSheet"
      >
        <View style={styles.modalContainer}>
          <View style={styles.modalHeader}>
            <TouchableOpacity onPress={() => setShowProductPicker(false)}>
              <MaterialIcons name="close" size={24} color={theme.colors.text} />
            </TouchableOpacity>
            <Text style={styles.modalTitle}>Seleccionar Producto</Text>
            <View style={{ width: 24 }} />
          </View>

          <ScrollView style={styles.modalContent}>
            {products
              .filter(product => product.is_active)
              .map(product => (
                <TouchableOpacity
                  key={product.id}
                  style={[
                    styles.pickerOption,
                    currentItem.product_variant_id === product.id && styles.pickerOptionSelected
                  ]}
                  onPress={() => {
                    setCurrentItem({ ...currentItem, product_variant_id: product.id });
                    setShowProductPicker(false);
                  }}
                >
                  <Text style={styles.pickerOptionText}>{product.name}</Text>
                  {product.sku && (
                    <Text style={styles.productSku}>SKU: {product.sku}</Text>
                  )}
                </TouchableOpacity>
              ))}
          </ScrollView>
        </View>
      </Modal>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: theme.colors.background,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.border,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: theme.colors.text,
  },
  addButton: {
    backgroundColor: theme.colors.primary,
    width: 40,
    height: 40,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
  },
  filters: {
    flexDirection: 'row',
    padding: 16,
    gap: 8,
  },
  filterButton: {
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 16,
    backgroundColor: '#E5E7EB',
  },
  filterButtonActive: {
    backgroundColor: theme.colors.primary,
  },
  filterButtonText: {
    fontSize: 12,
    color: theme.colors.text,
  },
  list: {
    padding: 16,
  },
  orderCard: {
    backgroundColor: 'white',
    padding: 16,
    marginBottom: 12,
    borderRadius: 8,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  orderHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 8,
  },
  orderInfo: {
    flex: 1,
  },
  orderNumber: {
    fontSize: 16,
    fontWeight: 'bold',
    color: theme.colors.text,
  },
  supplierName: {
    fontSize: 14,
    color: theme.colors.textSecondary,
  },
  statusBadge: {
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 12,
  },
  statusText: {
    fontSize: 12,
    color: 'white',
    fontWeight: 'bold',
  },
  orderDetails: {
    marginBottom: 12,
  },
  orderDetail: {
    fontSize: 14,
    color: theme.colors.textSecondary,
    marginBottom: 2,
  },
  label: {
    fontWeight: 'bold',
    color: theme.colors.text,
  },
  orderActions: {
    flexDirection: 'row',
    gap: 8,
  },
  actionButton: {
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 4,
  },
  actionButtonText: {
    color: 'white',
    fontSize: 12,
    fontWeight: 'bold',
  },
  modalContainer: {
    flex: 1,
    backgroundColor: theme.colors.background,
  },
  modalHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.border,
  },
  modalTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: theme.colors.text,
  },
  saveButton: {
    color: theme.colors.primary,
    fontSize: 16,
    fontWeight: 'bold',
  },
  modalContent: {
    flex: 1,
    padding: 16,
  },
  formGroup: {
    marginBottom: 16,
  },
  input: {
    borderWidth: 1,
    borderColor: theme.colors.border,
    borderRadius: 8,
    padding: 12,
    fontSize: 16,
    backgroundColor: 'white',
  },
  pickerContainer: {
    borderWidth: 1,
    borderColor: theme.colors.border,
    borderRadius: 8,
    backgroundColor: 'white',
  },
  pickerOption: {
    padding: 12,
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.border,
  },
  pickerOptionSelected: {
    backgroundColor: theme.colors.primary + '20',
  },
  pickerOptionText: {
    fontSize: 16,
    color: theme.colors.text,
  },
  productSku: {
    fontSize: 12,
    color: theme.colors.textSecondary,
    marginTop: 2,
  },
  itemRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 8,
    backgroundColor: '#F3F4F6',
    borderRadius: 4,
    marginBottom: 4,
  },
  itemText: {
    fontSize: 14,
    color: theme.colors.text,
    flex: 1,
  },
  addItemSection: {
    marginTop: 12,
    padding: 12,
    backgroundColor: '#F9FAFB',
    borderRadius: 8,
  },
  subLabel: {
    fontSize: 14,
    fontWeight: 'bold',
    color: theme.colors.text,
    marginBottom: 8,
  },
  row: {
    flexDirection: 'row',
    gap: 8,
    alignItems: 'center',
  },
  flex1: {
    flex: 1,
  },
  addItemButton: {
    backgroundColor: theme.colors.primary,
    width: 32,
    height: 32,
    borderRadius: 16,
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default PurchaseOrdersScreen;
