import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { apiService } from '../../services/apiService';

interface Business {
  id: number;
  name: string;
  rfc: string;
  address?: string;
  phone?: string;
  email?: string;
  is_active: boolean;
}

interface Warehouse {
  id: number;
  business_id: number;
  name: string;
  location?: string;
  is_active: boolean;
}

interface BusinessState {
  businesses: Business[];
  warehouses: Warehouse[];
  selectedBusiness: Business | null;
  selectedWarehouse: Warehouse | null;
  loading: boolean;
  error: string | null;
}

const initialState: BusinessState = {
  businesses: [],
  warehouses: [],
  selectedBusiness: null,
  selectedWarehouse: null,
  loading: false,
  error: null,
};

// Async thunks
export const fetchBusinesses = createAsyncThunk(
  'business/fetchBusinesses',
  async () => {
    return await apiService.getBusinesses();
  }
);

export const fetchWarehouses = createAsyncThunk(
  'business/fetchWarehouses',
  async (businessId?: number) => {
    return await apiService.getWarehouses(businessId);
  }
);

export const createBusiness = createAsyncThunk(
  'business/createBusiness',
  async (businessData: any) => {
    return await apiService.createBusiness(businessData);
  }
);

const businessSlice = createSlice({
  name: 'business',
  initialState,
  reducers: {
    selectBusiness: (state, action) => {
      state.selectedBusiness = action.payload;
    },
    selectWarehouse: (state, action) => {
      state.selectedWarehouse = action.payload;
    },
    clearError: (state) => {
      state.error = null;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchBusinesses.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchBusinesses.fulfilled, (state, action) => {
        state.loading = false;
        state.businesses = action.payload;
      })
      .addCase(fetchBusinesses.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to fetch businesses';
      })
      .addCase(fetchWarehouses.fulfilled, (state, action) => {
        state.warehouses = action.payload;
      })
      .addCase(createBusiness.fulfilled, (state, action) => {
        state.businesses.push(action.payload);
      });
  },
});

export const { selectBusiness, selectWarehouse, clearError } = businessSlice.actions;
export default businessSlice.reducer;
