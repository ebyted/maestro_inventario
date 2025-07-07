import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { apiService } from '../../services/apiService';

interface SaleItem {
  id: number;
  sale_id: number;
  product_variant_id: number;
  unit_id: number;
  quantity: number;
  unit_price: number;
  total_price: number;
}

interface Sale {
  id: number;
  warehouse_id: number;
  user_id: number;
  sale_number: string;
  date: string;
  payment_method: string;
  subtotal: number;
  tax: number;
  discount: number;
  total: number;
  customer_name?: string;
  customer_email?: string;
  notes?: string;
  items: SaleItem[];
}

interface SalesState {
  sales: Sale[];
  currentSale: Sale | null;
  loading: boolean;
  error: string | null;
}

const initialState: SalesState = {
  sales: [],
  currentSale: null,
  loading: false,
  error: null,
};

// Async thunks
export const fetchSales = createAsyncThunk(
  'sales/fetchSales',
  async (warehouseId?: number) => {
    return await apiService.getSales(warehouseId);
  }
);

export const createSale = createAsyncThunk(
  'sales/createSale',
  async (saleData: any) => {
    return await apiService.createSale(saleData);
  }
);

const salesSlice = createSlice({
  name: 'sales',
  initialState,
  reducers: {
    setCurrentSale: (state, action) => {
      state.currentSale = action.payload;
    },
    clearCurrentSale: (state) => {
      state.currentSale = null;
    },
    clearError: (state) => {
      state.error = null;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchSales.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchSales.fulfilled, (state, action) => {
        state.loading = false;
        state.sales = action.payload;
      })
      .addCase(fetchSales.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to fetch sales';
      })
      .addCase(createSale.fulfilled, (state, action) => {
        state.sales.unshift(action.payload);
        state.currentSale = null;
      });
  },
});

export const { setCurrentSale, clearCurrentSale, clearError } = salesSlice.actions;
export default salesSlice.reducer;
