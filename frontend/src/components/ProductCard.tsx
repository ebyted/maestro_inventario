import React from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  Image,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { colors } from '../styles/theme';

interface ProductCardProps {
  product: {
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
    base_unit: {
      id: number;
      name: string;
    };
    variants?: any[];
  };
  onPress: () => void;
  showStock?: boolean;
  showLowStockWarning?: boolean;
}

const ProductCard: React.FC<ProductCardProps> = ({
  product,
  onPress,
  showStock = true,
  showLowStockWarning = true,
}) => {
  const getStockColor = () => {
    if (product.current_stock <= 0) return colors.error;
    if (product.has_low_stock) return colors.warning;
    return colors.success;
  };

  const getStockIcon = () => {
    if (product.current_stock <= 0) return 'alert-circle';
    if (product.has_low_stock) return 'warning';
    return 'checkmark-circle';
  };

  return (
    <TouchableOpacity style={styles.container} onPress={onPress}>
      <View style={styles.content}>
        {/* Product Image */}
        <View style={styles.imageContainer}>
          {product.image_url ? (
            <Image source={{ uri: product.image_url }} style={styles.image} />
          ) : (
            <View style={styles.placeholderImage}>
              <Ionicons name="cube-outline" size={32} color={colors.textSecondary} />
            </View>
          )}
        </View>

        {/* Product Info */}
        <View style={styles.info}>
          <Text style={styles.name} numberOfLines={1}>
            {product.name}
          </Text>
          
          {product.description && (
            <Text style={styles.description} numberOfLines={2}>
              {product.description}
            </Text>
          )}

          <View style={styles.details}>
            {product.sku && (
              <Text style={styles.sku}>SKU: {product.sku}</Text>
            )}
            {product.category && (
              <Text style={styles.category}>{product.category}</Text>
            )}
          </View>

          {showStock && (
            <View style={styles.stockContainer}>
              <View style={styles.stockInfo}>
                <Ionicons 
                  name={getStockIcon()} 
                  size={16} 
                  color={getStockColor()} 
                />
                <Text style={[styles.stockText, { color: getStockColor() }]}>
                  {product.current_stock} {product.base_unit.name}
                </Text>
              </View>
              
              {showLowStockWarning && product.has_low_stock && (
                <View style={styles.warningContainer}>
                  <Ionicons name="warning" size={14} color={colors.warning} />
                  <Text style={styles.warningText}>Stock bajo</Text>
                </View>
              )}
            </View>
          )}
        </View>

        {/* Status Indicator */}
        <View style={styles.statusContainer}>
          <View 
            style={[
              styles.statusDot, 
              { backgroundColor: product.is_active ? colors.success : colors.disabled }
            ]} 
          />
          <Ionicons name="chevron-forward" size={20} color={colors.textSecondary} />
        </View>
      </View>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  container: {
    backgroundColor: colors.white,
    marginHorizontal: 16,
    marginVertical: 4,
    borderRadius: 12,
    shadowColor: colors.black,
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  content: {
    flexDirection: 'row',
    padding: 16,
    alignItems: 'center',
  },
  imageContainer: {
    marginRight: 12,
  },
  image: {
    width: 60,
    height: 60,
    borderRadius: 8,
  },
  placeholderImage: {
    width: 60,
    height: 60,
    borderRadius: 8,
    backgroundColor: colors.background,
    justifyContent: 'center',
    alignItems: 'center',
  },
  info: {
    flex: 1,
  },
  name: {
    fontSize: 16,
    fontWeight: '600',
    color: colors.text,
    marginBottom: 4,
  },
  description: {
    fontSize: 14,
    color: colors.textSecondary,
    marginBottom: 8,
  },
  details: {
    flexDirection: 'row',
    gap: 12,
    marginBottom: 8,
  },
  sku: {
    fontSize: 12,
    color: colors.textSecondary,
    backgroundColor: colors.background,
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 4,
  },
  category: {
    fontSize: 12,
    color: colors.primary,
    backgroundColor: `${colors.primary}20`,
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 4,
  },
  stockContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  stockInfo: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  stockText: {
    fontSize: 14,
    fontWeight: '600',
  },
  warningContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  warningText: {
    fontSize: 12,
    color: colors.warning,
    fontWeight: '500',
  },
  statusContainer: {
    alignItems: 'center',
    gap: 8,
  },
  statusDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
  },
});

export default ProductCard;
