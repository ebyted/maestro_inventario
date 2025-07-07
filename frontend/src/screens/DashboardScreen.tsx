import React, { useEffect } from 'react';
import { View, StyleSheet, ScrollView } from 'react-native';
import { Title, Card, Paragraph, Button } from 'react-native-paper';
import { useDispatch, useSelector } from 'react-redux';
import { useTranslation } from 'react-i18next';
import { RootState, AppDispatch } from '../store/store';
import { fetchBusinesses } from '../store/slices/businessSlice';
import { colors, spacing, typography } from '../styles/theme';

export default function DashboardScreen({ navigation }: any) {
  const { t } = useTranslation();
  const dispatch = useDispatch<AppDispatch>();
  const { user } = useSelector((state: RootState) => state.auth);
  const { selectedBusiness, selectedWarehouse } = useSelector((state: RootState) => state.business);

  useEffect(() => {
    dispatch(fetchBusinesses());
  }, [dispatch]);

  const stats = [
    { title: t('dashboard.stats.products'), value: '150', color: colors.primary },
    { title: t('dashboard.stats.lowStock'), value: '8', color: colors.warning },
    { title: t('dashboard.stats.salesToday'), value: '$2,500', color: colors.success },
    { title: t('dashboard.stats.users'), value: '5', color: colors.secondary },
  ];

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Title style={styles.title}>
          {t('dashboard.welcome', { name: user?.first_name })}
        </Title>
        <Paragraph style={styles.subtitle}>
          {selectedBusiness?.name || t('dashboard.noBusiness')} - {selectedWarehouse?.name || t('dashboard.noWarehouse')}
        </Paragraph>
      </View>

      <View style={styles.statsContainer}>
        {stats.map((stat, index) => (
          <Card key={index} style={[styles.statCard, { borderLeftColor: stat.color }]}>
            <Card.Content style={styles.statContent}>
              <Paragraph style={styles.statValue}>{stat.value}</Paragraph>
              <Paragraph style={styles.statTitle}>{stat.title}</Paragraph>
            </Card.Content>
          </Card>
        ))}
      </View>

      <View style={styles.actionsContainer}>
        <Title style={styles.sectionTitle}>{t('dashboard.quickActions')}</Title>
        
        <Button
          mode="contained"
          onPress={() => navigation.navigate('Sales', { screen: 'POS' })}
          style={[styles.actionButton, { backgroundColor: colors.primary }]}
          icon="cash-register"
        >
          {t('dashboard.newSale')}
        </Button>
        
        <Button
          mode="outlined"
          onPress={() => navigation.navigate('Products')}
          style={styles.actionButton}
          icon="cube-outline"
        >
          {t('dashboard.manageProducts')}
        </Button>
        
        <Button
          mode="outlined"
          onPress={() => navigation.navigate('Inventory')}
          style={styles.actionButton}
          icon="clipboard-list-outline"
        >
          {t('dashboard.viewInventory')}
        </Button>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  header: {
    padding: spacing.lg,
    backgroundColor: colors.white,
    marginBottom: spacing.md,
  },
  title: {
    ...typography.h3,
    color: colors.text,
  },
  subtitle: {
    ...typography.body2,
    color: colors.textSecondary,
    marginTop: spacing.xs,
  },
  statsContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingHorizontal: spacing.md,
    marginBottom: spacing.md,
  },
  statCard: {
    width: '48%',
    marginBottom: spacing.md,
    marginHorizontal: '1%',
    borderLeftWidth: 4,
  },
  statContent: {
    alignItems: 'center',
    paddingVertical: spacing.md,
  },
  statValue: {
    ...typography.h3,
    color: colors.text,
    fontWeight: 'bold',
  },
  statTitle: {
    ...typography.caption,
    color: colors.textSecondary,
    textAlign: 'center',
  },
  actionsContainer: {
    padding: spacing.lg,
    backgroundColor: colors.white,
  },
  sectionTitle: {
    ...typography.h4,
    marginBottom: spacing.md,
    color: colors.text,
  },
  actionButton: {
    marginBottom: spacing.md,
  },
});
