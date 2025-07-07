import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  Alert,
  Modal,
  TextInput,
  ScrollView,
  Switch,
} from 'react-native';
import { useSelector, useDispatch } from 'react-redux';
import { RootState, AppDispatch } from '../../store/store';
import {
  fetchCategories,
  createCategory,
  updateCategory,
  deleteCategory,
  fetchBrands,
  createBrand,
  updateBrand,
  deleteBrand,
  fetchUnits,
  createUnit,
  updateUnit,
  deleteUnit,
} from '../../store/slices/catalogsSlice';
import { theme } from '../../styles/theme';
import { useTranslation } from 'react-i18next';
import Icon from 'react-native-vector-icons/MaterialIcons';
import {
  Category,
  CategoryCreate,
  Brand,
  BrandCreate,
  Unit,
  UnitCreate,
  UnitType,
} from '../../types';

type CatalogType = 'categories' | 'brands' | 'units';

const CatalogsScreen: React.FC = () => {
  const dispatch = useDispatch<AppDispatch>();
  const { categories, brands, units, loading } = useSelector((state: RootState) => state.catalogs);
  const { selectedBusiness } = useSelector((state: RootState) => state.business);
  const { t } = useTranslation();

  const [activeTab, setActiveTab] = useState<CatalogType>('categories');
  const [modalVisible, setModalVisible] = useState(false);
  const [editingItem, setEditingItem] = useState<Category | Brand | Unit | null>(null);
  
  // Form states for different types
  const [categoryForm, setCategoryForm] = useState<CategoryCreate>({
    name: '',
    description: '',
    parent_id: undefined,
  });
  
  const [brandForm, setBrandForm] = useState<BrandCreate>({
    name: '',
    description: '',
    logo_url: '',
    website: '',
  });
  
  const [unitForm, setUnitForm] = useState<UnitCreate>({
    name: '',
    symbol: '',
    description: '',
    unit_type: UnitType.COUNT,
    base_unit_id: undefined,
    conversion_factor: undefined,
  });

  useEffect(() => {
    if (selectedBusiness) {
      dispatch(fetchCategories(selectedBusiness.id));
      dispatch(fetchBrands(selectedBusiness.id));
      dispatch(fetchUnits(selectedBusiness.id));
    }
  }, [dispatch, selectedBusiness]);

  const resetForms = () => {
    setCategoryForm({ name: '', description: '', parent_id: undefined });
    setBrandForm({ name: '', description: '', logo_url: '', website: '' });
    setUnitForm({
      name: '',
      symbol: '',
      description: '',
      unit_type: UnitType.COUNT,
      base_unit_id: undefined,
      conversion_factor: undefined,
    });
    setEditingItem(null);
  };

  const openModal = (item?: Category | Brand | Unit) => {
    if (item) {
      setEditingItem(item);
      if (activeTab === 'categories' && 'parent_id' in item) {
        setCategoryForm({
          name: item.name,
          description: item.description || '',
          parent_id: item.parent_id,
        });
      } else if (activeTab === 'brands' && 'website' in item) {
        setBrandForm({
          name: item.name,
          description: item.description || '',
          logo_url: (item as Brand).logo_url || '',
          website: (item as Brand).website || '',
        });
      } else if (activeTab === 'units' && 'unit_type' in item) {
        setUnitForm({
          name: item.name,
          symbol: (item as Unit).symbol,
          description: item.description || '',
          unit_type: (item as Unit).unit_type,
          base_unit_id: (item as Unit).base_unit_id,
          conversion_factor: (item as Unit).conversion_factor,
        });
      }
    } else {
      resetForms();
    }
    setModalVisible(true);
  };

  const closeModal = () => {
    setModalVisible(false);
    resetForms();
  };

  const handleSave = async () => {
    if (!selectedBusiness) {
      Alert.alert('Error', 'No hay negocio seleccionado');
      return;
    }

    try {
      if (activeTab === 'categories') {
        if (!categoryForm.name.trim()) {
          Alert.alert('Error', 'El nombre de la categoría es requerido');
          return;
        }
        if (editingItem) {
          await dispatch(updateCategory({
            categoryId: editingItem.id,
            category: categoryForm
          })).unwrap();
        } else {
          await dispatch(createCategory({
            category: categoryForm,
            businessId: selectedBusiness.id
          })).unwrap();
        }
      } else if (activeTab === 'brands') {
        if (!brandForm.name.trim()) {
          Alert.alert('Error', 'El nombre de la marca es requerido');
          return;
        }
        if (editingItem) {
          await dispatch(updateBrand({
            brandId: editingItem.id,
            brand: brandForm
          })).unwrap();
        } else {
          await dispatch(createBrand({
            brand: brandForm,
            businessId: selectedBusiness.id
          })).unwrap();
        }
      } else if (activeTab === 'units') {
        if (!unitForm.name.trim() || !unitForm.symbol.trim()) {
          Alert.alert('Error', 'El nombre y símbolo de la unidad son requeridos');
          return;
        }
        if (editingItem) {
          await dispatch(updateUnit({
            unitId: editingItem.id,
            unit: unitForm
          })).unwrap();
        } else {
          await dispatch(createUnit({
            unit: unitForm,
            businessId: selectedBusiness.id
          })).unwrap();
        }
      }
      
      Alert.alert('Éxito', `${activeTab === 'categories' ? 'Categoría' : activeTab === 'brands' ? 'Marca' : 'Unidad'} ${editingItem ? 'actualizada' : 'creada'} correctamente`);
      closeModal();
    } catch (error) {
      Alert.alert('Error', 'Error al guardar');
    }
  };

  const handleDelete = (item: Category | Brand | Unit) => {
    const itemName = activeTab === 'categories' ? 'categoría' : activeTab === 'brands' ? 'marca' : 'unidad';
    Alert.alert(
      'Confirmar eliminación',
      `¿Estás seguro de que quieres eliminar la ${itemName} "${item.name}"?`,
      [
        { text: 'Cancelar', style: 'cancel' },
        {
          text: 'Eliminar',
          style: 'destructive',
          onPress: async () => {
            try {
              if (activeTab === 'categories') {
                await dispatch(deleteCategory(item.id)).unwrap();
              } else if (activeTab === 'brands') {
                await dispatch(deleteBrand(item.id)).unwrap();
              } else if (activeTab === 'units') {
                await dispatch(deleteUnit(item.id)).unwrap();
              }
              Alert.alert('Éxito', `${itemName} eliminada correctamente`);
            } catch (error) {
              Alert.alert('Error', `Error al eliminar la ${itemName}`);
            }
          },
        },
      ]
    );
  };

  const getCurrentData = () => {
    switch (activeTab) {
      case 'categories':
        return categories;
      case 'brands':
        return brands;
      case 'units':
        return units;
      default:
        return [];
    }
  };

  const renderItem = ({ item }: { item: Category | Brand | Unit }) => (
    <View style={styles.itemCard}>
      <View style={styles.itemHeader}>
        <View style={styles.itemInfo}>
          <Text style={styles.itemName}>{item.name}</Text>
          {item.description && (
            <Text style={styles.itemDescription}>{item.description}</Text>
          )}
          {activeTab === 'units' && 'symbol' in item && (
            <Text style={styles.itemDetail}>Símbolo: {(item as Unit).symbol}</Text>
          )}
          {activeTab === 'brands' && 'website' in item && (item as Brand).website && (
            <Text style={styles.itemDetail}>Web: {(item as Brand).website}</Text>
          )}
        </View>
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
    </View>
  );

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Catálogos</Text>
        <TouchableOpacity
          style={styles.addButton}
          onPress={() => openModal()}
        >
          <Icon name="add" size={24} color="white" />
        </TouchableOpacity>
      </View>

      {/* Tabs */}
      <View style={styles.tabs}>
        <TouchableOpacity
          style={[styles.tab, activeTab === 'categories' && styles.tabActive]}
          onPress={() => setActiveTab('categories')}
        >
          <Text style={[styles.tabText, activeTab === 'categories' && styles.tabTextActive]}>
            Categorías
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[styles.tab, activeTab === 'brands' && styles.tabActive]}
          onPress={() => setActiveTab('brands')}
        >
          <Text style={[styles.tabText, activeTab === 'brands' && styles.tabTextActive]}>
            Marcas
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[styles.tab, activeTab === 'units' && styles.tabActive]}
          onPress={() => setActiveTab('units')}
        >
          <Text style={[styles.tabText, activeTab === 'units' && styles.tabTextActive]}>
            Unidades
          </Text>
        </TouchableOpacity>
      </View>

      <FlatList
        data={getCurrentData()}
        renderItem={renderItem}
        keyExtractor={(item) => item.id.toString()}
        contentContainerStyle={styles.list}
        refreshing={loading}
        onRefresh={() => {
          if (selectedBusiness) {
            if (activeTab === 'categories') dispatch(fetchCategories(selectedBusiness.id));
            else if (activeTab === 'brands') dispatch(fetchBrands(selectedBusiness.id));
            else if (activeTab === 'units') dispatch(fetchUnits(selectedBusiness.id));
          }
        }}
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
              {editingItem ? 'Editar' : 'Nueva'} {
                activeTab === 'categories' ? 'Categoría' : 
                activeTab === 'brands' ? 'Marca' : 'Unidad'
              }
            </Text>
            <TouchableOpacity onPress={handleSave}>
              <Text style={styles.saveButton}>Guardar</Text>
            </TouchableOpacity>
          </View>

          <ScrollView style={styles.modalContent}>
            {activeTab === 'categories' && (
              <>
                <View style={styles.formGroup}>
                  <Text style={styles.label}>Nombre *</Text>
                  <TextInput
                    style={styles.input}
                    value={categoryForm.name}
                    onChangeText={(text) => setCategoryForm({ ...categoryForm, name: text })}
                    placeholder="Nombre de la categoría"
                  />
                </View>
                <View style={styles.formGroup}>
                  <Text style={styles.label}>Descripción</Text>
                  <TextInput
                    style={styles.input}
                    value={categoryForm.description}
                    onChangeText={(text) => setCategoryForm({ ...categoryForm, description: text })}
                    placeholder="Descripción opcional"
                    multiline
                  />
                </View>
              </>
            )}

            {activeTab === 'brands' && (
              <>
                <View style={styles.formGroup}>
                  <Text style={styles.label}>Nombre *</Text>
                  <TextInput
                    style={styles.input}
                    value={brandForm.name}
                    onChangeText={(text) => setBrandForm({ ...brandForm, name: text })}
                    placeholder="Nombre de la marca"
                  />
                </View>
                <View style={styles.formGroup}>
                  <Text style={styles.label}>Descripción</Text>
                  <TextInput
                    style={styles.input}
                    value={brandForm.description}
                    onChangeText={(text) => setBrandForm({ ...brandForm, description: text })}
                    placeholder="Descripción opcional"
                    multiline
                  />
                </View>
                <View style={styles.formGroup}>
                  <Text style={styles.label}>URL del logo</Text>
                  <TextInput
                    style={styles.input}
                    value={brandForm.logo_url}
                    onChangeText={(text) => setBrandForm({ ...brandForm, logo_url: text })}
                    placeholder="https://ejemplo.com/logo.png"
                    autoCapitalize="none"
                  />
                </View>
                <View style={styles.formGroup}>
                  <Text style={styles.label}>Sitio web</Text>
                  <TextInput
                    style={styles.input}
                    value={brandForm.website}
                    onChangeText={(text) => setBrandForm({ ...brandForm, website: text })}
                    placeholder="https://www.ejemplo.com"
                    autoCapitalize="none"
                  />
                </View>
              </>
            )}

            {activeTab === 'units' && (
              <>
                <View style={styles.formGroup}>
                  <Text style={styles.label}>Nombre *</Text>
                  <TextInput
                    style={styles.input}
                    value={unitForm.name}
                    onChangeText={(text) => setUnitForm({ ...unitForm, name: text })}
                    placeholder="Nombre de la unidad"
                  />
                </View>
                <View style={styles.formGroup}>
                  <Text style={styles.label}>Símbolo *</Text>
                  <TextInput
                    style={styles.input}
                    value={unitForm.symbol}
                    onChangeText={(text) => setUnitForm({ ...unitForm, symbol: text })}
                    placeholder="kg, m, pza, etc."
                  />
                </View>
                <View style={styles.formGroup}>
                  <Text style={styles.label}>Tipo de unidad</Text>
                  <View style={styles.unitTypeContainer}>
                    {(['weight', 'volume', 'length', 'area', 'unit'] as UnitType[]).map((type) => (
                      <TouchableOpacity
                        key={type}
                        style={[
                          styles.unitTypeOption,
                          unitForm.unit_type === type && styles.unitTypeOptionSelected
                        ]}
                        onPress={() => setUnitForm({ ...unitForm, unit_type: type })}
                      >
                        <Text style={styles.unitTypeText}>{type}</Text>
                      </TouchableOpacity>
                    ))}
                  </View>
                </View>
                <View style={styles.formGroup}>
                  <Text style={styles.label}>Descripción</Text>
                  <TextInput
                    style={styles.input}
                    value={unitForm.description}
                    onChangeText={(text) => setUnitForm({ ...unitForm, description: text })}
                    placeholder="Descripción opcional"
                    multiline
                  />
                </View>
              </>
            )}
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
  tabs: {
    flexDirection: 'row',
    backgroundColor: 'white',
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.border,
  },
  tab: {
    flex: 1,
    paddingVertical: 12,
    alignItems: 'center',
    borderBottomWidth: 2,
    borderBottomColor: 'transparent',
  },
  tabActive: {
    borderBottomColor: theme.colors.primary,
  },
  tabText: {
    fontSize: 16,
    color: theme.colors.textSecondary,
  },
  tabTextActive: {
    color: theme.colors.primary,
    fontWeight: 'bold',
  },
  list: {
    padding: 16,
  },
  itemCard: {
    backgroundColor: 'white',
    padding: 16,
    marginBottom: 8,
    borderRadius: 8,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  itemHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
  },
  itemInfo: {
    flex: 1,
  },
  itemName: {
    fontSize: 16,
    fontWeight: 'bold',
    color: theme.colors.text,
    marginBottom: 4,
  },
  itemDescription: {
    fontSize: 14,
    color: theme.colors.textSecondary,
    marginBottom: 4,
  },
  itemDetail: {
    fontSize: 12,
    color: theme.colors.textSecondary,
  },
  actions: {
    flexDirection: 'row',
    gap: 8,
  },
  actionButton: {
    padding: 8,
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
  label: {
    fontSize: 16,
    fontWeight: 'bold',
    color: theme.colors.text,
    marginBottom: 8,
  },
  input: {
    borderWidth: 1,
    borderColor: theme.colors.border,
    borderRadius: 8,
    padding: 12,
    fontSize: 16,
    backgroundColor: 'white',
  },
  unitTypeContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  unitTypeOption: {
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 16,
    backgroundColor: '#E5E7EB',
    borderWidth: 1,
    borderColor: 'transparent',
  },
  unitTypeOptionSelected: {
    backgroundColor: theme.colors.primary + '20',
    borderColor: theme.colors.primary,
  },
  unitTypeText: {
    fontSize: 12,
    color: theme.colors.text,
    textTransform: 'capitalize',
  },
});

export default CatalogsScreen;
