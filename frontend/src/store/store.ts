import { configureStore } from '@reduxjs/toolkit';
import authReducer from './slices/authSlice';
import businessReducer from './slices/businessSlice';
import productReducer from './slices/productSlice';
import inventoryReducer from './slices/inventorySlice';
import salesReducer from './slices/salesSlice';
import settingsReducer from './slices/settingsSlice';
import suppliersReducer from './slices/suppliersSlice';
import purchaseOrdersReducer from './slices/purchaseOrdersSlice';
import catalogsReducer from './slices/catalogsSlice';

export const store = configureStore({
  reducer: {
    auth: authReducer,
    business: businessReducer,
    products: productReducer,
    inventory: inventoryReducer,
    sales: salesReducer,
    settings: settingsReducer,
    suppliers: suppliersReducer,
    purchaseOrders: purchaseOrdersReducer,
    catalogs: catalogsReducer,
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
