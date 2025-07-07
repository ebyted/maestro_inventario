import React from 'react';
import { View, StyleSheet, Dimensions } from 'react-native';
import { Button, Title, Paragraph, Surface, Text } from 'react-native-paper';
import { useTranslation } from 'react-i18next';
import { colors, spacing, typography } from '../../styles/theme';

const { height } = Dimensions.get('window');

export default function AuthWelcomeScreen({ navigation }: any) {
  const { t } = useTranslation();

  return (
    <View style={styles.container}>
      <Surface style={styles.logoContainer}>
        <Text style={styles.logoEmoji}>📦</Text>
        <Title style={styles.title}>{t('app.name')}</Title>
        <Paragraph style={styles.subtitle}>{t('app.welcome')}</Paragraph>
      </Surface>

      <Surface style={styles.contentContainer}>
        <View style={styles.buttonContainer}>
          <Button
            mode="contained"
            onPress={() => navigation.navigate('Login')}
            style={styles.primaryButton}
            icon="login"
            contentStyle={styles.buttonContent}
          >
            {t('auth.login')}
          </Button>

          <Button
            mode="outlined"
            onPress={() => navigation.navigate('Register')}
            style={styles.secondaryButton}
            icon="account-plus"
            contentStyle={styles.buttonContent}
          >
            {t('auth.register')}
          </Button>
        </View>

        <View style={styles.featuresContainer}>
          <Paragraph style={styles.featuresTitle}>
            ¿Por qué elegir Maestro Inventario?
          </Paragraph>
          
          <View style={styles.feature}>
            <Text style={styles.featureIcon}>🏢</Text>
            <Paragraph style={styles.featureText}>Gestión multi-empresa</Paragraph>
          </View>
          
          <View style={styles.feature}>
            <Text style={styles.featureIcon}>📱</Text>
            <Paragraph style={styles.featureText}>Interfaz móvil intuitiva</Paragraph>
          </View>
          
          <View style={styles.feature}>
            <Text style={styles.featureIcon}>📊</Text>
            <Paragraph style={styles.featureText}>Reportes en tiempo real</Paragraph>
          </View>
        </View>
      </Surface>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  logoContainer: {
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: spacing.xl,
    backgroundColor: 'transparent',
    elevation: 0,
    height: height * 0.4,
  },
  logoEmoji: {
    fontSize: 80,
    marginBottom: spacing.lg,
  },
  title: {
    ...typography.h1,
    textAlign: 'center',
    marginBottom: spacing.md,
    color: colors.primary,
    fontWeight: 'bold',
    fontSize: 32,
  },
  subtitle: {
    ...typography.h3,
    textAlign: 'center',
    color: colors.textSecondary,
    fontSize: 18,
  },
  contentContainer: {
    flex: 1,
    padding: spacing.lg,
    backgroundColor: 'transparent',
    elevation: 0,
  },
  buttonContainer: {
    marginBottom: spacing.xl,
  },
  primaryButton: {
    marginBottom: spacing.md,
    borderRadius: 25,
    elevation: 4,
  },
  secondaryButton: {
    borderRadius: 25,
    borderWidth: 2,
  },
  buttonContent: {
    paddingVertical: spacing.md,
  },
  featuresContainer: {
    marginTop: spacing.lg,
  },
  featuresTitle: {
    ...typography.h3,
    textAlign: 'center',
    marginBottom: spacing.lg,
    color: colors.text,
    fontWeight: '600',
  },
  feature: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: spacing.md,
    paddingHorizontal: spacing.sm,
  },
  featureIcon: {
    fontSize: 24,
    marginRight: spacing.md,
  },
  featureText: {
    ...typography.body1,
    color: colors.textSecondary,
    flex: 1,
  },
});
