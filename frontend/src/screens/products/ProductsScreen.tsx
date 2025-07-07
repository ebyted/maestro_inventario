import React, { useEffect, useState } from 'react';
import { View, StyleSheet, FlatList } from 'react-native';
import { Searchbar, Card, Title, Paragraph, FAB } from 'react-native-paper';
import { useDispatch, useSelector } from 'react-redux';
import { useTranslation } from 'react-i18next';
import { RootState, AppDispatch } from '../../store/store';
import { fetchProducts, selectProduct } from '../../store/slices/productSlice';
import { colors, spacing, typography } from '../../styles/theme';

export default function ProductsScreen({ navigation }: any) {
  const { t } = useTranslation();
  const dispatch = useDispatch<AppDispatch>();
  const { products, loading } = useSelector((state: RootState) => state.products);
  const { selectedBusiness } = useSelector((state: RootState) => state.business);
  const [searchQuery, setSearchQuery] = useState('');

  useEffect(() => {
    if (selectedBusiness) {
      dispatch(fetchProducts(selectedBusiness.id));
    }
  }, [dispatch, selectedBusiness]);

  const filteredProducts = products.filter((product: any) =>
    product.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    (product.sku && product.sku.toLowerCase().includes(searchQuery.toLowerCase()))
  );

  const renderProduct = ({ item }: any) => (
    <Card
      style={styles.productCard}
      onPress={() => {
        dispatch(selectProduct(item));
        navigation.navigate('ProductDetail', { product: item });
      }}
    >
      <Card.Content>
        <Title style={styles.productName}>{item.name}</Title>
        <Paragraph style={styles.productSku}>{t('products.sku')}: {item.sku || 'N/A'}</Paragraph>
        <Paragraph style={styles.productCategory}>{item.category || t('products.noCategory')}</Paragraph>
      </Card.Content>
    </Card>
  );

  return (
    <View style={styles.container}>
      <Searchbar
        placeholder={t('products.search')}
        onChangeText={setSearchQuery}
        value={searchQuery}
        style={styles.searchbar}
      />
      
      <FlatList
        data={filteredProducts}
        renderItem={renderProduct}
        keyExtractor={(item: any) => item.id.toString()}
        contentContainerStyle={styles.listContainer}
        refreshing={loading}
        onRefresh={() => selectedBusiness && dispatch(fetchProducts(selectedBusiness.id))}
      />
      
      <FAB
        style={styles.fab}
        icon="plus"
        onPress={() => navigation.navigate('CreateProduct')}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  searchbar: {
    margin: spacing.md,
  },
  listContainer: {
    padding: spacing.md,
  },
  productCard: {
    marginBottom: spacing.md,
  },
  productName: {
    ...typography.h4,
    color: colors.text,
  },
  productSku: {
    ...typography.body2,
    color: colors.textSecondary,
  },
  productCategory: {
    ...typography.caption,
    color: colors.primary,
  },
  fab: {
    position: 'absolute',
    margin: spacing.md,
    right: 0,
    bottom: 0,
    backgroundColor: colors.primary,
  },
});
