import React, { useState } from 'react';
import { View, StyleSheet, Alert, ScrollView, KeyboardAvoidingView, Platform } from 'react-native';
import { TextInput, Button, Title, Paragraph, Card, IconButton, Surface, Text } from 'react-native-paper';
import { useDispatch, useSelector } from 'react-redux';
import { useTranslation } from 'react-i18next';
import { login } from '../../store/slices/authSlice';
import { RootState, AppDispatch } from '../../store/store';
import { colors, spacing, typography } from '../../styles/theme';

export default function LoginScreen({ navigation }: any) {
  const { t } = useTranslation();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const dispatch = useDispatch<AppDispatch>();
  const { loading, error } = useSelector((state: RootState) => state.auth);

  const validateEmail = (email: string) => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  };

  const handleLogin = async () => {
    // Validation
    if (!email || !password) {
      Alert.alert(t('common.error'), t('auth.errors.fillAllFields'));
      return;
    }

    if (!validateEmail(email)) {
      Alert.alert(t('common.error'), t('auth.errors.invalidEmail'));
      return;
    }

    try {
      console.log('🔍 Iniciando login con:', { email, password: '***' });
      const result = await dispatch(login({ email, password })).unwrap();
      console.log('✅ Login exitoso:', result);
      console.log('🔄 Navegando al dashboard...');
    } catch (error) {
      console.error('❌ Error en login:', error);
      Alert.alert(t('common.error'), t('auth.errors.loginFailed'));
    }
  };

  return (
    <KeyboardAvoidingView 
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      style={styles.container}
    >
      <ScrollView contentContainerStyle={styles.scrollContainer}>
        <Surface style={styles.logoContainer}>
          <Text style={styles.logoEmoji}>📦</Text>
          <Title style={styles.title}>{t('app.name')}</Title>
          <Paragraph style={styles.subtitle}>{t('auth.loginTitle')}</Paragraph>
        </Surface>

        <Card style={styles.card} elevation={4}>
          <Card.Content>
            <TextInput
              label={t('auth.email')}
              value={email}
              onChangeText={setEmail}
              mode="outlined"
              style={styles.input}
              keyboardType="email-address"
              autoCapitalize="none"
              autoComplete="email"
              left={<TextInput.Icon icon="email" />}
            />
            
            <TextInput
              label={t('auth.password')}
              value={password}
              onChangeText={setPassword}
              mode="outlined"
              style={styles.input}
              secureTextEntry={!showPassword}
              autoComplete="password"
              left={<TextInput.Icon icon="lock" />}
              right={
                <TextInput.Icon 
                  icon={showPassword ? "eye-off" : "eye"} 
                  onPress={() => setShowPassword(!showPassword)}
                />
              }
            />
            
            <Button
              mode="contained"
              onPress={handleLogin}
              style={styles.loginButton}
              loading={loading}
              disabled={loading}
              icon="login"
            >
              {t('auth.loginButton')}
            </Button>

            <Button
              mode="text"
              onPress={() => {}} // TODO: Implement forgot password
              style={styles.forgotButton}
              compact
            >
              {t('auth.forgotPassword')}
            </Button>
          </Card.Content>
        </Card>

        <Surface style={styles.registerContainer}>
          <Paragraph style={styles.registerText}>
            {t('auth.noAccount')}
          </Paragraph>
          <Button
            mode="outlined"
            onPress={() => navigation.navigate('Register')}
            style={styles.registerButton}
            icon="account-plus"
          >
            {t('auth.register')}
          </Button>
        </Surface>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  scrollContainer: {
    flexGrow: 1,
    justifyContent: 'center',
    padding: spacing.md,
  },
  logoContainer: {
    alignItems: 'center',
    padding: spacing.xl,
    marginBottom: spacing.lg,
    backgroundColor: 'transparent',
    elevation: 0,
  },
  logoEmoji: {
    fontSize: 64,
    marginBottom: spacing.md,
  },
  title: {
    ...typography.h1,
    textAlign: 'center',
    marginBottom: spacing.sm,
    color: colors.primary,
    fontWeight: 'bold',
  },
  subtitle: {
    ...typography.body1,
    textAlign: 'center',
    color: colors.textSecondary,
  },
  card: {
    padding: spacing.md,
    marginBottom: spacing.lg,
    borderRadius: 16,
  },
  input: {
    marginBottom: spacing.md,
  },
  loginButton: {
    marginTop: spacing.md,
    marginBottom: spacing.sm,
    borderRadius: 25,
    paddingVertical: spacing.xs,
  },
  forgotButton: {
    alignSelf: 'center',
    marginTop: spacing.sm,
  },
  registerContainer: {
    alignItems: 'center',
    padding: spacing.lg,
    backgroundColor: 'transparent',
    elevation: 0,
  },
  registerText: {
    ...typography.body2,
    textAlign: 'center',
    marginBottom: spacing.md,
    color: colors.textSecondary,
  },
  registerButton: {
    borderRadius: 25,
    paddingHorizontal: spacing.lg,
  },
});
