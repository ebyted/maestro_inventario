import axios from 'axios';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Platform } from 'react-native';

// Configure API URL based on platform
const getApiBaseUrl = () => {
  if (Platform.OS === 'web') {
    return 'http://localhost:8000/api/v1';  // Puerto correcto del backend
  }
  // For mobile devices, use the network IP
  return 'http://192.168.1.74:8000/api/v1'; // Puerto correcto del backend
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

export const apiService = {
  // Authentication
  async login(email: string, password: string) {
    const response = await apiClient.post('/auth/login', { email, password });
    const { access_token } = response.data;
    await AsyncStorage.setItem('token', access_token);
    return response.data;
  },

  async register(userData: any) {
    const response = await apiClient.post('/auth/register', userData);
    return response.data;
  },

  async getCurrentUser() {
    const response = await apiClient.get('/auth/me');
    return response.data;
  },

  // Businesses
  async getBusinesses() {
    const response = await apiClient.get('/businesses');
    return response.data;
  },

  async createBusiness(business: any) {
    const response = await apiClient.post('/businesses', business);
    return response.data;
  },

  // Warehouses
  async getWarehouses(businessId?: number) {
    const url = businessId ? `/warehouses?business_id=${businessId}` : '/warehouses';
    const response = await apiClient.get(url);
    return response.data;
  },

  async createWarehouse(warehouse: any) {
    const response = await apiClient.post('/warehouses', warehouse);
    return response.data;
  },

  // Products
  async getProducts(businessId?: number) {
    const url = businessId ? `/products?business_id=${businessId}` : '/products';
    const response = await apiClient.get(url);
    return response.data;
  },

  async createProduct(product: any) {
    const response = await apiClient.post('/products', product);
    return response.data;
  },

  async getProduct(productId: number) {
    const response = await apiClient.get(`/products/${productId}`);
    return response.data;
  },

  async createProductVariant(productId: number, variant: any) {
    const response = await apiClient.post(`/products/${productId}/variants`, variant);
    return response.data;
  },

  async getProductVariants(productId: number) {
    const response = await apiClient.get(`/products/${productId}/variants`);
    return response.data;
  },

  // Inventory
  async getInventory(warehouseId?: number) {
    const url = warehouseId ? `/inventory?warehouse_id=${warehouseId}` : '/inventory';
    const response = await apiClient.get(url);
    return response.data;
  },

  async adjustInventory(inventoryData: any) {
    const response = await apiClient.post('/inventory/adjust', inventoryData);
    return response.data;
  },

  // Sales
  async getSales(warehouseId?: number) {
    const url = warehouseId ? `/sales?warehouse_id=${warehouseId}` : '/sales';
    const response = await apiClient.get(url);
    return response.data;
  },

  async createSale(saleData: any) {
    const response = await apiClient.post('/sales', saleData);
    return response.data;
  },

  // Suppliers
  async getSuppliers(businessId?: number) {
    const url = businessId ? `/suppliers?business_id=${businessId}` : '/suppliers';
    const response = await apiClient.get(url);
    return response.data;
  },

  async createSupplier(supplier: any, businessId: number) {
    const response = await apiClient.post(`/suppliers?business_id=${businessId}`, supplier);
    return response.data;
  },

  async getSupplier(supplierId: number) {
    const response = await apiClient.get(`/suppliers/${supplierId}`);
    return response.data;
  },

  async updateSupplier(supplierId: number, supplier: any) {
    const response = await apiClient.put(`/suppliers/${supplierId}`, supplier);
    return response.data;
  },

  async deleteSupplier(supplierId: number) {
    const response = await apiClient.delete(`/suppliers/${supplierId}`);
    return response.data;
  },

  // Purchase Orders
  async getPurchaseOrders(businessId: number, params?: any) {
    const queryParams = new URLSearchParams(params).toString();
    const url = `/purchases?business_id=${businessId}${queryParams ? '&' + queryParams : ''}`;
    const response = await apiClient.get(url);
    return response.data;
  },

  async createPurchaseOrder(purchaseOrder: any, businessId: number) {
    const response = await apiClient.post(`/purchases?business_id=${businessId}`, purchaseOrder);
    return response.data;
  },

  async getPurchaseOrder(purchaseOrderId: number) {
    const response = await apiClient.get(`/purchases/${purchaseOrderId}`);
    return response.data;
  },

  async updatePurchaseOrder(purchaseOrderId: number, purchaseOrder: any) {
    const response = await apiClient.put(`/purchases/${purchaseOrderId}`, purchaseOrder);
    return response.data;
  },

  async updatePurchaseOrderStatus(purchaseOrderId: number, status: string) {
    const response = await apiClient.patch(`/purchases/${purchaseOrderId}/status`, { status });
    return response.data;
  },

  async createPurchaseReceipt(purchaseOrderId: number, receipt: any) {
    const response = await apiClient.post(`/purchases/${purchaseOrderId}/receipts`, receipt);
    return response.data;
  },

  async getPurchaseReceipts(purchaseOrderId: number) {
    const response = await apiClient.get(`/purchases/${purchaseOrderId}/receipts`);
    return response.data;
  },

  async cancelPurchaseOrder(purchaseOrderId: number) {
    const response = await apiClient.delete(`/purchases/${purchaseOrderId}`);
    return response.data;
  },

  // Categories
  async getCategories(businessId?: number) {
    const url = businessId ? `/categories?business_id=${businessId}` : '/categories';
    const response = await apiClient.get(url);
    return response.data;
  },

  async createCategory(category: any, businessId: number) {
    const response = await apiClient.post(`/categories?business_id=${businessId}`, category);
    return response.data;
  },

  async getCategory(categoryId: number) {
    const response = await apiClient.get(`/categories/${categoryId}`);
    return response.data;
  },

  async updateCategory(categoryId: number, category: any) {
    const response = await apiClient.put(`/categories/${categoryId}`, category);
    return response.data;
  },

  async deleteCategory(categoryId: number) {
    const response = await apiClient.delete(`/categories/${categoryId}`);
    return response.data;
  },

  // Brands
  async getBrands(businessId?: number) {
    const url = businessId ? `/brands?business_id=${businessId}` : '/brands';
    const response = await apiClient.get(url);
    return response.data;
  },

  async createBrand(brand: any, businessId: number) {
    const response = await apiClient.post(`/brands?business_id=${businessId}`, brand);
    return response.data;
  },

  async getBrand(brandId: number) {
    const response = await apiClient.get(`/brands/${brandId}`);
    return response.data;
  },

  async updateBrand(brandId: number, brand: any) {
    const response = await apiClient.put(`/brands/${brandId}`, brand);
    return response.data;
  },

  async deleteBrand(brandId: number) {
    const response = await apiClient.delete(`/brands/${brandId}`);
    return response.data;
  },

  // Units
  async getUnits(businessId?: number) {
    const url = businessId ? `/units?business_id=${businessId}` : '/units';
    const response = await apiClient.get(url);
    return response.data;
  },

  async createUnit(unit: any, businessId: number) {
    const response = await apiClient.post(`/units?business_id=${businessId}`, unit);
    return response.data;
  },

  async getUnit(unitId: number) {
    const response = await apiClient.get(`/units/${unitId}`);
    return response.data;
  },

  async updateUnit(unitId: number, unit: any) {
    const response = await apiClient.put(`/units/${unitId}`, unit);
    return response.data;
  },

  async deleteUnit(unitId: number) {
    const response = await apiClient.delete(`/units/${unitId}`);
    return response.data;
  },

  // Inventory Movements
  async getInventoryMovements(warehouseId?: number, params?: any) {
    const queryParams = new URLSearchParams(params).toString();
    const baseUrl = warehouseId ? `/inventory/movements?warehouse_id=${warehouseId}` : '/inventory/movements';
    const url = `${baseUrl}${queryParams ? (warehouseId ? '&' : '?') + queryParams : ''}`;
    const response = await apiClient.get(url);
    return response.data;
  },

  // Generic HTTP methods
  async get(url: string, config?: any) {
    const response = await apiClient.get(url, config);
    return response;
  },

  async post(url: string, data?: any, config?: any) {
    const response = await apiClient.post(url, data, config);
    return response;
  },

  async put(url: string, data?: any, config?: any) {
    const response = await apiClient.put(url, data, config);
    return response;
  },

  async delete(url: string, config?: any) {
    const response = await apiClient.delete(url, config);
    return response;
  },

  async patch(url: string, data?: any, config?: any) {
    const response = await apiClient.patch(url, data, config);
    return response;
  },
};
