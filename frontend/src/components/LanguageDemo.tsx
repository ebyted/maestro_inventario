import React from 'react';
import { View, StyleSheet } from 'react-native';
import { Card, Title, Paragraph, Button } from 'react-native-paper';
import { useTranslation } from 'react-i18next';
import { useDispatch } from 'react-redux';
import { AppDispatch } from '../store/store';
import { changeLanguage } from '../store/slices/settingsSlice';
import { colors, spacing } from '../styles/theme';

export default function LanguageDemo() {
  const { t, i18n } = useTranslation();
  const dispatch = useDispatch<AppDispatch>();

  const handleLanguageChange = async (languageCode: string) => {
    try {
      await dispatch(changeLanguage(languageCode)).unwrap();
    } catch (error) {
      console.error('Error changing language:', error);
    }
  };

  return (
    <View style={styles.container}>
      <Card style={styles.card}>
        <Card.Content>
          <Title style={styles.title}>{t('app.name')}</Title>
          <Paragraph style={styles.subtitle}>{t('app.welcome')}</Paragraph>
          
          <Paragraph style={styles.currentLang}>
            Current Language: {i18n.language}
          </Paragraph>
          
          <View style={styles.buttonContainer}>
            <Button
              mode={i18n.language === 'en' ? 'contained' : 'outlined'}
              onPress={() => handleLanguageChange('en')}
              style={styles.button}
            >
              🇺🇸 {t('languages.en')}
            </Button>
            
            <Button
              mode={i18n.language === 'es' ? 'contained' : 'outlined'}
              onPress={() => handleLanguageChange('es')}
              style={styles.button}
            >
              🇪🇸 {t('languages.es')}
            </Button>
          </View>
          
          <View style={styles.demoSection}>
            <Title style={styles.sectionTitle}>{t('navigation.dashboard')}</Title>
            <Paragraph>{t('dashboard.quickActions')}</Paragraph>
            <Paragraph>{t('dashboard.newSale')}</Paragraph>
            <Paragraph>{t('dashboard.manageProducts')}</Paragraph>
          </View>
          
          <View style={styles.demoSection}>
            <Title style={styles.sectionTitle}>{t('products.title')}</Title>
            <Paragraph>{t('products.search')}</Paragraph>
            <Paragraph>{t('products.sku')}: ABC123</Paragraph>
            <Paragraph>{t('products.category')}: Electronics</Paragraph>
          </View>
          
          <View style={styles.demoSection}>
            <Title style={styles.sectionTitle}>{t('auth.login')}</Title>
            <Paragraph>{t('auth.email')}</Paragraph>
            <Paragraph>{t('auth.password')}</Paragraph>
            <Paragraph>{t('auth.loginButton')}</Paragraph>
          </View>
        </Card.Content>
      </Card>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: spacing.md,
    backgroundColor: colors.background,
  },
  card: {
    padding: spacing.md,
  },
  title: {
    textAlign: 'center',
    marginBottom: spacing.sm,
    color: colors.primary,
  },
  subtitle: {
    textAlign: 'center',
    marginBottom: spacing.lg,
    color: colors.textSecondary,
  },
  currentLang: {
    textAlign: 'center',
    marginBottom: spacing.lg,
    fontWeight: 'bold',
    color: colors.text,
  },
  buttonContainer: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    marginBottom: spacing.xl,
  },
  button: {
    flex: 0.4,
  },
  demoSection: {
    marginBottom: spacing.lg,
    padding: spacing.md,
    backgroundColor: colors.surface,
    borderRadius: 8,
  },
  sectionTitle: {
    fontSize: 18,
    marginBottom: spacing.sm,
    color: colors.primary,
  },
});
