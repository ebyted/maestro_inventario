import React from 'react';
import { View, StyleSheet } from 'react-native';
import { Title, Paragraph, Button } from 'react-native-paper';
import { colors, spacing, typography } from '../../styles/theme';

export default function SalesScreen({ navigation }: any) {
  return (
    <View style={styles.container}>
      <Title style={styles.title}>Ventas</Title>
      <Paragraph style={styles.subtitle}>Historial y gestión de ventas</Paragraph>
      
      <Button
        mode="contained"
        onPress={() => navigation.navigate('POS')}
        style={styles.button}
        icon="cash-register"
      >
        Nueva Venta (POS)
      </Button>
      
      <Button
        mode="outlined"
        onPress={() => {}}
        style={styles.button}
        icon="history"
      >
        Ver Historial
      </Button>
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
    marginBottom: spacing.sm,
    color: colors.text,
  },
  subtitle: {
    ...typography.body1,
    marginBottom: spacing.xl,
    color: colors.textSecondary,
  },
  button: {
    marginBottom: spacing.md,
  },
});
