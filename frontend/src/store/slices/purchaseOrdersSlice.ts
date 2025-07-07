import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit';
import { apiService } from '../../services/apiService';
import { PurchaseOrder, PurchaseOrderCreate, PurchaseOrderReceipt, PurchaseOrderReceiptCreate, PurchaseOrderStatus } from '../../types';

interface PurchaseOrdersState {
  purchaseOrders: PurchaseOrder[];
  currentPurchaseOrder: PurchaseOrder | null;
  receipts: PurchaseOrderReceipt[];
  loading: boolean;
  error: string | null;
  filters: {
    status?: PurchaseOrderStatus;
    supplier_id?: number;
    search?: string;
  };
}

const initialState: PurchaseOrdersState = {
  purchaseOrders: [],
  currentPurchaseOrder: null,
  receipts: [],
  loading: false,
  error: null,
  filters: {},
};

// Async thunks
export const fetchPurchaseOrders = createAsyncThunk(
  'purchaseOrders/fetchPurchaseOrders',
  async ({ businessId, params }: { businessId: number; params?: any }) => {
    const response = await apiService.getPurchaseOrders(businessId, params);
    return response;
  }
);

export const fetchPurchaseOrder = createAsyncThunk(
  'purchaseOrders/fetchPurchaseOrder',
  async (purchaseOrderId: number) => {
    const response = await apiService.getPurchaseOrder(purchaseOrderId);
    return response;
  }
);

export const createPurchaseOrder = createAsyncThunk(
  'purchaseOrders/createPurchaseOrder',
  async ({ purchaseOrder, businessId }: { purchaseOrder: PurchaseOrderCreate; businessId: number }) => {
    const response = await apiService.createPurchaseOrder(purchaseOrder, businessId);
    return response;
  }
);

export const updatePurchaseOrder = createAsyncThunk(
  'purchaseOrders/updatePurchaseOrder',
  async ({ purchaseOrderId, purchaseOrder }: { purchaseOrderId: number; purchaseOrder: Partial<PurchaseOrderCreate> }) => {
    const response = await apiService.updatePurchaseOrder(purchaseOrderId, purchaseOrder);
    return response;
  }
);

export const updatePurchaseOrderStatus = createAsyncThunk(
  'purchaseOrders/updatePurchaseOrderStatus',
  async ({ purchaseOrderId, status }: { purchaseOrderId: number; status: PurchaseOrderStatus }) => {
    const response = await apiService.updatePurchaseOrderStatus(purchaseOrderId, status);
    return { purchaseOrderId, status };
  }
);

export const createPurchaseReceipt = createAsyncThunk(
  'purchaseOrders/createPurchaseReceipt',
  async ({ purchaseOrderId, receipt }: { purchaseOrderId: number; receipt: PurchaseOrderReceiptCreate }) => {
    const response = await apiService.createPurchaseReceipt(purchaseOrderId, receipt);
    return response;
  }
);

export const fetchPurchaseReceipts = createAsyncThunk(
  'purchaseOrders/fetchPurchaseReceipts',
  async (purchaseOrderId: number) => {
    const response = await apiService.getPurchaseReceipts(purchaseOrderId);
    return response;
  }
);

export const cancelPurchaseOrder = createAsyncThunk(
  'purchaseOrders/cancelPurchaseOrder',
  async (purchaseOrderId: number) => {
    await apiService.cancelPurchaseOrder(purchaseOrderId);
    return purchaseOrderId;
  }
);

const purchaseOrdersSlice = createSlice({
  name: 'purchaseOrders',
  initialState,
  reducers: {
    clearCurrentPurchaseOrder: (state) => {
      state.currentPurchaseOrder = null;
    },
    clearError: (state) => {
      state.error = null;
    },
    setFilters: (state, action: PayloadAction<Partial<PurchaseOrdersState['filters']>>) => {
      state.filters = { ...state.filters, ...action.payload };
    },
    clearFilters: (state) => {
      state.filters = {};
    },
  },
  extraReducers: (builder) => {
    builder
      // Fetch purchase orders
      .addCase(fetchPurchaseOrders.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchPurchaseOrders.fulfilled, (state, action) => {
        state.loading = false;
        state.purchaseOrders = action.payload;
      })
      .addCase(fetchPurchaseOrders.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to fetch purchase orders';
      })
      // Fetch purchase order
      .addCase(fetchPurchaseOrder.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchPurchaseOrder.fulfilled, (state, action) => {
        state.loading = false;
        state.currentPurchaseOrder = action.payload;
      })
      .addCase(fetchPurchaseOrder.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to fetch purchase order';
      })
      // Create purchase order
      .addCase(createPurchaseOrder.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(createPurchaseOrder.fulfilled, (state, action) => {
        state.loading = false;
        state.purchaseOrders.unshift(action.payload);
      })
      .addCase(createPurchaseOrder.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to create purchase order';
      })
      // Update purchase order
      .addCase(updatePurchaseOrder.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(updatePurchaseOrder.fulfilled, (state, action) => {
        state.loading = false;
        const index = state.purchaseOrders.findIndex(po => po.id === action.payload.id);
        if (index !== -1) {
          state.purchaseOrders[index] = action.payload;
        }
        if (state.currentPurchaseOrder?.id === action.payload.id) {
          state.currentPurchaseOrder = action.payload;
        }
      })
      .addCase(updatePurchaseOrder.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to update purchase order';
      })
      // Update purchase order status
      .addCase(updatePurchaseOrderStatus.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(updatePurchaseOrderStatus.fulfilled, (state, action) => {
        state.loading = false;
        const index = state.purchaseOrders.findIndex(po => po.id === action.payload.purchaseOrderId);
        if (index !== -1) {
          state.purchaseOrders[index].status = action.payload.status;
        }
        if (state.currentPurchaseOrder?.id === action.payload.purchaseOrderId) {
          state.currentPurchaseOrder.status = action.payload.status;
        }
      })
      .addCase(updatePurchaseOrderStatus.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to update purchase order status';
      })
      // Create purchase receipt
      .addCase(createPurchaseReceipt.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(createPurchaseReceipt.fulfilled, (state, action) => {
        state.loading = false;
        state.receipts.unshift(action.payload);
      })
      .addCase(createPurchaseReceipt.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to create purchase receipt';
      })
      // Fetch purchase receipts
      .addCase(fetchPurchaseReceipts.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchPurchaseReceipts.fulfilled, (state, action) => {
        state.loading = false;
        state.receipts = action.payload;
      })
      .addCase(fetchPurchaseReceipts.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to fetch purchase receipts';
      })
      // Cancel purchase order
      .addCase(cancelPurchaseOrder.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(cancelPurchaseOrder.fulfilled, (state, action) => {
        state.loading = false;
        const index = state.purchaseOrders.findIndex(po => po.id === action.payload);
        if (index !== -1) {
          state.purchaseOrders[index].status = PurchaseOrderStatus.CANCELLED;
        }
        if (state.currentPurchaseOrder?.id === action.payload) {
          state.currentPurchaseOrder.status = PurchaseOrderStatus.CANCELLED;
        }
      })
      .addCase(cancelPurchaseOrder.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to cancel purchase order';
      });
  },
});

export const { clearCurrentPurchaseOrder, clearError, setFilters, clearFilters } = purchaseOrdersSlice.actions;
export default purchaseOrdersSlice.reducer;
