import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  Modal,
  TouchableOpacity,
  StyleSheet,
  ScrollView,
  TextInput,
  Switch,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { theme } from '../styles/theme';

export interface FilterOptions {
  category?: string;
  minPrice?: number;
  maxPrice?: number;
  minStock?: number;
  maxStock?: number;
  hasVariants?: boolean;
  status?: 'active' | 'inactive';
  lowStock?: boolean;
  outOfStock?: boolean;
  productType?: 'product' | 'service';
}

interface FilterModalProps {
  visible: boolean;
  onClose: () => void;
  onApplyFilters: (filters: FilterOptions) => void;
  initialFilters?: FilterOptions;
  categories?: Array<{ id: string; name: string }>;
}

const FilterModal: React.FC<FilterModalProps> = ({
  visible,
  onClose,
  onApplyFilters,
  initialFilters = {},
  categories = [],
}) => {
  const [filters, setFilters] = useState<FilterOptions>(initialFilters);
  const [selectedCategory, setSelectedCategory] = useState<string | undefined>(initialFilters.category);

  useEffect(() => {
    setFilters(initialFilters);
    setSelectedCategory(initialFilters.category);
  }, [initialFilters]);

  const handleApplyFilters = () => {
    const finalFilters = {
      ...filters,
      category: selectedCategory,
    };
    onApplyFilters(finalFilters);
    onClose();
  };

  const handleClearFilters = () => {
    const clearedFilters: FilterOptions = {};
    setFilters(clearedFilters);
    setSelectedCategory(undefined);
    onApplyFilters(clearedFilters);
    onClose();
  };

  const updateFilter = (key: keyof FilterOptions, value: any) => {
    setFilters(prev => ({
      ...prev,
      [key]: value,
    }));
  };

  const renderCategorySection = () => (
    <View style={styles.section}>
      <Text style={styles.sectionTitle}>Categoría</Text>
      <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.categoryScroll}>
        <TouchableOpacity
          style={[
            styles.categoryChip,
            !selectedCategory && styles.categoryChipSelected,
          ]}
          onPress={() => setSelectedCategory(undefined)}
        >
          <Text style={[
            styles.categoryChipText,
            !selectedCategory && styles.categoryChipTextSelected,
          ]}>
            Todas
          </Text>
        </TouchableOpacity>
        {categories.map((category) => (
          <TouchableOpacity
            key={category.id}
            style={[
              styles.categoryChip,
              selectedCategory === category.id && styles.categoryChipSelected,
            ]}
            onPress={() => setSelectedCategory(category.id)}
          >
            <Text style={[
              styles.categoryChipText,
              selectedCategory === category.id && styles.categoryChipTextSelected,
            ]}>
              {category.name}
            </Text>
          </TouchableOpacity>
        ))}
      </ScrollView>
    </View>
  );

  const renderPriceSection = () => (
    <View style={styles.section}>
      <Text style={styles.sectionTitle}>Rango de Precio</Text>
      <View style={styles.rangeContainer}>
        <View style={styles.inputContainer}>
          <Text style={styles.inputLabel}>Desde</Text>
          <TextInput
            style={styles.input}
            placeholder="0.00"
            value={filters.minPrice?.toString() || ''}
            onChangeText={(text) => updateFilter('minPrice', text ? parseFloat(text) : undefined)}
            keyboardType="numeric"
          />
        </View>
        <View style={styles.inputContainer}>
          <Text style={styles.inputLabel}>Hasta</Text>
          <TextInput
            style={styles.input}
            placeholder="999999.99"
            value={filters.maxPrice?.toString() || ''}
            onChangeText={(text) => updateFilter('maxPrice', text ? parseFloat(text) : undefined)}
            keyboardType="numeric"
          />
        </View>
      </View>
    </View>
  );

  const renderStockSection = () => (
    <View style={styles.section}>
      <Text style={styles.sectionTitle}>Rango de Stock</Text>
      <View style={styles.rangeContainer}>
        <View style={styles.inputContainer}>
          <Text style={styles.inputLabel}>Stock Mínimo</Text>
          <TextInput
            style={styles.input}
            placeholder="0"
            value={filters.minStock?.toString() || ''}
            onChangeText={(text) => updateFilter('minStock', text ? parseInt(text) : undefined)}
            keyboardType="numeric"
          />
        </View>
        <View style={styles.inputContainer}>
          <Text style={styles.inputLabel}>Stock Máximo</Text>
          <TextInput
            style={styles.input}
            placeholder="999999"
            value={filters.maxStock?.toString() || ''}
            onChangeText={(text) => updateFilter('maxStock', text ? parseInt(text) : undefined)}
            keyboardType="numeric"
          />
        </View>
      </View>
    </View>
  );

  const renderStatusSection = () => (
    <View style={styles.section}>
      <Text style={styles.sectionTitle}>Estado y Tipo</Text>
      
      <View style={styles.switchContainer}>
        <Text style={styles.switchLabel}>Solo productos con variantes</Text>
        <Switch
          value={filters.hasVariants || false}
          onValueChange={(value) => updateFilter('hasVariants', value)}
          trackColor={{ false: theme.colors.lightGray, true: theme.colors.primary }}
          thumbColor={filters.hasVariants ? theme.colors.white : theme.colors.gray}
        />
      </View>

      <View style={styles.switchContainer}>
        <Text style={styles.switchLabel}>Stock bajo</Text>
        <Switch
          value={filters.lowStock || false}
          onValueChange={(value) => updateFilter('lowStock', value)}
          trackColor={{ false: theme.colors.lightGray, true: theme.colors.warning }}
          thumbColor={filters.lowStock ? theme.colors.white : theme.colors.gray}
        />
      </View>

      <View style={styles.switchContainer}>
        <Text style={styles.switchLabel}>Sin stock</Text>
        <Switch
          value={filters.outOfStock || false}
          onValueChange={(value) => updateFilter('outOfStock', value)}
          trackColor={{ false: theme.colors.lightGray, true: theme.colors.error }}
          thumbColor={filters.outOfStock ? theme.colors.white : theme.colors.gray}
        />
      </View>

      <Text style={styles.subSectionTitle}>Tipo de producto</Text>
      <View style={styles.typeContainer}>
        <TouchableOpacity
          style={[
            styles.typeButton,
            filters.productType === 'product' && styles.typeButtonSelected,
          ]}
          onPress={() => updateFilter('productType', filters.productType === 'product' ? undefined : 'product')}
        >
          <Text style={[
            styles.typeButtonText,
            filters.productType === 'product' && styles.typeButtonTextSelected,
          ]}>
            Producto
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[
            styles.typeButton,
            filters.productType === 'service' && styles.typeButtonSelected,
          ]}
          onPress={() => updateFilter('productType', filters.productType === 'service' ? undefined : 'service')}
        >
          <Text style={[
            styles.typeButtonText,
            filters.productType === 'service' && styles.typeButtonTextSelected,
          ]}>
            Servicio
          </Text>
        </TouchableOpacity>
      </View>

      <Text style={styles.subSectionTitle}>Estado</Text>
      <View style={styles.typeContainer}>
        <TouchableOpacity
          style={[
            styles.typeButton,
            filters.status === 'active' && styles.typeButtonSelected,
          ]}
          onPress={() => updateFilter('status', filters.status === 'active' ? undefined : 'active')}
        >
          <Text style={[
            styles.typeButtonText,
            filters.status === 'active' && styles.typeButtonTextSelected,
          ]}>
            Activo
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[
            styles.typeButton,
            filters.status === 'inactive' && styles.typeButtonSelected,
          ]}
          onPress={() => updateFilter('status', filters.status === 'inactive' ? undefined : 'inactive')}
        >
          <Text style={[
            styles.typeButtonText,
            filters.status === 'inactive' && styles.typeButtonTextSelected,
          ]}>
            Inactivo
          </Text>
        </TouchableOpacity>
      </View>
    </View>
  );

  return (
    <Modal
      visible={visible}
      animationType="slide"
      presentationStyle="pageSheet"
      onRequestClose={onClose}
    >
      <View style={styles.container}>
        {/* Header */}
        <View style={styles.header}>
          <TouchableOpacity onPress={onClose} style={styles.closeButton}>
            <Ionicons name="close" size={24} color={theme.colors.text} />
          </TouchableOpacity>
          <Text style={styles.title}>Filtros</Text>
          <TouchableOpacity onPress={handleClearFilters} style={styles.clearButton}>
            <Text style={styles.clearButtonText}>Limpiar</Text>
          </TouchableOpacity>
        </View>

        {/* Content */}
        <ScrollView style={styles.content} showsVerticalScrollIndicator={false}>
          {renderCategorySection()}
          {renderPriceSection()}
          {renderStockSection()}
          {renderStatusSection()}
        </ScrollView>

        {/* Footer */}
        <View style={styles.footer}>
          <TouchableOpacity
            style={styles.applyButton}
            onPress={handleApplyFilters}
          >
            <Text style={styles.applyButtonText}>Aplicar Filtros</Text>
          </TouchableOpacity>
        </View>
      </View>
    </Modal>
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
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.lightGray,
    backgroundColor: theme.colors.white,
  },
  closeButton: {
    padding: 8,
  },
  title: {
    fontSize: 18,
    fontWeight: '600',
    color: theme.colors.text,
  },
  clearButton: {
    padding: 8,
  },
  clearButtonText: {
    color: theme.colors.primary,
    fontSize: 16,
    fontWeight: '500',
  },
  content: {
    flex: 1,
    padding: 16,
  },
  section: {
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: theme.colors.text,
    marginBottom: 12,
  },
  subSectionTitle: {
    fontSize: 14,
    fontWeight: '500',
    color: theme.colors.text,
    marginTop: 16,
    marginBottom: 8,
  },
  categoryScroll: {
    flexDirection: 'row',
  },
  categoryChip: {
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 20,
    backgroundColor: theme.colors.lightGray,
    marginRight: 8,
  },
  categoryChipSelected: {
    backgroundColor: theme.colors.primary,
  },
  categoryChipText: {
    color: theme.colors.text,
    fontSize: 14,
  },
  categoryChipTextSelected: {
    color: theme.colors.white,
    fontWeight: '500',
  },
  rangeContainer: {
    flexDirection: 'row',
    gap: 12,
  },
  inputContainer: {
    flex: 1,
  },
  inputLabel: {
    fontSize: 14,
    color: theme.colors.textSecondary,
    marginBottom: 4,
  },
  input: {
    borderWidth: 1,
    borderColor: theme.colors.lightGray,
    borderRadius: 8,
    padding: 12,
    fontSize: 16,
    backgroundColor: theme.colors.white,
  },
  switchContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: 8,
  },
  switchLabel: {
    fontSize: 14,
    color: theme.colors.text,
    flex: 1,
  },
  typeContainer: {
    flexDirection: 'row',
    gap: 8,
  },
  typeButton: {
    flex: 1,
    paddingVertical: 10,
    paddingHorizontal: 16,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: theme.colors.lightGray,
    backgroundColor: theme.colors.white,
    alignItems: 'center',
  },
  typeButtonSelected: {
    backgroundColor: theme.colors.primary,
    borderColor: theme.colors.primary,
  },
  typeButtonText: {
    fontSize: 14,
    color: theme.colors.text,
  },
  typeButtonTextSelected: {
    color: theme.colors.white,
    fontWeight: '500',
  },
  footer: {
    padding: 16,
    backgroundColor: theme.colors.white,
    borderTopWidth: 1,
    borderTopColor: theme.colors.lightGray,
  },
  applyButton: {
    backgroundColor: theme.colors.primary,
    borderRadius: 8,
    paddingVertical: 14,
    alignItems: 'center',
  },
  applyButtonText: {
    color: theme.colors.white,
    fontSize: 16,
    fontWeight: '600',
  },
});

export default FilterModal;
