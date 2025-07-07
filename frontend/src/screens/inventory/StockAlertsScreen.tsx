import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  Alert,
  ActivityIndicator,
  RefreshControl,
  Image,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons } from '@expo/vector-icons';
import { theme } from '../../styles/theme';
import { useTranslation } from 'react-i18next';
import { apiService } from '../../services/apiService';

interface StockAlert {
  id: number;
  product: {
    id: number;
    name: string;
    sku?: string;
    image_url?: string;
  };
  variant: {
    id: number;
    attributes?: any;
  };
  warehouse: {
    id: number;
    name: string;
    code: string;
  };
  current_stock: number;
  minimum_stock: number;
  recommended_order: number;
  alert_type: 'low_stock' | 'out_of_stock' | 'overstock';
  created_at: string;
  is_acknowledged: boolean;
}

interface StockAlertsScreenProps {
  navigation: any;
}

const StockAlertsScreen: React.FC<StockAlertsScreenProps> = ({ navigation }) => {
  const { t } = useTranslation();
  const [alerts, setAlerts] = useState<StockAlert[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [activeFilter, setActiveFilter] = useState<string>('all');

  const alertFilters = [
    { key: 'all', label: t('alerts.all'), color: theme.colors.textSecondary },
    { key: 'out_of_stock', label: t('alerts.outOfStock'), color: theme.colors.error },
    { key: 'low_stock', label: t('alerts.lowStock'), color: theme.colors.warning },
    { key: 'overstock', label: t('alerts.overstock'), color: theme.colors.primary },
  ];

  useEffect(() => {
    loadStockAlerts();
  }, [activeFilter]);

  const loadStockAlerts = async () => {
    try {
      setLoading(true);
      const params: any = { limit: 100 };
      if (activeFilter !== 'all') {
        params.alert_type = activeFilter;
      }
      
      const response = await apiService.get('/inventory/alerts', { params });
      setAlerts(response.data);
    } catch (error) {
      console.error('Error loading stock alerts:', error);
      Alert.alert(t('common.error'), t('alerts.errors.loadFailed'));
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  const onRefresh = () => {
    setRefreshing(true);
    loadStockAlerts();
  };

  const acknowledgeAlert = async (alertId: number) => {
    try {
      await apiService.patch(`/inventory/alerts/${alertId}`, {
        is_acknowledged: true
      });
      
      // Update the local state
      setAlerts(alerts.map(alert => 
        alert.id === alertId 
          ? { ...alert, is_acknowledged: true }
          : alert
      ));
    } catch (error) {
      console.error('Error acknowledging alert:', error);
      Alert.alert(t('common.error'), t('alerts.errors.acknowledgeFailed'));
    }
  };

  const createPurchaseOrder = (alert: StockAlert) => {
    Alert.alert(
      t('purchases.createPurchaseOrder'),
      t('alerts.createPurchaseOrderDescription', { 
        product: alert.product.name,
        quantity: alert.recommended_order 
      }),
      [
        {
          text: t('common.cancel'),
          style: 'cancel',
        },
        {
          text: t('common.create'),
          onPress: () => navigation.navigate('CreatePurchaseOrder', {
            preselectedItems: [{
              productId: alert.product.id,
              variantId: alert.variant.id,
              quantity: alert.recommended_order,
            }]
          }),
        },
      ]
    );
  };

  const getAlertColor = (alertType: string) => {
    switch (alertType) {
      case 'out_of_stock':
        return theme.colors.error;
      case 'low_stock':
        return theme.colors.warning;
      case 'overstock':
        return theme.colors.primary;
      default:
        return theme.colors.textSecondary;
    }
  };

  const getAlertIcon = (alertType: string) => {
    switch (alertType) {
      case 'out_of_stock':
        return 'alert-circle';
      case 'low_stock':
        return 'warning';
      case 'overstock':
        return 'trending-up';
      default:
        return 'information-circle';
    }
  };

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    const now = new Date();
    const diffInHours = Math.floor((now.getTime() - date.getTime()) / (1000 * 60 * 60));
    
    if (diffInHours < 24) {
      return `${diffInHours}h ${t('common.ago')}`;
    } else {
      const diffInDays = Math.floor(diffInHours / 24);
      return `${diffInDays}d ${t('common.ago')}`;
    }
  };

  const getVariantText = (variant: any) => {
    if (!variant.attributes) return t('alerts.defaultVariant');
    
    return Object.keys(variant.attributes)
      .map(key => `${key}: ${variant.attributes[key]}`)
      .join(', ');
  };

  const getStockPercentage = (alert: StockAlert) => {
    if (alert.minimum_stock === 0) return 100;
    return (alert.current_stock / alert.minimum_stock) * 100;
  };

  const renderFilterTabs = () => (
    <View style={styles.filterContainer}>
      <FlatList
        horizontal
        data={alertFilters}
        keyExtractor={(item) => item.key}
        showsHorizontalScrollIndicator={false}
        renderItem={({ item }) => (
          <TouchableOpacity
            style={[
              styles.filterTab,
              activeFilter === item.key && { backgroundColor: item.color },
            ]}
            onPress={() => setActiveFilter(item.key)}
          >
            <Text style={[
              styles.filterTabText,
              activeFilter === item.key && styles.filterTabTextActive,
            ]}>
              {item.label}
            </Text>
          </TouchableOpacity>
        )}
      />
    </View>
  );

  const renderStockAlert = ({ item }: { item: StockAlert }) => {
    const alertColor = getAlertColor(item.alert_type);
    const stockPercentage = getStockPercentage(item);
    
    return (
      <View style={[
        styles.alertCard,
        item.is_acknowledged && styles.acknowledgedCard,
      ]}>
        {/* Alert Header */}
        <View style={styles.alertHeader}>
          <View style={styles.alertInfo}>
            <View style={styles.alertTitleRow}>
              <Ionicons
                name={getAlertIcon(item.alert_type) as any}
                size={20}
                color={alertColor}
              />
              <Text style={[styles.alertType, { color: alertColor }]}>
                {t(`alerts.${item.alert_type}`)}
              </Text>
              {!item.is_acknowledged && <View style={styles.newIndicator} />}
            </View>
            <Text style={styles.alertTime}>{formatDate(item.created_at)}</Text>
          </View>
          
          {!item.is_acknowledged && (
            <TouchableOpacity
              style={styles.acknowledgeButton}
              onPress={() => acknowledgeAlert(item.id)}
            >
              <Ionicons name="checkmark" size={16} color={theme.colors.success} />
            </TouchableOpacity>
          )}
        </View>

        {/* Product Info */}
        <TouchableOpacity
          style={styles.productInfo}
          onPress={() => navigation.navigate('ProductDetail', { productId: item.product.id })}
        >
          <View style={styles.productImage}>
            {item.product.image_url ? (
              <Image source={{ uri: item.product.image_url }} style={styles.image} />
            ) : (
              <Ionicons name="cube-outline" size={32} color={theme.colors.textSecondary} />
            )}
          </View>
          
          <View style={styles.productDetails}>
            <Text style={styles.productName}>{item.product.name}</Text>
            {item.product.sku && (
              <Text style={styles.productSku}>SKU: {item.product.sku}</Text>
            )}
            <Text style={styles.variantText}>{getVariantText(item.variant)}</Text>
            <Text style={styles.warehouseText}>
              {t('alerts.warehouse')}: {item.warehouse.name}
            </Text>
          </View>
        </TouchableOpacity>

        {/* Stock Info */}
        <View style={styles.stockInfo}>
          <View style={styles.stockRow}>
            <Text style={styles.stockLabel}>{t('alerts.currentStock')}:</Text>
            <Text style={[styles.stockValue, { color: alertColor }]}>
              {item.current_stock}
            </Text>
          </View>
          
          <View style={styles.stockRow}>
            <Text style={styles.stockLabel}>{t('alerts.minimumStock')}:</Text>
            <Text style={styles.stockValue}>{item.minimum_stock}</Text>
          </View>

          {/* Stock Level Bar */}
          <View style={styles.stockBarContainer}>
            <View style={styles.stockBar}>
              <View 
                style={[
                  styles.stockBarFill,
                  { 
                    width: `${Math.min(stockPercentage, 100)}%`,
                    backgroundColor: alertColor
                  }
                ]} 
              />
            </View>
            <Text style={styles.stockPercentage}>
              {stockPercentage.toFixed(0)}%
            </Text>
          </View>

          {item.alert_type !== 'overstock' && (
            <View style={styles.recommendationRow}>
              <Text style={styles.stockLabel}>{t('alerts.recommendedOrder')}:</Text>
              <Text style={styles.recommendedValue}>{item.recommended_order}</Text>
            </View>
          )}
        </View>

        {/* Action Buttons */}
        <View style={styles.actionButtons}>
          <TouchableOpacity
            style={styles.actionButton}
            onPress={() => navigation.navigate('InventoryMovement', {
              movementType: 'adjustment',
              preselectedProduct: {
                productId: item.product.id,
                variantId: item.variant.id,
              }
            })}
          >
            <Ionicons name="sync" size={16} color={theme.colors.primary} />
            <Text style={styles.actionButtonText}>{t('alerts.adjustStock')}</Text>
          </TouchableOpacity>

          {item.alert_type !== 'overstock' && (
            <TouchableOpacity
              style={[styles.actionButton, styles.purchaseButton]}
              onPress={() => createPurchaseOrder(item)}
            >
              <Ionicons name="add-circle" size={16} color={theme.colors.success} />
              <Text style={[styles.actionButtonText, { color: theme.colors.success }]}>
                {t('alerts.createOrder')}
              </Text>
            </TouchableOpacity>
          )}
        </View>
      </View>
    );
  };

  const renderEmptyState = () => (
    <View style={styles.emptyState}>
      <Ionicons 
        name="checkmark-circle-outline" 
        size={64} 
        color={theme.colors.success} 
      />
      <Text style={styles.emptyStateText}>
        {activeFilter === 'all' 
          ? t('alerts.noAlerts')
          : t('alerts.noAlertsOfType', { type: t(`alerts.${activeFilter}`) })
        }
      </Text>
      <Text style={styles.emptyStateSubtext}>
        {t('alerts.allStockLevelsNormal')}
      </Text>
    </View>
  );

  const getAlertCounts = () => {
    const total = alerts.length;
    const unacknowledged = alerts.filter(alert => !alert.is_acknowledged).length;
    const outOfStock = alerts.filter(alert => alert.alert_type === 'out_of_stock').length;
    const lowStock = alerts.filter(alert => alert.alert_type === 'low_stock').length;
    
    return { total, unacknowledged, outOfStock, lowStock };
  };

  const alertCounts = getAlertCounts();

  if (loading && !refreshing) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color={theme.colors.primary} />
          <Text style={styles.loadingText}>{t('common.loading')}</Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <View>
          <Text style={styles.headerTitle}>{t('alerts.stockAlerts')}</Text>
          {alertCounts.unacknowledged > 0 && (
            <Text style={styles.headerSubtitle}>
              {t('alerts.unacknowledgedCount', { count: alertCounts.unacknowledged })}
            </Text>
          )}
        </View>
        <TouchableOpacity
          style={styles.settingsButton}
          onPress={() => navigation.navigate('AlertSettings')}
        >
          <Ionicons name="settings-outline" size={24} color={theme.colors.textSecondary} />
        </TouchableOpacity>
      </View>

      {/* Summary Stats */}
      {alerts.length > 0 && (
        <View style={styles.statsContainer}>
          <View style={styles.statItem}>
            <Text style={styles.statNumber}>{alertCounts.total}</Text>
            <Text style={styles.statLabel}>{t('alerts.totalAlerts')}</Text>
          </View>
          <View style={styles.statItem}>
            <Text style={[styles.statNumber, { color: theme.colors.error }]}>
              {alertCounts.outOfStock}
            </Text>
            <Text style={styles.statLabel}>{t('alerts.outOfStock')}</Text>
          </View>
          <View style={styles.statItem}>
            <Text style={[styles.statNumber, { color: theme.colors.warning }]}>
              {alertCounts.lowStock}
            </Text>
            <Text style={styles.statLabel}>{t('alerts.lowStock')}</Text>
          </View>
        </View>
      )}

      {/* Filter Tabs */}
      {renderFilterTabs()}

      {/* Alerts List */}
      <FlatList
        data={alerts}
        renderItem={renderStockAlert}
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
  headerSubtitle: {
    fontSize: 12,
    color: theme.colors.error,
    marginTop: 2,
  },
  settingsButton: {
    padding: 8,
  },
  statsContainer: {
    flexDirection: 'row',
    backgroundColor: theme.colors.white,
    paddingVertical: 16,
    paddingHorizontal: 16,
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.border,
  },
  statItem: {
    flex: 1,
    alignItems: 'center',
  },
  statNumber: {
    fontSize: 24,
    fontWeight: 'bold',
    color: theme.colors.text,
  },
  statLabel: {
    fontSize: 12,
    color: theme.colors.textSecondary,
    marginTop: 4,
    textAlign: 'center',
  },
  filterContainer: {
    backgroundColor: theme.colors.white,
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: theme.colors.border,
  },
  filterTab: {
    paddingHorizontal: 16,
    paddingVertical: 8,
    marginHorizontal: 4,
    borderRadius: 16,
    backgroundColor: theme.colors.lightGray,
  },
  filterTabText: {
    fontSize: 14,
    color: theme.colors.text,
    fontWeight: '500',
  },
  filterTabTextActive: {
    color: theme.colors.white,
  },
  listContainer: {
    paddingHorizontal: 16,
    paddingVertical: 8,
  },
  alertCard: {
    backgroundColor: theme.colors.white,
    borderRadius: 12,
    padding: 16,
    marginVertical: 6,
    borderWidth: 1,
    borderColor: theme.colors.border,
    borderLeftWidth: 4,
  },
  acknowledgedCard: {
    opacity: 0.7,
  },
  alertHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: 12,
  },
  alertInfo: {
    flex: 1,
  },
  alertTitleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  alertType: {
    fontSize: 14,
    fontWeight: '600',
    textTransform: 'uppercase',
  },
  newIndicator: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: theme.colors.error,
  },
  alertTime: {
    fontSize: 12,
    color: theme.colors.textSecondary,
    marginTop: 4,
  },
  acknowledgeButton: {
    backgroundColor: '#E8F5E8',
    borderRadius: 16,
    width: 32,
    height: 32,
    alignItems: 'center',
    justifyContent: 'center',
  },
  productInfo: {
    flexDirection: 'row',
    marginBottom: 16,
  },
  productImage: {
    width: 60,
    height: 60,
    borderRadius: 8,
    backgroundColor: theme.colors.lightGray,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 12,
  },
  image: {
    width: '100%',
    height: '100%',
    borderRadius: 8,
  },
  productDetails: {
    flex: 1,
  },
  productName: {
    fontSize: 16,
    fontWeight: '600',
    color: theme.colors.text,
    marginBottom: 4,
  },
  productSku: {
    fontSize: 12,
    color: theme.colors.textSecondary,
    marginBottom: 2,
  },
  variantText: {
    fontSize: 12,
    color: theme.colors.textSecondary,
    marginBottom: 2,
  },
  warehouseText: {
    fontSize: 12,
    color: theme.colors.textSecondary,
  },
  stockInfo: {
    marginBottom: 16,
  },
  stockRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 6,
  },
  stockLabel: {
    fontSize: 14,
    color: theme.colors.textSecondary,
  },
  stockValue: {
    fontSize: 14,
    fontWeight: '600',
    color: theme.colors.text,
  },
  stockBarContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginVertical: 8,
    gap: 8,
  },
  stockBar: {
    flex: 1,
    height: 6,
    backgroundColor: theme.colors.lightGray,
    borderRadius: 3,
    overflow: 'hidden',
  },
  stockBarFill: {
    height: '100%',
    borderRadius: 3,
  },
  stockPercentage: {
    fontSize: 12,
    color: theme.colors.text,
    fontWeight: '600',
    minWidth: 35,
    textAlign: 'right',
  },
  recommendationRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginTop: 8,
    paddingTop: 8,
    borderTopWidth: 1,
    borderTopColor: theme.colors.lightGray,
  },
  recommendedValue: {
    fontSize: 14,
    fontWeight: '600',
    color: theme.colors.primary,
  },
  actionButtons: {
    flexDirection: 'row',
    gap: 12,
  },
  actionButton: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 10,
    borderRadius: 6,
    backgroundColor: theme.colors.lightGray,
    gap: 4,
  },
  purchaseButton: {
    backgroundColor: '#E8F5E8',
  },
  actionButtonText: {
    fontSize: 12,
    color: theme.colors.primary,
    fontWeight: '500',
  },
  emptyState: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingVertical: 80,
  },
  emptyStateText: {
    fontSize: 18,
    color: theme.colors.text,
    textAlign: 'center',
    marginVertical: 16,
    fontWeight: '500',
  },
  emptyStateSubtext: {
    fontSize: 14,
    color: theme.colors.textSecondary,
    textAlign: 'center',
    lineHeight: 20,
  },
});

export default StockAlertsScreen;
