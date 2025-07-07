import React from 'react';
import { View, StyleSheet } from 'react-native';
import { Title, Paragraph } from 'react-native-paper';
import { colors, spacing, typography } from '../../styles/theme';

export default function ProductDetailScreen({ route }: any) {
  const { product } = route.params;

  return (
    <View style={styles.container}>
      <Title style={styles.title}>{product.name}</Title>
      <Paragraph style={styles.description}>{product.description || 'Sin descripción'}</Paragraph>
      <Paragraph style={styles.info}>SKU: {product.sku || 'N/A'}</Paragraph>
      <Paragraph style={styles.info}>Categoría: {product.category || 'Sin categoría'}</Paragraph>
      <Paragraph style={styles.info}>Marca: {product.brand || 'Sin marca'}</Paragraph>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: spacing.lg,
    backgroundColor: colors.background,
  },
  title: {
    ...typography.h2,
    marginBottom: spacing.md,
    color: colors.text,
  },
  description: {
    ...typography.body1,
    marginBottom: spacing.lg,
    color: colors.textSecondary,
  },
  info: {
    ...typography.body2,
    marginBottom: spacing.sm,
    color: colors.text,
  },
});
