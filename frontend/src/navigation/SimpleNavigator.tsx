import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Ionicons } from '@expo/vector-icons';
import { SafeAreaProvider } from 'react-native-safe-area-context';

// Import screens directly
import DashboardScreen from '../screens/DashboardScreen';
import ProductCatalogScreen from '../screens/products/ProductCatalogScreen';
import DebugProductsScreen from '../screens/products/DebugProductsScreen';
import CreateProductScreen from '../screens/products/CreateProductScreen';
import ProductDetailScreen from '../screens/products/ProductDetailScreen';
import InventoryScreen from '../screens/inventory/InventoryScreen';
import SalesScreen from '../screens/sales/SalesScreen';
import POSScreen from '../screens/sales/POSScreen';
import SettingsScreen from '../screens/SettingsScreen';

const Stack = createStackNavigator();
const Tab = createBottomTabNavigator();

function ProductsStack() {
  return (
    <Stack.Navigator>
      <Stack.Screen 
        name="ProductsList" 
        component={DebugProductsScreen} 
        options={{ title: 'Debug Productos' }} 
      />
      <Stack.Screen 
        name="ProductCatalog" 
        component={ProductCatalogScreen} 
        options={{ title: 'Catálogo Completo' }} 
      />
      <Stack.Screen 
        name="CreateProduct" 
        component={CreateProductScreen} 
        options={{ title: 'Crear Producto' }} 
      />
      <Stack.Screen 
        name="ProductDetail" 
        component={ProductDetailScreen} 
        options={{ title: 'Detalle Producto' }} 
      />
    </Stack.Navigator>
  );
}

function SalesStack() {
  return (
    <Stack.Navigator>
      <Stack.Screen 
        name="SalesList" 
        component={SalesScreen} 
        options={{ title: 'Ventas' }} 
      />
      <Stack.Screen 
        name="POS" 
        component={POSScreen} 
        options={{ title: 'Punto de Venta' }} 
      />
    </Stack.Navigator>
  );
}

function MainTabs() {
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
        options={{ title: 'Dashboard' }} 
      />
      <Tab.Screen 
        name="Products" 
        component={ProductsStack} 
        options={{ title: 'Productos', headerShown: false }} 
      />
      <Tab.Screen 
        name="Inventory" 
        component={InventoryScreen} 
        options={{ title: 'Inventario' }} 
      />
      <Tab.Screen 
        name="Sales" 
        component={SalesStack} 
        options={{ title: 'Ventas', headerShown: false }} 
      />
      <Tab.Screen 
        name="Settings" 
        component={SettingsScreen} 
        options={{ title: 'Configuración' }} 
      />
    </Tab.Navigator>
  );
}

export default function SimpleNavigator() {
  console.log('🚀 SimpleNavigator: Navegación sin autenticación cargada');
  
  return (
    <SafeAreaProvider>
      <NavigationContainer>
        <Stack.Navigator screenOptions={{ headerShown: false }}>
          <Stack.Screen name="Main" component={MainTabs} />
        </Stack.Navigator>
      </NavigationContainer>
    </SafeAreaProvider>
  );
}
