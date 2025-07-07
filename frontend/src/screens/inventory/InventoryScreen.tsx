import React from 'react';
import { View, StyleSheet } from 'react-native';
import { Title, Paragraph, Button } from 'react-native-paper';
import { colors, spacing, typography } from '../../styles/theme';

export default function InventoryScreen({ navigation }: any) {
  return (
    <View style={styles.container}>
      <Title style={styles.title}>Inventario</Title>
      <Paragraph style={styles.subtitle}>Gestión de stock por almacén</Paragraph>
      
      <Button
        mode="contained"
        onPress={() => navigation.navigate('ProductCatalog')}
        style={styles.button}
        icon="clipboard-list"
      >
        Ver Stock Actual
      </Button>
      
      <Button
        mode="outlined"
        onPress={() => navigation.navigate('InventoryMovementForm', { movementType: 'adjustment' })}
        style={styles.button}
        icon="plus-circle"
      >
        Ajustar Inventario
      </Button>

      <Button
        mode="outlined"
        onPress={() => navigation.navigate('InventoryMovementForm', { movementType: 'entry' })}
        style={styles.button}
        icon="arrow-down-circle"
      >
        Entrada de Inventario
      </Button>

      <Button
        mode="outlined"
        onPress={() => navigation.navigate('InventoryMovementForm', { movementType: 'exit' })}
        style={styles.button}
        icon="arrow-up-circle"
      >
        Salida de Inventario
      </Button>

      <Button
        mode="outlined"
        onPress={() => navigation.navigate('InventoryMovementForm', { movementType: 'transfer' })}
        style={styles.button}
        icon="swap-horizontal"
      >
        Transferencia entre Almacenes
      </Button>

      {/* Multi-Item Operations */}
      <Title style={[styles.title, { marginTop: spacing.xl, fontSize: 18 }]}>Operaciones Multi-Producto</Title>
      
      <Button
        mode="contained"
        onPress={() => navigation.navigate('InventoryMultiItemForm', { movementType: 'entry' })}
        style={[styles.button, { backgroundColor: colors.success }]}
        icon="package-variant-closed"
      >
        Entrada Multi-Producto
      </Button>

      <Button
        mode="outlined"
        onPress={() => navigation.navigate('InventoryMultiItemForm', { movementType: 'exit' })}
        style={styles.button}
        icon="package-variant"
      >
        Salida Multi-Producto
      </Button>

      <Button
        mode="outlined"
        onPress={() => navigation.navigate('InventoryMultiItemForm', { movementType: 'adjustment' })}
        style={styles.button}
        icon="tune"
      >
        Ajuste Multi-Producto
      </Button>

      <Button
        mode="outlined"
        onPress={() => navigation.navigate('StockAlerts')}
        style={styles.button}
        icon="alert-circle"
      >
        Alertas de Stock
      </Button>

      {/* Historial de Movimientos */}
      <Title style={[styles.title, { marginTop: spacing.xl, fontSize: 18 }]}>Historial</Title>
      
      <Button
        mode="contained"
        onPress={() => navigation.navigate('MovementHistory')}
        style={[styles.button, { backgroundColor: colors.primary }]}
        icon="history"
      >
        Ver Historial de Movimientos
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
