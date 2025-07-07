import axios from 'axios';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Platform } from 'react-native';

// Configure API URL based on platform
const getApiBaseUrl = () => {
  if (Platform.OS === 'web') {
    return 'http://localhost:8000/api/v1';
  }
  // For mobile devices, use the network IP
  return 'http://192.168.1.65:8000/api/v1'; // Replace with your actual IP
};

const API_BASE_URL = getApiBaseUrl();

// Create axios instance
const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add token to requests
apiClient.interceptors.request.use(async (config) => {
  const token = await AsyncStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Handle token expiration
apiClient.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status === 401) {
      await AsyncStorage.removeItem('token');
      // Navigate to login screen
    }
    return Promise.reject(error);
  }
);

// Auth API
export const authAPI = {
  login: async (email: string, password: string) => {
    console.log('🔐 Attempting login to:', `${API_BASE_URL}/auth/login`);
    const response = await apiClient.post('/auth/login', { email, password });
    console.log('✅ Login response:', response.data);
    return response.data;
  },

  register: async (email: string, password: string, name: string) => {
    console.log('📝 Attempting register to:', `${API_BASE_URL}/auth/register`);
    const response = await apiClient.post('/auth/register', { 
      email, 
      password, 
      name 
    });
    console.log('✅ Register response:', response.data);
    return response.data;
  },

  me: async () => {
    console.log('👤 Fetching user info from:', `${API_BASE_URL}/auth/me`);
    const response = await apiClient.get('/auth/me');
    console.log('✅ User info response:', response.data);
    return response.data;
  },
};

// Products API
export const productsAPI = {
  getAll: async () => {
    const response = await apiClient.get('/products');
    return response.data;
  },

  getById: async (id: string) => {
    const response = await apiClient.get(`/products/${id}`);
    return response.data;
  },

  create: async (product: any) => {
    const response = await apiClient.post('/products', product);
    return response.data;
  },

  update: async (id: string, product: any) => {
    const response = await apiClient.put(`/products/${id}`, product);
    return response.data;
  },

  delete: async (id: string) => {
    const response = await apiClient.delete(`/products/${id}`);
    return response.data;
  },
};

// Inventory API
export const inventoryAPI = {
  getByWarehouse: async (warehouseId: string) => {
    const response = await apiClient.get(`/inventory/warehouse/${warehouseId}`);
    return response.data;
  },

  updateStock: async (productId: string, warehouseId: string, quantity: number) => {
    const response = await apiClient.patch('/inventory/stock', {
      product_id: productId,
      warehouse_id: warehouseId,
      quantity,
    });
    return response.data;
  },
};

// Sales API
export const salesAPI = {
  getAll: async () => {
    const response = await apiClient.get('/sales');
    return response.data;
  },

  create: async (sale: any) => {
    const response = await apiClient.post('/sales', sale);
    return response.data;
  },

  getById: async (id: string) => {
    const response = await apiClient.get(`/sales/${id}`);
    return response.data;
  },
};

// Purchases API
export const purchasesAPI = {
  getAll: async () => {
    const response = await apiClient.get('/purchases');
    return response.data;
  },

  create: async (purchase: any) => {
    const response = await apiClient.post('/purchases', purchase);
    return response.data;
  },

  getById: async (id: string) => {
    const response = await apiClient.get(`/purchases/${id}`);
    return response.data;
  },
};

// Businesses API
export const businessesAPI = {
  getAll: async () => {
    const response = await apiClient.get('/businesses');
    return response.data;
  },

  create: async (business: any) => {
    const response = await apiClient.post('/businesses', business);
    return response.data;
  },

  getById: async (id: string) => {
    const response = await apiClient.get(`/businesses/${id}`);
    return response.data;
  },
};

// Warehouses API
export const warehousesAPI = {
  getAll: async () => {
    const response = await apiClient.get('/warehouses');
    return response.data;
  },

  create: async (warehouse: any) => {
    const response = await apiClient.post('/warehouses', warehouse);
    return response.data;
  },

  getById: async (id: string) => {
    const response = await apiClient.get(`/warehouses/${id}`);
    return response.data;
  },
};

export default apiClient;
