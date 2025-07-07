import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, FlatList, Alert, TouchableOpacity, TextInput } from 'react-native';
import { Card, Title, Paragraph, Button, Divider } from 'react-native-paper';
import AsyncStorage from '@react-native-async-storage/async-storage';

interface Product {
  id: number;
  name: string;
  sku: string;
  price: number;
  stock?: number;
  category?: string;
  brand?: string;
  is_active: boolean;
}

interface CartItem extends Product {
  quantity: number;
}

export default function POSScreen({ navigation }: any) {
  const [cart, setCart] = useState<CartItem[]>([]);
  const [total, setTotal] = useState(0);
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchText, setSearchText] = useState('');

  useEffect(() => {
    loadProducts();
  }, []);

  useEffect(() => {
    // Recalcular total cuando cambie el carrito
    const newTotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    setTotal(newTotal);
  }, [cart]);

  const loadProducts = async () => {
    try {
      setLoading(true);

      // Verificar si hay token
      const token = await AsyncStorage.getItem('token');

      if (!token) {
        // Intentar login automático
        const loginSuccess = await autoLogin();
        if (!loginSuccess) {
          throw new Error('No se pudo hacer login automático');
        }
      }

      // Hacer petición a productos activos con precios
      const finalToken = await AsyncStorage.getItem('token');
      
      const response = await fetch('http://localhost:8000/api/v1/products?limit=100&active_only=true', {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${finalToken}`
        }
      });

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }

      const data = await response.json();
      
      // Filtrar productos activos y con precio (para POS solo productos vendibles)
      const sellableProducts = data.filter((product: Product) => 
        product.is_active && product.price && product.price > 0
      );
      
      setProducts(sellableProducts);
      
    } catch (error: any) {
      Alert.alert('Error', 'No se pudieron cargar los productos: ' + error.message);
      // Usar productos de ejemplo en caso de error
      setProducts([
        { id: 1, name: 'Producto Ejemplo', sku: 'DEMO001', price: 10.50, is_active: true },
        { id: 2, name: 'Producto B', sku: 'DEMO002', price: 25.00, is_active: true },
        { id: 3, name: 'Producto C', sku: 'DEMO003', price: 8.75, is_active: true },
      ]);
    } finally {
      setLoading(false);
    }
  };

  const autoLogin = async (): Promise<boolean> => {
    try {
      const response = await fetch('http://localhost:8000/api/v1/auth/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          email: 'admin@maestro.com',
          password: 'admin123'
        })
      });

      if (response.ok) {
        const data = await response.json();
        await AsyncStorage.setItem('token', data.access_token);
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  };

  const filteredProducts = products.filter(product =>
    product.name.toLowerCase().includes(searchText.toLowerCase()) ||
    product.sku.toLowerCase().includes(searchText.toLowerCase())
  );

  const addToCart = (product: Product) => {
    // Verificar stock si está disponible
    if (product.stock !== undefined && product.stock <= 0) {
      Alert.alert('Sin Stock', 'Este producto no tiene stock disponible');
      return;
    }

    const existingItem = cart.find(item => item.id === product.id);
    if (existingItem) {
      // Verificar que no exceda el stock
      if (product.stock !== undefined && existingItem.quantity >= product.stock) {
        Alert.alert('Stock Insuficiente', `Solo hay ${product.stock} unidades disponibles`);
        return;
      }
      
      setCart(cart.map(item =>
        item.id === product.id
          ? { ...item, quantity: item.quantity + 1 }
          : item
      ));
    } else {
      setCart([...cart, { ...product, quantity: 1 }]);
    }
  };

  const removeFromCart = (productId: number) => {
    setCart(cart.filter(item => item.id !== productId));
  };

  const updateQuantity = (productId: number, newQuantity: number) => {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }

    const product = products.find(p => p.id === productId);
    if (product && product.stock !== undefined && newQuantity > product.stock) {
      Alert.alert('Stock Insuficiente', `Solo hay ${product.stock} unidades disponibles`);
      return;
    }

    setCart(cart.map(item =>
      item.id === productId
        ? { ...item, quantity: newQuantity }
        : item
    ));
  };

  const processSale = () => {
    if (cart.length === 0) {
      Alert.alert('Carrito Vacío', 'Agregue productos al carrito antes de procesar la venta');
      return;
    }

    Alert.alert(
      'Procesar Venta',
      `Total: $${total.toFixed(2)}\n¿Confirmar venta?`,
      [
        { text: 'Cancelar', style: 'cancel' },
        { 
          text: 'Confirmar', 
          onPress: () => {
            // TODO: Aquí se procesaría la venta en el backend
            Alert.alert('Venta Procesada', 'La venta se procesó exitosamente');
            setCart([]);
            setTotal(0);
          }
        }
      ]
    );
  };

  const renderProduct = ({ item }: { item: Product }) => (
    <Card style={styles.productCard} onPress={() => addToCart(item)}>
      <Card.Content>
        <Paragraph style={styles.productName}>{item.name}</Paragraph>
        <Paragraph style={styles.productSku}>SKU: {item.sku}</Paragraph>
        <Paragraph style={styles.productPrice}>${item.price.toFixed(2)}</Paragraph>
        {item.stock !== undefined && (
          <Paragraph style={[styles.productStock, { color: item.stock > 0 ? '#28a745' : '#dc3545' }]}>
            Stock: {item.stock}
          </Paragraph>
        )}
      </Card.Content>
    </Card>
  );

  const renderCartItem = ({ item }: { item: CartItem }) => (
    <View style={styles.cartItem}>
      <View style={styles.cartItemInfo}>
        <Paragraph style={styles.cartItemName}>{item.name}</Paragraph>
        <Paragraph style={styles.cartItemPrice}>${item.price.toFixed(2)} c/u</Paragraph>
      </View>
      <View style={styles.cartItemControls}>
        <TouchableOpacity 
          style={styles.quantityButton} 
          onPress={() => updateQuantity(item.id, item.quantity - 1)}
        >
          <Text style={styles.quantityButtonText}>-</Text>
        </TouchableOpacity>
        <Text style={styles.cartItemQuantity}>{item.quantity}</Text>
        <TouchableOpacity 
          style={styles.quantityButton} 
          onPress={() => updateQuantity(item.id, item.quantity + 1)}
        >
          <Text style={styles.quantityButtonText}>+</Text>
        </TouchableOpacity>
      </View>
      <View style={styles.cartItemTotal}>
        <Paragraph style={styles.cartItemTotalPrice}>${(item.price * item.quantity).toFixed(2)}</Paragraph>
        <TouchableOpacity onPress={() => removeFromCart(item.id)}>
          <Text style={styles.removeButton}>🗑️</Text>
        </TouchableOpacity>
      </View>
    </View>
  );

  return (
    <View style={styles.container}>
      <View style={styles.productsSection}>
        <Title style={styles.sectionTitle}>Productos</Title>
        
        {/* Búsqueda */}
        <View style={styles.searchContainer}>
          <TextInput
            style={styles.searchInput}
            placeholder="Buscar productos..."
            value={searchText}
            onChangeText={setSearchText}
            placeholderTextColor="#999"
          />
        </View>

        <FlatList
          data={filteredProducts}
          renderItem={renderProduct}
          keyExtractor={(item) => item.id.toString()}
          numColumns={2}
          contentContainerStyle={styles.productsList}
          ListEmptyComponent={
            <Text style={styles.emptyText}>
              {loading ? 'Cargando productos...' : 'No hay productos disponibles'}
            </Text>
          }
        />
      </View>

      <View style={styles.cartSection}>
        <Title style={styles.sectionTitle}>Carrito de Venta</Title>
        
        <FlatList
          data={cart}
          renderItem={renderCartItem}
          keyExtractor={(item) => item.id.toString()}
          style={styles.cartList}
          ListEmptyComponent={
            <Text style={styles.emptyCartText}>Carrito vacío</Text>
          }
        />

        <Divider />
        
        <View style={styles.totalSection}>
          <Text style={styles.totalText}>Total: ${total.toFixed(2)}</Text>
          <Button 
            mode="contained" 
            onPress={processSale}
            style={styles.checkoutButton}
            disabled={cart.length === 0}
          >
            Procesar Venta
          </Button>
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: 'row',
    backgroundColor: '#f5f5f5',
  },
  productsSection: {
    flex: 2,
    padding: 16,
  },
  cartSection: {
    flex: 1,
    padding: 16,
    backgroundColor: 'white',
    borderLeftWidth: 1,
    borderLeftColor: '#ddd',
  },
  sectionTitle: {
    marginBottom: 16,
    fontSize: 18,
    fontWeight: 'bold',
  },
  searchContainer: {
    marginBottom: 16,
  },
  searchInput: {
    backgroundColor: 'white',
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: '#ddd',
  },
  productsList: {
    paddingBottom: 16,
  },
  productCard: {
    flex: 1,
    margin: 4,
    maxWidth: '48%',
  },
  productName: {
    fontWeight: 'bold',
    fontSize: 14,
  },
  productSku: {
    fontSize: 12,
    color: '#666',
  },
  productPrice: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#28a745',
  },
  productStock: {
    fontSize: 12,
  },
  cartList: {
    flex: 1,
    marginBottom: 16,
  },
  cartItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 8,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  cartItemInfo: {
    flex: 2,
  },
  cartItemName: {
    fontWeight: 'bold',
    fontSize: 14,
  },
  cartItemPrice: {
    fontSize: 12,
    color: '#666',
  },
  cartItemControls: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  quantityButton: {
    backgroundColor: '#007bff',
    borderRadius: 4,
    paddingHorizontal: 8,
    paddingVertical: 4,
    minWidth: 30,
    alignItems: 'center',
  },
  quantityButtonText: {
    color: 'white',
    fontWeight: 'bold',
  },
  cartItemQuantity: {
    marginHorizontal: 12,
    fontSize: 16,
    fontWeight: 'bold',
  },
  cartItemTotal: {
    alignItems: 'flex-end',
    flex: 1,
  },
  cartItemTotalPrice: {
    fontWeight: 'bold',
    color: '#28a745',
  },
  removeButton: {
    fontSize: 18,
    marginTop: 4,
  },
  totalSection: {
    alignItems: 'center',
    paddingTop: 16,
  },
  totalText: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 16,
    color: '#333',
  },
  checkoutButton: {
    width: '100%',
  },
  emptyText: {
    textAlign: 'center',
    color: '#666',
    marginTop: 32,
  },
  emptyCartText: {
    textAlign: 'center',
    color: '#666',
    marginTop: 16,
  },
});
