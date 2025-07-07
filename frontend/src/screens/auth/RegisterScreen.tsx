import React, { useState } from 'react';
import { View, StyleSheet, Alert, ScrollView, KeyboardAvoidingView, Platform } from 'react-native';
import { TextInput, Button, Title, Paragraph, Card, Surface, Text } from 'react-native-paper';
import { useDispatch, useSelector } from 'react-redux';
import { useTranslation } from 'react-i18next';
import { register } from '../../store/slices/authSlice';
import { RootState, AppDispatch } from '../../store/store';
import { colors, spacing, typography } from '../../styles/theme';

export default function RegisterScreen({ navigation }: any) {
  const { t } = useTranslation();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const dispatch = useDispatch<AppDispatch>();
  const { loading, error } = useSelector((state: RootState) => state.auth);

  const validateEmail = (email: string) => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  };

  const handleRegister = async () => {
    // Validation
    if (!email || !password || !confirmPassword || !firstName || !lastName) {
      Alert.alert(t('common.error'), t('auth.errors.fillAllFields'));
      return;
    }

    if (!validateEmail(email)) {
      Alert.alert(t('common.error'), t('auth.errors.invalidEmail'));
      return;
    }

    if (password.length < 6) {
      Alert.alert(t('common.error'), t('auth.errors.passwordMinLength'));
      return;
    }

    if (password !== confirmPassword) {
      Alert.alert(t('common.error'), t('auth.errors.passwordMismatch'));
      return;
    }

    try {
      await dispatch(register({
        email,
        password,
        first_name: firstName,
        last_name: lastName
      })).unwrap();
      Alert.alert(
        t('common.success'), 
        t('auth.success.accountCreated'),
        [{ text: 'OK', onPress: () => navigation.navigate('Login') }]
      );
    } catch (error) {
      Alert.alert(t('common.error'), t('auth.errors.registrationFailed'));
    }
  };

  return (
    <KeyboardAvoidingView 
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      style={styles.container}
    >
      <ScrollView contentContainerStyle={styles.scrollContainer}>
        <Surface style={styles.logoContainer}>
          <Text style={styles.logoEmoji}>👤</Text>
          <Title style={styles.title}>{t('auth.registerTitle')}</Title>
          <Paragraph style={styles.subtitle}>{t('auth.registerSubtitle')}</Paragraph>
        </Surface>

        <Card style={styles.card} elevation={4}>
          <Card.Content>
            <View style={styles.nameRow}>
              <TextInput
                label={t('auth.firstName')}
                value={firstName}
                onChangeText={setFirstName}
                mode="outlined"
                style={[styles.input, styles.nameInput]}
                left={<TextInput.Icon icon="account" />}
              />
              
              <TextInput
                label={t('auth.lastName')}
                value={lastName}
                onChangeText={setLastName}
                mode="outlined"
                style={[styles.input, styles.nameInput]}
                left={<TextInput.Icon icon="account" />}
              />
            </View>

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

            <TextInput
              label={t('auth.confirmPassword')}
              value={confirmPassword}
              onChangeText={setConfirmPassword}
              mode="outlined"
              style={styles.input}
              secureTextEntry={!showConfirmPassword}
              left={<TextInput.Icon icon="lock-check" />}
              right={
                <TextInput.Icon 
                  icon={showConfirmPassword ? "eye-off" : "eye"} 
                  onPress={() => setShowConfirmPassword(!showConfirmPassword)}
                />
              }
            />
            
            <Button
              mode="contained"
              onPress={handleRegister}
              style={styles.registerButton}
              loading={loading}
              disabled={loading}
              icon="account-plus"
            >
              {t('auth.registerButton')}
            </Button>
          </Card.Content>
        </Card>

        <Surface style={styles.loginContainer}>
          <Paragraph style={styles.loginText}>
            {t('auth.hasAccount')}
          </Paragraph>
          <Button
            mode="outlined"
            onPress={() => navigation.navigate('Login')}
            style={styles.loginBackButton}
            icon="login"
          >
            {t('auth.login')}
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
  nameRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    gap: spacing.sm,
  },
  nameInput: {
    flex: 1,
  },
  input: {
    marginBottom: spacing.md,
  },
  registerButton: {
    marginTop: spacing.md,
    marginBottom: spacing.sm,
    borderRadius: 25,
    paddingVertical: spacing.xs,
  },
  loginContainer: {
    alignItems: 'center',
    padding: spacing.lg,
    backgroundColor: 'transparent',
    elevation: 0,
  },
  loginText: {
    ...typography.body2,
    textAlign: 'center',
    marginBottom: spacing.md,
    color: colors.textSecondary,
  },
  loginBackButton: {
    borderRadius: 25,
    paddingHorizontal: spacing.lg,
  },
});
