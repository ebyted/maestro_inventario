import React from 'react';
import { createStackNavigator } from '@react-navigation/stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Ionicons } from '@expo/vector-icons';
import { useSelector } from 'react-redux';
import { useTranslation } from 'react-i18next';
import { RootState } from '../store/store';

// Auth Screens
import AuthWelcomeScreen from '../screens/auth/AuthWelcomeScreen';
import LoginScreen from '../screens/auth/LoginScreen';
import RegisterScreen from '../screens/auth/RegisterScreen';

// Main Screens
import DashboardScreen from '../screens/DashboardScreen';
import ProductsScreen from '../screens/products/ProductsScreen';
import ProductCatalogScreen from '../screens/products/ProductCatalogScreen';
import DebugProductsScreen from '../screens/products/DebugProductsScreen';
import SimpleProductTestScreen from '../screens/products/SimpleProductTestScreen';
import CreateProductScreen from '../screens/products/CreateProductScreen';
import ProductDetailScreen from '../screens/products/ProductDetailScreen';
import InventoryScreen from '../screens/inventory/InventoryScreen';
import ProductCatalogSimpleScreen from '../screens/products/ProductCatalogSimpleScreen';
import InventoryMovementSimpleScreen from '../screens/inventory/InventoryMovementSimpleScreen';
import InventoryMovementFormScreen from '../screens/inventory/InventoryMovementFormScreen';
import SalesScreen from '../screens/sales/SalesScreen';
import POSScreen from '../screens/sales/POSScreen';
import BusinessScreen from '../screens/business/BusinessScreen';
import SettingsScreen from '../screens/SettingsScreen';
import InventoryMultiItemFormScreen from '../screens/inventory/InventoryMultiItemFormScreen';
import MovementHistoryScreen from '../screens/inventory/MovementHistoryScreen';

// Suppliers and Purchases Screens
import SuppliersScreen from '../screens/suppliers/SuppliersScreen';
import PurchaseOrdersScreen from '../screens/purchases/PurchaseOrdersScreen';

const Stack = createStackNavigator();
const Tab = createBottomTabNavigator();

function AuthStack() {
  return (
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      <Stack.Screen name="AuthWelcome" component={AuthWelcomeScreen} />
      <Stack.Screen name="Login" component={LoginScreen} />
      <Stack.Screen name="Register" component={RegisterScreen} />
    </Stack.Navigator>
  );
}

function ProductsStack() {
  const { t } = useTranslation();
  
  return (
    <Stack.Navigator>
      <Stack.Screen name="ProductsList" component={ProductCatalogScreen} options={{ title: 'Catálogo de Productos' }} />
      <Stack.Screen name="DebugProducts" component={DebugProductsScreen} options={{ title: 'Debug Productos' }} />
      <Stack.Screen name="SimpleTest" component={SimpleProductTestScreen} options={{ title: 'Prueba Simple' }} />
      <Stack.Screen name="CreateProduct" component={CreateProductScreen} options={{ title: 'Crear Producto' }} />
      <Stack.Screen name="ProductCatalog" component={ProductCatalogScreen} options={{ title: t('products.catalog') }} />
      <Stack.Screen name="ProductDetail" component={ProductDetailScreen} options={{ title: t('products.detail') }} />
    </Stack.Navigator>
  );
}

function InventoryStack() {
  const { t } = useTranslation();
  
  return (
    <Stack.Navigator>
      <Stack.Screen name="InventoryMain" component={InventoryScreen} options={{ title: t('inventory.title') }} />
      <Stack.Screen name="ProductCatalog" component={ProductCatalogScreen} options={{ title: t('inventory.stockView') }} />
      <Stack.Screen name="InventoryMovement" component={InventoryMovementSimpleScreen} options={{ title: t('inventory.adjustInventory') }} />
      <Stack.Screen name="InventoryMovementForm" component={InventoryMovementFormScreen} options={{ title: t('inventory.movements.movement') }} />
      <Stack.Screen name="InventoryMultiItemForm" component={InventoryMultiItemFormScreen} options={{ title: t('inventory.movements.multiItem') }} />
      <Stack.Screen name="MovementHistory" component={MovementHistoryScreen} options={{ title: t('inventory.movements.history') }} />
      <Stack.Screen name="ProductDetail" component={ProductDetailScreen} options={{ title: t('products.detail') }} />
    </Stack.Navigator>
  );
}

