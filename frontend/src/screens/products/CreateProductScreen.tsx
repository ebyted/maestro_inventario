import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TextInput,
  TouchableOpacity,
  Alert,
  ActivityIndicator,
} from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { useDispatch, useSelector } from 'react-redux';
import { createProduct } from '../../store/slices/productSlice';
import { RootState } from '../../store/store';

const CreateProductScreen: React.FC = () => {
  const navigation = useNavigation();
  const dispatch = useDispatch();
  const { selectedBusiness } = useSelector((state: RootState) => state.business);
  const { loading } = useSelector((state: RootState) => state.products);

  const [formData, setFormData] = useState({
    name: '',
    description: '',
    sku: '',
    barcode: '',
    category_id: '',
    brand_id: '',
    base_unit_id: '',
    minimum_stock: '',
    maximum_stock: '',
  });

  const handleSubmit = async () => {
    if (!formData.name.trim()) {
      Alert.alert('Error', 'El nombre del producto es requerido');
      return;
    }

    if (!selectedBusiness) {
      Alert.alert('Error', 'No hay negocio seleccionado');
      return;
    }

    try {
      const productData = {
        ...formData,
        business_id: selectedBusiness.id,
        category_id: formData.category_id ? parseInt(formData.category_id) : null,
        brand_id: formData.brand_id ? parseInt(formData.brand_id) : null,
        base_unit_id: formData.base_unit_id ? parseInt(formData.base_unit_id) : null,
        minimum_stock: formData.minimum_stock ? parseFloat(formData.minimum_stock) : null,
        maximum_stock: formData.maximum_stock ? parseFloat(formData.maximum_stock) : null,
      };

      dispatch(createProduct(productData) as any);
      Alert.alert('Éxito', 'Producto creado exitosamente', [
        { text: 'OK', onPress: () => navigation.goBack() }
      ]);
    } catch (error: any) {
      Alert.alert('Error', error.message || 'Error al crear el producto');
    }
  };

  return (
    <View style={styles.container}>
      <ScrollView style={styles.scrollView} contentContainerStyle={styles.scrollContent}>
        <View style={styles.formGroup}>
          <Text style={styles.label}>Nombre del Producto *</Text>
          <TextInput
            style={styles.input}
            value={formData.name}
            onChangeText={(text) => setFormData({ ...formData, name: text })}
            placeholder="Ingrese el nombre del producto"
            placeholderTextColor="#999999"
          />
        </View>

        <View style={styles.formGroup}>
          <Text style={styles.label}>Descripción</Text>
          <TextInput
            style={[styles.input, styles.textArea]}
            value={formData.description}
            onChangeText={(text) => setFormData({ ...formData, description: text })}
            placeholder="Descripción del producto"
            placeholderTextColor="#999999"
            multiline
            numberOfLines={3}
          />
        </View>

        <View style={styles.formGroup}>
          <Text style={styles.label}>SKU</Text>
          <TextInput
            style={styles.input}
            value={formData.sku}
            onChangeText={(text) => setFormData({ ...formData, sku: text })}
            placeholder="Código SKU único"
            placeholderTextColor="#999999"
          />
        </View>

        <View style={styles.formGroup}>
          <Text style={styles.label}>Código de Barras</Text>
          <TextInput
            style={styles.input}
            value={formData.barcode}
            onChangeText={(text) => setFormData({ ...formData, barcode: text })}
            placeholder="Código de barras"
            placeholderTextColor="#999999"
          />
        </View>

        <View style={styles.formGroup}>
          <Text style={styles.label}>Stock Mínimo</Text>
          <TextInput
            style={styles.input}
            value={formData.minimum_stock}
            onChangeText={(text) => setFormData({ ...formData, minimum_stock: text })}
            placeholder="0"
            placeholderTextColor="#999999"
            keyboardType="numeric"
          />
        </View>

        <View style={styles.formGroup}>
          <Text style={styles.label}>Stock Máximo</Text>
          <TextInput
            style={styles.input}
            value={formData.maximum_stock}
            onChangeText={(text) => setFormData({ ...formData, maximum_stock: text })}
            placeholder="100"
            placeholderTextColor="#999999"
            keyboardType="numeric"
          />
        </View>

        <TouchableOpacity
          style={[styles.submitButton, loading && styles.disabledButton]}
          onPress={handleSubmit}
          disabled={loading}
        >
          {loading ? (
            <ActivityIndicator color="white" />
          ) : (
            <Text style={styles.submitButtonText}>Crear Producto</Text>
          )}
        </TouchableOpacity>
      </ScrollView>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#ffffff',
  },
  scrollView: {
    flex: 1,
  },
  scrollContent: {
    padding: 16,
    paddingBottom: 32,
  },
  formGroup: {
    marginBottom: 16,
  },
  label: {
    fontSize: 16,
    fontWeight: '600',
    color: '#000000',
    marginBottom: 8,
  },
  input: {
    borderWidth: 1,
    borderColor: '#e0e0e0',
    borderRadius: 8,
    padding: 12,
    fontSize: 16,
    color: '#000000',
    backgroundColor: '#f9f9f9',
  },
  textArea: {
    height: 80,
    textAlignVertical: 'top',
  },
  submitButton: {
    backgroundColor: '#007bff',
    padding: 16,
    borderRadius: 8,
    alignItems: 'center',
    marginTop: 16,
  },
  disabledButton: {
    opacity: 0.6,
  },
  submitButtonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: '600',
  },
});

export default CreateProductScreen;
