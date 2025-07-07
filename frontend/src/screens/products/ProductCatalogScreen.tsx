import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  ActivityIndicator,
  Alert,
  RefreshControl
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { theme } from '../../styles/theme';
import { useTranslation } from 'react-i18next';
import SearchBar from '../../components/SearchBar';
import FilterModal, { FilterOptions } from '../../components/FilterModal';
import ProductCard from '../../components/ProductCard';
import { apiService } from '../../services/apiService';

interface Product {
  id: number;
  name: string;
  description?: string;
  sku?: string;
  barcode?: string;
  category?: string;
  brand?: string;
  image_url?: string;
  is_active: boolean;
  current_stock: number;
  minimum_stock: number;
  has_low_stock: boolean;
  product_type: 'product' | 'service';
  base_unit: {
    id: number;
    name: string;
  };
  variants?: Array<{
    id: number;
    attributes?: any;
    price?: number;
    cost?: number;
    inventory: Array<{
      warehouse_id: number;
      quantity: number;
      minimum_stock: number;
    }>;
  }>;
}

interface ProductCatalogScreenProps {
  navigation: any;
}

const ProductCatalogScreen: React.FC<ProductCatalogScreenProps> = ({ navigation }) => {
  const { t } = useTranslation();
  const [products, setProducts] = useState<Product[]>([]);
  const [filteredProducts, setFilteredProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [showFilters, setShowFilters] = useState(false);
  const [categories, setCategories] = useState<Array<{ id: string; name: string }>>([]);
  const [filters, setFilters] = useState<FilterOptions>({});

  // Helper function to check if any filters are applied
  const hasActiveFilters = () => {
    return !!(filters.category || filters.minPrice || filters.maxPrice || 
              filters.minStock || filters.maxStock || filters.hasVariants ||
              filters.status || filters.lowStock || filters.outOfStock ||
              filters.productType);
  };

  useEffect(() => {
    loadProducts();
    loadCategories();
  }, []);

  useEffect(() => {
    applyFilters();
  }, [products, searchQuery, filters]);

  const loadProducts = async () => {
    try {
      setLoading(true);
      const response = await apiService.get('/products', {
        params: {
          search: searchQuery || undefined,
          category: filters.category || undefined,
          min_price: filters.minPrice,
          max_price: filters.maxPrice,
          min_stock: filters.minStock,
          max_stock: filters.maxStock,
          has_variants: filters.hasVariants,
          status: filters.status || 'active',
          low_stock: filters.lowStock,
          out_of_stock: filters.outOfStock,
          product_type: filters.productType,
          limit: 100
        }
      });
      
      // Asegurar que cada producto tenga los campos requeridos
      const processedProducts = response.data.map((product: any) => ({
        ...product,
        current_stock: product.current_stock ?? 0,
        minimum_stock: product.minimum_stock ?? 0,
        has_low_stock: product.has_low_stock ?? false,
        variants: product.variants ?? []
      }));
      
      setProducts(processedProducts);
    } catch (error) {
      console.error('Error loading products:', error);
      Alert.alert(
        t('common.error'),
        t('products.errors.loadFailed') || 'Error al cargar los productos'
      );
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  const loadCategories = async () => {
    try {
      const response = await apiService.get('/categories?business_id=1');
      const categoriesData = response.data.map((cat: any) => ({
        id: cat.id || cat.name,
        name: cat.name || cat
      }));
      setCategories(categoriesData);
    } catch (error) {
      console.error('Error loading categories:', error);
      // No mostrar alerta para categorías, es un error menor
    }
  };

  const applyFilters = () => {
    let filtered = products;

    if (searchQuery) {
      const query = searchQuery.toLowerCase();
      filtered = filtered.filter(product =>
        product.name.toLowerCase().includes(query) ||
        product.description?.toLowerCase().includes(query) ||
        product.sku?.toLowerCase().includes(query) ||
        product.barcode?.toLowerCase().includes(query)
      );
    }

    setFilteredProducts(filtered);
  };

  const handleApplyFilters = (newFilters: FilterOptions) => {
    setFilters(newFilters);
    loadProducts(); // Reload with new filters
  };

  const handleClearFilters = () => {
    setFilters({});
    setSearchQuery('');
    loadProducts();
  };

  const onRefresh = () => {
    setRefreshing(true);
    loadProducts();
  };

  const getTotalStock = (product: Product) => {
    // Si ya tiene current_stock, usarlo. Si no, calcular desde variants
    if (product.current_stock !== undefined) {
      return product.current_stock;
    }
    
    if (product.variants && product.variants.length > 0) {
      return product.variants.reduce((total, variant) => {
        return total + variant.inventory.reduce((sum, inv) => sum + inv.quantity, 0);
      }, 0);
    }
    
    return 0;
  };

  const getMinStock = (product: Product) => {
    // Si ya tiene minimum_stock, usarlo. Si no, calcular desde variants
    if (product.minimum_stock !== undefined) {
      return product.minimum_stock;
    }
    
    if (product.variants && product.variants.length > 0) {
      const allMinStocks: number[] = [];
      product.variants.forEach(variant => {
        variant.inventory.forEach(inv => {
          allMinStocks.push(inv.minimum_stock);
        });
      });
      return Math.min(...allMinStocks);
    }
    
    return 0;
  };

  const getStockStatus = (product: Product) => {
    const totalStock = getTotalStock(product);
    const minStock = getMinStock(product);
    
    if (totalStock === 0) return 'out';
    if (totalStock <= minStock) return 'low';
    return 'normal';
  };

  const getStatistics = () => {
    const totalProducts = filteredProducts.length;
    const activeProducts = filteredProducts.filter(p => p.is_active).length;
    const lowStockProducts = filteredProducts.filter(p => getStockStatus(p) === 'low').length;
    const outOfStockProducts = filteredProducts.filter(p => getStockStatus(p) === 'out').length;

    return {
      total: totalProducts,
      active: activeProducts,
      lowStock: lowStockProducts,
      outOfStock: outOfStockProducts,
    };
  };

  const statistics = getStatistics();

  const renderEmptyState = () => (
    <View style={styles.emptyState}>
      <Ionicons 
        name="cube-outline" 
        size={64} 
        color={theme.colors.textSecondary} 
      />
      <Text style={styles.emptyStateText}>
        {searchQuery || hasActiveFilters()
          ? t('products.noResultsFound') || 'No se encontraron resultados'
          : t('products.noProducts') || 'No hay productos'
        }
      </Text>
      <TouchableOpacity 
        style={styles.addButton}
        onPress={() => navigation.navigate('ProductDetail')}
      >
        <Text style={styles.addButtonText}>
          {t('products.addProduct') || 'Agregar Producto'}
        </Text>
      </TouchableOpacity>
    </View>
  );

  const renderStatistics = () => (
    <View style={styles.statsContainer}>
      <View style={styles.statItem}>
        <Text style={styles.statNumber}>{statistics.total}</Text>
        <Text style={styles.statLabel}>{t('products.total') || 'Total'}</Text>
      </View>
      <View style={styles.statItem}>
        <Text style={[styles.statNumber, { color: theme.colors.success }]}>{statistics.active}</Text>
        <Text style={styles.statLabel}>{t('products.active') || 'Activos'}</Text>
      </View>
      <View style={styles.statItem}>
        <Text style={[styles.statNumber, { color: theme.colors.warning }]}>{statistics.lowStock}</Text>
        <Text style={styles.statLabel}>{t('products.lowStock') || 'Stock Bajo'}</Text>
      </View>
      <View style={styles.statItem}>
        <Text style={[styles.statNumber, { color: theme.colors.error }]}>{statistics.outOfStock}</Text>
        <Text style={styles.statLabel}>{t('products.outOfStock') || 'Sin Stock'}</Text>
      </View>
    </View>
  );

  const renderFilterChips = () => {
    if (!hasActiveFilters()) return null;

    return (
      <View style={styles.filterChipsContainer}>
        <Text style={styles.filterChipsTitle}>{t('products.activeFilters') || 'Filtros activos'}:</Text>
        <View style={styles.filterChips}>
          {hasActiveFilters() && (
            <TouchableOpacity 
              style={styles.clearAllChip}
              onPress={handleClearFilters}
            >
              <Text style={styles.clearAllChipText}>{t('common.clearAll') || 'Limpiar todo'}</Text>
              <Ionicons name="close" size={16} color={theme.colors.white} />
            </TouchableOpacity>
          )}
        </View>
      </View>
    );
  };

  const renderProduct = ({ item }: { item: Product }) => {
    // Asegurar que el producto tenga los campos requeridos por ProductCard
    const productWithStock = {
      ...item,
      current_stock: item.current_stock ?? getTotalStock(item),
      minimum_stock: item.minimum_stock ?? getMinStock(item),
      has_low_stock: item.has_low_stock ?? (getStockStatus(item) === 'low')
    };

    return (
      <ProductCard
        product={productWithStock}
        onPress={() => navigation.navigate('ProductDetail', { productId: item.id })}
      />
    );
  };

  if (loading && !refreshing) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color={theme.colors.primary} />
          <Text style={styles.loadingText}>{t('common.loading') || 'Cargando...'}</Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>{t('products.catalog') || 'Catálogo de Productos'}</Text>
        <TouchableOpacity
          style={styles.filterButton}
          onPress={() => setShowFilters(true)}
        >
          <Ionicons 
            name="filter" 
            size={24} 
            color={hasActiveFilters() ? theme.colors.primary : theme.colors.textSecondary}
          />
        </TouchableOpacity>
      </View>

      {/* Search Bar */}
      <View style={styles.searchContainer}>
        <SearchBar
          value={searchQuery}
          onChangeText={setSearchQuery}
          placeholder={t('products.searchPlaceholder') || 'Buscar productos...'}
        />
      </View>

      {/* Statistics */}
      {renderStatistics()}

      {/* Filter Chips */}
      {renderFilterChips()}

      {/* Products List */}
      <FlatList
        data={filteredProducts}
        renderItem={renderProduct}
        keyExtractor={(item) => item.id.toString()}
        contentContainerStyle={styles.listContainer}
        refreshControl={
          <RefreshControl
            refreshing={refreshing}
            onRefresh={onRefresh}
            colors={[theme.colors.primary]}
          />
        }
        ListEmptyComponent={renderEmptyState}
        showsVerticalScrollIndicator={false}
      />

      {/* Filter Modal */}
      <FilterModal
        visible={showFilters}
        onClose={() => setShowFilters(false)}
        onApplyFilters={handleApplyFilters}
        initialFilters={filters}
        categories={categories}
      />
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
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
    backgroundColor: theme.colors.white,
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.border,
  },
  headerTitle: {
    fontSize: 20,
    fontWeight: '600',
    color: theme.colors.text,
  },
  filterButton: {
    padding: 8,
  },
  searchContainer: {
    paddingHorizontal: 16,
    paddingVertical: 12,
    backgroundColor: theme.colors.white,
  },
  statsContainer: {
    flexDirection: 'row',
    backgroundColor: theme.colors.white,
    paddingVertical: 16,
    paddingHorizontal: 16,
    marginBottom: 8,
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.border,
  },
  statItem: {
    flex: 1,
    alignItems: 'center',
  },
  statNumber: {
    fontSize: 20,
    fontWeight: 'bold',
    color: theme.colors.text,
  },
  statLabel: {
    fontSize: 12,
    color: theme.colors.textSecondary,
    marginTop: 4,
  },
  filterChipsContainer: {
    backgroundColor: theme.colors.white,
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.border,
  },
  filterChipsTitle: {
    fontSize: 14,
    color: theme.colors.textSecondary,
    marginBottom: 8,
  },
  filterChips: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  clearAllChip: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: theme.colors.error,
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 16,
    gap: 4,
  },
  clearAllChipText: {
    color: theme.colors.white,
    fontSize: 12,
    fontWeight: '500',
  },
  listContainer: {
    paddingHorizontal: 16,
    paddingBottom: 16,
  },
  emptyState: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingVertical: 80,
  },
  emptyStateText: {
    fontSize: 16,
    color: theme.colors.textSecondary,
    textAlign: 'center',
    marginVertical: 16,
    lineHeight: 24,
  },
  addButton: {
    backgroundColor: theme.colors.primary,
    paddingHorizontal: 24,
    paddingVertical: 12,
    borderRadius: 8,
    marginTop: 16,
  },
  addButtonText: {
    color: theme.colors.white,
    fontSize: 16,
    fontWeight: '600',
  },
});

export default ProductCatalogScreen;
