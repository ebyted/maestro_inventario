import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TextInput,
  TouchableOpacity,
  Alert,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { useTranslation } from 'react-i18next';

interface InventoryMovementSimpleScreenProps {
  navigation: any;
  route: {
    params: {
      movementType: 'entry' | 'exit' | 'adjustment';
    };
  };
}

const InventoryMovementSimpleScreen: React.FC<InventoryMovementSimpleScreenProps> = ({ 
  navigation, 
  route 
}) => {
  const { t } = useTranslation();
  const { movementType } = route.params;
  
  const [selectedWarehouse, setSelectedWarehouse] = useState('Almacén Principal');
  const [reference, setReference] = useState('');
  const [notes, setNotes] = useState('');
  const [quantity, setQuantity] = useState('');
  const [productName, setProductName] = useState('');

  const getMovementTitle = () => {
    switch (movementType) {
      case 'entry':
        return 'Entrada de Inventario';
      case 'exit':
        return 'Salida de Inventario';
      case 'adjustment':
        return 'Ajuste de Inventario';
      default:
        return 'Movimiento de Inventario';
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
        return '#4CAF50';
      case 'exit':
        return '#FF9800';
      case 'adjustment':
        return '#2196F3';
      default:
        return '#757575';
    }
  };

  const processMovement = () => {
    if (!productName || !quantity) {
      Alert.alert('Error', 'Por favor complete todos los campos requeridos');
      return;
    }

    // Mostrar notificación visual de éxito
    Alert.alert(
      '🎉 ¡Éxito!',
      `✅ ${getMovementTitle()} procesado exitosamente`,
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
  };

  return (
    <SafeAreaView style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <Ionicons name="arrow-back" size={24} color="#212121" />
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
        {/* Warehouse Selection */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Almacén</Text>
          <View style={styles.warehouseContainer}>
            <TouchableOpacity style={styles.warehouseSelected}>
              <Text style={styles.warehouseSelectedText}>{selectedWarehouse}</Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* Movement Info */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Información del Movimiento</Text>
          
          <View style={styles.inputGroup}>
            <Text style={styles.inputLabel}>Referencia</Text>
            <TextInput
              style={styles.input}
              value={reference}
              onChangeText={setReference}
              placeholder="Número de referencia"
              placeholderTextColor="#757575"
            />
          </View>

          <View style={styles.inputGroup}>
            <Text style={styles.inputLabel}>Notas</Text>
            <TextInput
              style={[styles.input, styles.notesInput]}
              value={notes}
              onChangeText={setNotes}
              placeholder="Notas adicionales"
              placeholderTextColor="#757575"
              multiline
              numberOfLines={3}
            />
          </View>
        </View>

        {/* Product Info */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Producto</Text>
          
          <View style={styles.inputGroup}>
            <Text style={styles.inputLabel}>Nombre del Producto *</Text>
            <TextInput
              style={styles.input}
              value={productName}
              onChangeText={setProductName}
              placeholder="Nombre del producto"
              placeholderTextColor="#757575"
            />
          </View>

          <View style={styles.inputGroup}>
            <Text style={styles.inputLabel}>Cantidad *</Text>
            <TextInput
              style={styles.input}
              value={quantity}
              onChangeText={setQuantity}
              placeholder="0"
              placeholderTextColor="#757575"
              keyboardType="numeric"
            />
          </View>

          {movementType === 'entry' && (
            <View style={styles.inputGroup}>
              <Text style={styles.inputLabel}>Costo Unitario</Text>
              <TextInput
                style={styles.input}
                placeholder="0.00"
                placeholderTextColor="#757575"
                keyboardType="numeric"
              />
            </View>
          )}
        </View>

        {/* Demo Message */}
        <View style={styles.demoMessage}>
          <Ionicons name="information-circle" size={20} color="#2196F3" />
          <Text style={styles.demoText}>
            Esta es una pantalla de demostración. En la versión completa, aquí podrías 
            seleccionar productos desde el catálogo y procesar movimientos reales.
          </Text>
        </View>
      </ScrollView>

      {/* Footer */}
      <View style={styles.footer}>
        <TouchableOpacity
          style={[styles.processButton, { backgroundColor: getMovementColor() }]}
          onPress={processMovement}
        >
          <Ionicons name="checkmark" size={20} color="#FFFFFF" />
          <Text style={styles.processButtonText}>
            Procesar {movementType === 'entry' ? 'Entrada' : 
                     movementType === 'exit' ? 'Salida' : 'Ajuste'}
          </Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5F5F5',
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    paddingVertical: 12,
    backgroundColor: '#FFFFFF',
    borderBottomWidth: 1,
    borderBottomColor: '#E0E0E0',
  },
  headerTitle: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  headerText: {
    fontSize: 18,
    fontWeight: '600',
    color: '#212121',
  },
  content: {
    flex: 1,
    paddingHorizontal: 16,
  },
  section: {
    backgroundColor: '#FFFFFF',
    borderRadius: 8,
    padding: 16,
    marginVertical: 8,
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#212121',
    marginBottom: 12,
  },
  warehouseContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  warehouseSelected: {
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 20,
    backgroundColor: '#2196F3',
  },
  warehouseSelectedText: {
    color: '#FFFFFF',
    fontSize: 14,
    fontWeight: '500',
  },
  inputGroup: {
    marginBottom: 16,
  },
  inputLabel: {
    fontSize: 14,
    fontWeight: '500',
    color: '#212121',
    marginBottom: 6,
  },
  input: {
    borderWidth: 1,
    borderColor: '#E0E0E0',
    borderRadius: 8,
    paddingHorizontal: 12,
    paddingVertical: 10,
    fontSize: 16,
    color: '#212121',
    backgroundColor: '#FFFFFF',
  },
  notesInput: {
    height: 80,
    textAlignVertical: 'top',
  },
  demoMessage: {
    flexDirection: 'row',
    backgroundColor: '#E3F2FD',
    padding: 16,
    borderRadius: 8,
    marginVertical: 16,
    alignItems: 'flex-start',
  },
  demoText: {
    flex: 1,
    marginLeft: 8,
    fontSize: 14,
    color: '#1976D2',
    lineHeight: 20,
  },
  footer: {
    padding: 16,
    backgroundColor: '#FFFFFF',
    borderTopWidth: 1,
    borderTopColor: '#E0E0E0',
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
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: '600',
  },
});

export default InventoryMovementSimpleScreen;
