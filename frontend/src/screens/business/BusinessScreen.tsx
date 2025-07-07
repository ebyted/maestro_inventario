import React from 'react';
import { View, StyleSheet } from 'react-native';
import { Title, Paragraph, Button } from 'react-native-paper';
import { useSelector } from 'react-redux';
import { RootState } from '../../store/store';
import { colors, spacing, typography } from '../../styles/theme';

export default function BusinessScreen({ navigation }: any) {
  const { selectedBusiness, selectedWarehouse } = useSelector((state: RootState) => state.business);

  return (
    <View style={styles.container}>
      <Title style={styles.title}>Configuración del Negocio</Title>
      
      <View style={styles.infoSection}>
        <Paragraph style={styles.label}>Negocio Actual:</Paragraph>
        <Paragraph style={styles.value}>{selectedBusiness?.name || 'No seleccionado'}</Paragraph>
        
        <Paragraph style={styles.label}>Almacén Actual:</Paragraph>
        <Paragraph style={styles.value}>{selectedWarehouse?.name || 'No seleccionado'}</Paragraph>
      </View>
      
      <Button
        mode="contained"
        onPress={() => {}}
        style={styles.button}
        icon="office-building"
      >
        Gestionar Negocios
      </Button>
      
      <Button
        mode="outlined"
        onPress={() => {}}
        style={styles.button}
        icon="warehouse"
      >
        Gestionar Almacenes
      </Button>
      
      <Button
        mode="outlined"
        onPress={() => {}}
        style={styles.button}
        icon="account-group"
      >
        Gestionar Usuarios
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
    marginBottom: spacing.xl,
    color: colors.text,
  },
  infoSection: {
    backgroundColor: colors.white,
    padding: spacing.lg,
    borderRadius: 8,
    marginBottom: spacing.xl,
  },
  label: {
    ...typography.body2,
    color: colors.textSecondary,
    marginBottom: spacing.xs,
  },
  value: {
    ...typography.h4,
    color: colors.text,
    marginBottom: spacing.md,
  },
  button: {
    marginBottom: spacing.md,
  },
});