function SalesStack() {
  const { t } = useTranslation();
  
  return (
    <Stack.Navigator>
      <Stack.Screen name="SalesList" component={SalesScreen} options={{ title: t('sales.title') }} />
      <Stack.Screen name="POS" component={POSScreen} options={{ title: t('sales.pos') }} />
    </Stack.Navigator>
  );
}

function SuppliersStack() {
  const { t } = useTranslation();
  
  return (
    <Stack.Navigator>
      <Stack.Screen name="SuppliersList" component={SuppliersScreen} options={{ title: t('suppliers.title') }} />
    </Stack.Navigator>
  );
}

function PurchasesStack() {
  const { t } = useTranslation();
  
  return (
    <Stack.Navigator>
      <Stack.Screen name="PurchaseOrdersList" component={PurchaseOrdersScreen} options={{ title: t('purchases.title') }} />
    </Stack.Navigator>
  );
}

function MainTabs() {
  const { t } = useTranslation();
  
  return (
    <Tab.Navigator
      screenOptions={({ route }: { route: any }) => ({
        tabBarIcon: ({ focused, color, size }: { focused: boolean; color: string; size: number }) => {
          let iconName;

          switch (route.name) {
            case 'Dashboard':
              iconName = focused ? 'home' : 'home-outline';
              break;
            case 'Products':
              iconName = focused ? 'cube' : 'cube-outline';
              break;
            case 'Inventory':
              iconName = focused ? 'list' : 'list-outline';
              break;
            case 'Suppliers':
              iconName = focused ? 'business' : 'business-outline';
              break;
            case 'Purchases':
              iconName = focused ? 'receipt' : 'receipt-outline';
              break;
            case 'Sales':
              iconName = focused ? 'cash' : 'cash-outline';
              break;
            case 'Settings':
              iconName = focused ? 'settings' : 'settings-outline';
              break;
            default:
              iconName = 'circle';
          }

          return <Ionicons name={iconName as any} size={size} color={color} />;
        },
        tabBarActiveTintColor: '#2196F3',
        tabBarInactiveTintColor: 'gray',
      })}
    >
      <Tab.Screen 
        name="Dashboard" 
        component={DashboardScreen} 
        options={{ title: t('navigation.dashboard') }} 
      />
      <Tab.Screen 
        name="Products" 
        component={ProductsStack} 
        options={{ title: t('navigation.products'), headerShown: false }} 
      />
      <Tab.Screen 
        name="Inventory" 
        component={InventoryStack} 
        options={{ title: t('navigation.inventory'), headerShown: false }} 
      />
      <Tab.Screen 
        name="Suppliers" 
        component={SuppliersStack} 
        options={{ title: t('suppliers.title'), headerShown: false }} 
      />
      <Tab.Screen 
        name="Purchases" 
        component={PurchasesStack} 
        options={{ title: t('purchases.title'), headerShown: false }} 
      />
      <Tab.Screen 
        name="Sales" 
        component={SalesStack} 
        options={{ title: t('navigation.sales'), headerShown: false }} 
      />
      <Tab.Screen 
        name="Settings" 
        component={SettingsScreen} 
        options={{ title: t('settings.title') }} 
      />
    </Tab.Navigator>
  );
}

export default function AppNavigator() {
  const isAuthenticated = useSelector((state: RootState) => state.auth.isAuthenticated);
  const user = useSelector((state: RootState) => state.auth.user);
  
  // Debug logs
  console.log('🔍 AppNavigator render:', { isAuthenticated, user: user?.email || 'none' });

  // TEMPORAL: Saltar autenticación para testing
  const skipAuth = true; // Cambiar a false cuando quieras usar autenticación

  return (
    <Stack.Navigator screenOptions={{ headerShown: false }}>
      {(isAuthenticated || skipAuth) ? (
        <Stack.Screen name="Main" component={MainTabs} />
      ) : (
        <Stack.Screen name="Auth" component={AuthStack} />
      )}
    </Stack.Navigator>
  );
}
