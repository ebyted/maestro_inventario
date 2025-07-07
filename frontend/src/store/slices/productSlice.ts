import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { apiService } from '../../services/apiService';

interface Product {
  id: number;
  business_id: number;
  name: string;
  description?: string;
  sku?: string;
  barcode?: string;
  category?: string;
  brand?: string;
  base_unit_id: number;
  image_url?: string;
  is_active: boolean;
}

interface ProductVariant {
  id: number;
  product_id: number;
  unit_id: number;
  attributes?: any;
  sku?: string;
  barcode?: string;
  price?: number;
  cost?: number;
  is_active: boolean;
}

interface ProductState {
  products: Product[];
  variants: ProductVariant[];
  selectedProduct: Product | null;
  loading: boolean;
  error: string | null;
}

const initialState: ProductState = {
  products: [],
  variants: [],
  selectedProduct: null,
  loading: false,
  error: null,
};

// Async thunks
export const fetchProducts = createAsyncThunk(
  'products/fetchProducts',
  async (businessId?: number) => {
    return await apiService.getProducts(businessId);
  }
);

export const createProduct = createAsyncThunk(
  'products/createProduct',
  async (productData: any) => {
    return await apiService.createProduct(productData);
  }
);

export const fetchProductVariants = createAsyncThunk(
  'products/fetchProductVariants',
  async (productId: number) => {
    return await apiService.getProductVariants(productId);
  }
);

const productSlice = createSlice({
  name: 'products',
  initialState,
  reducers: {
    selectProduct: (state, action) => {
      state.selectedProduct = action.payload;
    },
    clearError: (state) => {
      state.error = null;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchProducts.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchProducts.fulfilled, (state, action) => {
        state.loading = false;
        state.products = action.payload;
      })
      .addCase(fetchProducts.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to fetch products';
      })
      .addCase(createProduct.fulfilled, (state, action) => {
        state.products.push(action.payload);
      })
      .addCase(fetchProductVariants.fulfilled, (state, action) => {
        state.variants = action.payload;
      });
  },
});

export const { selectProduct, clearError } = productSlice.actions;
export default productSlice.reducer;
