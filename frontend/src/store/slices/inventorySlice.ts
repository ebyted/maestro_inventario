import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { apiService } from '../../services/apiService';

interface InventoryItem {
  id: number;
  warehouse_id: number;
  product_variant_id: number;
  unit_id: number;
  quantity: number;
  minimum_stock: number;
  maximum_stock?: number;
}

interface InventoryState {
  items: InventoryItem[];
  loading: boolean;
  error: string | null;
}

const initialState: InventoryState = {
  items: [],
  loading: false,
  error: null,
};

// Async thunks
export const fetchInventory = createAsyncThunk(
  'inventory/fetchInventory',
  async (warehouseId?: number) => {
    return await apiService.getInventory(warehouseId);
  }
);

export const adjustInventory = createAsyncThunk(
  'inventory/adjustInventory',
  async (inventoryData: any) => {
    return await apiService.adjustInventory(inventoryData);
  }
);

const inventorySlice = createSlice({
  name: 'inventory',
  initialState,
  reducers: {
    clearError: (state) => {
      state.error = null;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchInventory.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchInventory.fulfilled, (state, action) => {
        state.loading = false;
        state.items = action.payload;
      })
      .addCase(fetchInventory.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to fetch inventory';
      })
      .addCase(adjustInventory.fulfilled, (state, action) => {
        const index = state.items.findIndex(item => item.id === action.payload.id);
        if (index !== -1) {
          state.items[index] = action.payload;
        } else {
          state.items.push(action.payload);
        }
      });
  },
});

export const { clearError } = inventorySlice.actions;
export default inventorySlice.reducer;
