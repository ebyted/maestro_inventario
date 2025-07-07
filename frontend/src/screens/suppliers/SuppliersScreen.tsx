import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  Alert,
  RefreshControl,
  TextInput,
  Modal,
  ScrollView,
} from 'react-native';
import { useSelector, useDispatch } from 'react-redux';
import { RootState, AppDispatch } from '../../store/store';
import { fetchSuppliers, createSupplier, updateSupplier, deleteSupplier } from '../../store/slices/suppliersSlice';
import { theme } from '../../styles/theme';
import { useTranslation } from 'react-i18next';
import Icon from 'react-native-vector-icons/MaterialIcons';
import { Supplier, SupplierCreate } from '../../types';

const SuppliersScreen: React.FC = () => {
  const dispatch = useDispatch<AppDispatch>();
  const { suppliers, loading, error } = useSelector((state: RootState) => state.suppliers);
  const { selectedBusiness } = useSelector((state: RootState) => state.business);
  const { t } = useTranslation();
  
  const [modalVisible, setModalVisible] = useState(false);
  const [editingSupplier, setEditingSupplier] = useState<Supplier | null>(null);
  const [formData, setFormData] = useState<SupplierCreate>({
    name: '',
    contact_person: '',
    email: '',
    phone: '',
    address: '',
    city: '',
    state: '',
    country: '',
    postal_code: '',
    tax_id: '',
    website: '',
    payment_terms: '',
    credit_limit: 0,
  });

  useEffect(() => {
    if (selectedBusiness) {
      dispatch(fetchSuppliers(selectedBusiness.id));
    }
  }, [dispatch, selectedBusiness]);

  const resetForm = () => {
    setFormData({
      name: '',
      contact_person: '',
      email: '',
      phone: '',
      address: '',
      city: '',
      state: '',
      country: '',
      postal_code: '',
      tax_id: '',
      website: '',
      payment_terms: '',
      credit_limit: 0,
    });
    setEditingSupplier(null);
  };

  const openModal = (supplier?: Supplier) => {
    if (supplier) {
      setEditingSupplier(supplier);
      setFormData({
        name: supplier.name,
        contact_person: supplier.contact_person || '',
        email: supplier.email || '',
        phone: supplier.phone || '',
        address: supplier.address || '',
        city: supplier.city || '',
        state: supplier.state || '',
        country: supplier.country || '',
        postal_code: supplier.postal_code || '',
        tax_id: supplier.tax_id || '',
        website: supplier.website || '',
        payment_terms: supplier.payment_terms || '',
        credit_limit: supplier.credit_limit || 0,
      });
    } else {
      resetForm();
    }
    setModalVisible(true);
  };

  const closeModal = () => {
    setModalVisible(false);
    resetForm();
  };

  const handleSave = async () => {
    if (!formData.name.trim()) {
      Alert.alert('Error', 'El nombre del proveedor es requerido');
      return;
    }

    if (!selectedBusiness) {
      Alert.alert('Error', 'No hay negocio seleccionado');
      return;
    }

    try {
      if (editingSupplier) {
        await dispatch(updateSupplier({
          supplierId: editingSupplier.id,
          supplier: formData
        })).unwrap();
        Alert.alert('Éxito', 'Proveedor actualizado correctamente');
      } else {
        await dispatch(createSupplier({
          supplier: formData,
          businessId: selectedBusiness.id
        })).unwrap();
        Alert.alert('Éxito', 'Proveedor creado correctamente');
      }
      closeModal();
    } catch (error) {
      Alert.alert('Error', 'Error al guardar el proveedor');
    }
  };

  const handleDelete = (supplier: Supplier) => {
    Alert.alert(
      'Confirmar eliminación',
      `¿Estás seguro de que quieres eliminar el proveedor "${supplier.name}"?`,
      [
        { text: 'Cancelar', style: 'cancel' },
        {
          text: 'Eliminar',
          style: 'destructive',
          onPress: async () => {
            try {
              await dispatch(deleteSupplier(supplier.id)).unwrap();
              Alert.alert('Éxito', 'Proveedor eliminado correctamente');
            } catch (error) {
              Alert.alert('Error', 'Error al eliminar el proveedor');
            }
          },
        },
      ]
    );
  };

  const renderSupplier = ({ item }: { item: Supplier }) => (
    <View style={styles.supplierCard}>
      <View style={styles.supplierHeader}>
        <Text style={styles.supplierName}>{item.name}</Text>
        <View style={styles.actions}>
          <TouchableOpacity
            style={styles.actionButton}
            onPress={() => openModal(item)}
          >
            <Icon name="edit" size={20} color={theme.colors.primary} />
          </TouchableOpacity>
          <TouchableOpacity
            style={styles.actionButton}
            onPress={() => handleDelete(item)}
          >
            <Icon name="delete" size={20} color={theme.colors.error} />
          </TouchableOpacity>
        </View>
      </View>
      
      <View style={styles.supplierDetails}>
        {item.contact_person && (
          <Text style={styles.supplierDetail}>
            <Text style={styles.label}>Contacto: </Text>
            {item.contact_person}
          </Text>
        )}
        {item.email && (
          <Text style={styles.supplierDetail}>
            <Text style={styles.label}>Email: </Text>
            {item.email}
          </Text>
        )}
        {item.phone && (
          <Text style={styles.supplierDetail}>
            <Text style={styles.label}>Teléfono: </Text>
            {item.phone}
          </Text>
        )}
        {item.address && (
          <Text style={styles.supplierDetail}>
            <Text style={styles.label}>Dirección: </Text>
            {item.address}
          </Text>
        )}
      </View>
    </View>
  );

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Proveedores</Text>
        <TouchableOpacity
          style={styles.addButton}
          onPress={() => openModal()}
        >
          <Icon name="add" size={24} color="white" />
        </TouchableOpacity>
      </View>

      <FlatList
        data={suppliers}
        renderItem={renderSupplier}
        keyExtractor={(item) => item.id.toString()}
        contentContainerStyle={styles.list}
        refreshing={loading}
        onRefresh={() => selectedBusiness && dispatch(fetchSuppliers(selectedBusiness.id))}
      />

      <Modal
        visible={modalVisible}
        animationType="slide"
        presentationStyle="pageSheet"
      >
        <View style={styles.modalContainer}>
          <View style={styles.modalHeader}>
            <TouchableOpacity onPress={closeModal}>
              <Icon name="close" size={24} color={theme.colors.text} />
            </TouchableOpacity>
            <Text style={styles.modalTitle}>
              {editingSupplier ? 'Editar Proveedor' : 'Nuevo Proveedor'}
            </Text>
            <TouchableOpacity onPress={handleSave}>
              <Text style={styles.saveButton}>Guardar</Text>
            </TouchableOpacity>
          </View>

          <ScrollView style={styles.modalContent}>
            <View style={styles.formGroup}>
              <Text style={styles.label}>Nombre *</Text>
              <TextInput
                style={styles.input}
                value={formData.name}
                onChangeText={(text) => setFormData({ ...formData, name: text })}
                placeholder="Nombre del proveedor"
              />
            </View>

            <View style={styles.formGroup}>
              <Text style={styles.label}>Persona de contacto</Text>
              <TextInput
                style={styles.input}
                value={formData.contact_person}
                onChangeText={(text) => setFormData({ ...formData, contact_person: text })}
                placeholder="Nombre del contacto"
              />
            </View>

            <View style={styles.formGroup}>
              <Text style={styles.label}>Email</Text>
              <TextInput
                style={styles.input}
                value={formData.email}
                onChangeText={(text) => setFormData({ ...formData, email: text })}
                placeholder="email@ejemplo.com"
                keyboardType="email-address"
                autoCapitalize="none"
              />
            </View>

            <View style={styles.formGroup}>
              <Text style={styles.label}>Teléfono</Text>
              <TextInput
                style={styles.input}
                value={formData.phone}
                onChangeText={(text) => setFormData({ ...formData, phone: text })}
                placeholder="Número de teléfono"
                keyboardType="phone-pad"
              />
            </View>

            <View style={styles.formGroup}>
              <Text style={styles.label}>Dirección</Text>
              <TextInput
                style={styles.input}
                value={formData.address}
                onChangeText={(text) => setFormData({ ...formData, address: text })}
                placeholder="Dirección completa"
                multiline
              />
            </View>

            <View style={styles.row}>
              <View style={styles.halfWidth}>
                <Text style={styles.label}>Ciudad</Text>
                <TextInput
                  style={styles.input}
                  value={formData.city}
                  onChangeText={(text) => setFormData({ ...formData, city: text })}
                  placeholder="Ciudad"
                />
              </View>

              <View style={styles.halfWidth}>
                <Text style={styles.label}>Estado</Text>
                <TextInput
                  style={styles.input}
                  value={formData.state}
                  onChangeText={(text) => setFormData({ ...formData, state: text })}
                  placeholder="Estado"
                />
              </View>
            </View>

            <View style={styles.row}>
              <View style={styles.halfWidth}>
                <Text style={styles.label}>País</Text>
                <TextInput
                  style={styles.input}
                  value={formData.country}
                  onChangeText={(text) => setFormData({ ...formData, country: text })}
                  placeholder="País"
                />
              </View>

              <View style={styles.halfWidth}>
                <Text style={styles.label}>Código postal</Text>
                <TextInput
                  style={styles.input}
                  value={formData.postal_code}
                  onChangeText={(text) => setFormData({ ...formData, postal_code: text })}
                  placeholder="CP"
                />
              </View>
            </View>

            <View style={styles.formGroup}>
              <Text style={styles.label}>NIT/Tax ID</Text>
              <TextInput
                style={styles.input}
                value={formData.tax_id}
                onChangeText={(text) => setFormData({ ...formData, tax_id: text })}
                placeholder="Número de identificación fiscal"
              />
            </View>

            <View style={styles.formGroup}>
              <Text style={styles.label}>Sitio web</Text>
              <TextInput
                style={styles.input}
                value={formData.website}
                onChangeText={(text) => setFormData({ ...formData, website: text })}
                placeholder="https://www.ejemplo.com"
                autoCapitalize="none"
              />
            </View>

            <View style={styles.formGroup}>
              <Text style={styles.label}>Términos de pago</Text>
              <TextInput
                style={styles.input}
                value={formData.payment_terms}
                onChangeText={(text) => setFormData({ ...formData, payment_terms: text })}
                placeholder="Ej: 30 días, contado, etc."
              />
            </View>

            <View style={styles.formGroup}>
              <Text style={styles.label}>Límite de crédito</Text>
              <TextInput
                style={styles.input}
                value={formData.credit_limit?.toString() || '0'}
                onChangeText={(text) => setFormData({ ...formData, credit_limit: parseFloat(text) || 0 })}
                placeholder="0.00"
                keyboardType="numeric"
              />
            </View>
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
  list: {
    padding: 16,
  },
  supplierCard: {
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
  supplierHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 8,
  },
  supplierName: {
    fontSize: 18,
    fontWeight: 'bold',
    color: theme.colors.text,
    flex: 1,
  },
  actions: {
    flexDirection: 'row',
    gap: 8,
  },
  actionButton: {
    padding: 8,
  },
  supplierDetails: {
    gap: 4,
  },
  supplierDetail: {
    fontSize: 14,
    color: theme.colors.textSecondary,
  },
  label: {
    fontWeight: 'bold',
    color: theme.colors.text,
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
  row: {
    flexDirection: 'row',
    gap: 12,
  },
  halfWidth: {
    flex: 1,
  },
});

export default SuppliersScreen;
