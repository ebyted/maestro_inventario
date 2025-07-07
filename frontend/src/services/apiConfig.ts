// Configuración central del API
export const API_CONFIG = {
  BASE_URL: 'http://localhost:8000',
  API_VERSION: '/api/v1',
  ENDPOINTS: {
    AUTH: {
      LOGIN: '/auth/login',
      LOGOUT: '/auth/logout',
      REFRESH: '/auth/refresh'
    },
    PRODUCTS: {
      LIST: '/products',
      DETAIL: '/products/{id}',
      CREATE: '/products',
      UPDATE: '/products/{id}',
      DELETE: '/products/{id}'
    },
    CATEGORIES: {
      LIST: '/categories',
      DETAIL: '/categories/{id}'
    },
    BRANDS: {
      LIST: '/brands',
      DETAIL: '/brands/{id}'
    },
    INVENTORY: {
      LIST: '/inventory',
      MOVEMENTS: '/inventory/movements',
      MULTI_ITEM: '/inventory/multi-item'
    },
    SALES: {
      LIST: '/sales',
      CREATE: '/sales',
      POS: '/sales/pos'
    },
    BUSINESSES: {
      LIST: '/businesses',
      DETAIL: '/businesses/{id}'
    }
  }
};

// Función para construir URLs completas
export const getApiUrl = (endpoint: string, params?: Record<string, string | number>): string => {
  let url = `${API_CONFIG.BASE_URL}${API_CONFIG.API_VERSION}${endpoint}`;
  
  // Reemplazar parámetros en la URL
  if (params) {
    for (const key in params) {
      if (params.hasOwnProperty(key)) {
        url = url.replace(`{${key}}`, String(params[key]));
      }
    }
  }
  
  return url;
};

// Función para construir headers con autenticación
export const getAuthHeaders = async (): Promise<Record<string, string>> => {
  const AsyncStorage = require('@react-native-async-storage/async-storage').default;
  const token = await AsyncStorage.getItem('token');
  
  return {
    'Content-Type': 'application/json',
    ...(token && { 'Authorization': `Bearer ${token}` })
  };
};

// Función helper para login automático
export const autoLogin = async (): Promise<boolean> => {
  try {
    const response = await fetch(getApiUrl(API_CONFIG.ENDPOINTS.AUTH.LOGIN), {
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
      const AsyncStorage = require('@react-native-async-storage/async-storage').default;
      await AsyncStorage.setItem('token', data.access_token);
      return true;
    }
    return false;
  } catch (error) {
    console.error('Auto login failed:', error);
    return false;
  }
};

// Función helper para hacer peticiones autenticadas
export const authenticatedFetch = async (
  endpoint: string, 
  options: RequestInit = {},
  params?: Record<string, string | number>
): Promise<Response> => {
  const headers = await getAuthHeaders();
  const url = getApiUrl(endpoint, params);
  
  const response = await fetch(url, {
    ...options,
    headers: {
      ...headers,
      ...options.headers
    }
  });

  // Si no está autenticado, intentar login automático y reintentar
  if (response.status === 401) {
    const loginSuccess = await autoLogin();
    if (loginSuccess) {
      const newHeaders = await getAuthHeaders();
      return fetch(url, {
        ...options,
        headers: {
          ...newHeaders,
          ...options.headers
        }
      });
    }
  }

  return response;
};

// Funciones específicas para productos
export const ProductAPI = {
  getAll: async (limit = 100, activeOnly = false): Promise<any[]> => {
    const queryParams = new URLSearchParams();
    queryParams.append('limit', String(limit));
    if (activeOnly) queryParams.append('active_only', 'true');
    
    const response = await authenticatedFetch(`${API_CONFIG.ENDPOINTS.PRODUCTS.LIST}?${queryParams}`);
    
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${await response.text()}`);
    }
    
    return response.json();
  },

  getById: async (id: number): Promise<any> => {
    const response = await authenticatedFetch(API_CONFIG.ENDPOINTS.PRODUCTS.DETAIL, {}, { id });
    
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${await response.text()}`);
    }
    
    return response.json();
  },

  create: async (productData: any): Promise<any> => {
    const response = await authenticatedFetch(API_CONFIG.ENDPOINTS.PRODUCTS.CREATE, {
      method: 'POST',
      body: JSON.stringify(productData)
    });
    
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${await response.text()}`);
    }
    
    return response.json();
  }
};

// Funciones específicas para inventario
export const InventoryAPI = {
  getMovements: async (): Promise<any[]> => {
    const response = await authenticatedFetch(API_CONFIG.ENDPOINTS.INVENTORY.MOVEMENTS);
    
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${await response.text()}`);
    }
    
    return response.json();
  },

  createMultiItemMovement: async (movementData: any): Promise<any> => {
    const response = await authenticatedFetch(API_CONFIG.ENDPOINTS.INVENTORY.MULTI_ITEM, {
      method: 'POST',
      body: JSON.stringify(movementData)
    });
    
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${await response.text()}`);
    }
    
    return response.json();
  }
};

// Funciones específicas para ventas
export const SalesAPI = {
  createSale: async (saleData: any): Promise<any> => {
    const response = await authenticatedFetch(API_CONFIG.ENDPOINTS.SALES.CREATE, {
      method: 'POST',
      body: JSON.stringify(saleData)
    });
    
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${await response.text()}`);
    }
    
    return response.json();
  }
};
