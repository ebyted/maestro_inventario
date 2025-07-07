import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { apiService } from '../../services/apiService';
import { Category, CategoryCreate, Brand, BrandCreate, Unit, UnitCreate } from '../../types';

interface CatalogsState {
  categories: Category[];
  brands: Brand[];
  units: Unit[];
  currentCategory: Category | null;
  currentBrand: Brand | null;
  currentUnit: Unit | null;
  loading: boolean;
  error: string | null;
}

const initialState: CatalogsState = {
  categories: [],
  brands: [],
  units: [],
  currentCategory: null,
  currentBrand: null,
  currentUnit: null,
  loading: false,
  error: null,
};

// Categories async thunks
export const fetchCategories = createAsyncThunk(
  'catalogs/fetchCategories',
  async (businessId?: number) => {
    const response = await apiService.getCategories(businessId);
    return response;
  }
);

export const createCategory = createAsyncThunk(
  'catalogs/createCategory',
  async ({ category, businessId }: { category: CategoryCreate; businessId: number }) => {
    const response = await apiService.createCategory(category, businessId);
    return response;
  }
);

export const updateCategory = createAsyncThunk(
  'catalogs/updateCategory',
  async ({ categoryId, category }: { categoryId: number; category: Partial<CategoryCreate> }) => {
    const response = await apiService.updateCategory(categoryId, category);
    return response;
  }
);

export const deleteCategory = createAsyncThunk(
  'catalogs/deleteCategory',
  async (categoryId: number) => {
    await apiService.deleteCategory(categoryId);
    return categoryId;
  }
);

// Brands async thunks
export const fetchBrands = createAsyncThunk(
  'catalogs/fetchBrands',
  async (businessId?: number) => {
    const response = await apiService.getBrands(businessId);
    return response;
  }
);

export const createBrand = createAsyncThunk(
  'catalogs/createBrand',
  async ({ brand, businessId }: { brand: BrandCreate; businessId: number }) => {
    const response = await apiService.createBrand(brand, businessId);
    return response;
  }
);

export const updateBrand = createAsyncThunk(
  'catalogs/updateBrand',
  async ({ brandId, brand }: { brandId: number; brand: Partial<BrandCreate> }) => {
    const response = await apiService.updateBrand(brandId, brand);
    return response;
  }
);

export const deleteBrand = createAsyncThunk(
  'catalogs/deleteBrand',
  async (brandId: number) => {
    await apiService.deleteBrand(brandId);
    return brandId;
  }
);

// Units async thunks
export const fetchUnits = createAsyncThunk(
  'catalogs/fetchUnits',
  async (businessId?: number) => {
    const response = await apiService.getUnits(businessId);
    return response;
  }
);

export const createUnit = createAsyncThunk(
  'catalogs/createUnit',
  async ({ unit, businessId }: { unit: UnitCreate; businessId: number }) => {
    const response = await apiService.createUnit(unit, businessId);
    return response;
  }
);

export const updateUnit = createAsyncThunk(
  'catalogs/updateUnit',
  async ({ unitId, unit }: { unitId: number; unit: Partial<UnitCreate> }) => {
    const response = await apiService.updateUnit(unitId, unit);
    return response;
  }
);

export const deleteUnit = createAsyncThunk(
  'catalogs/deleteUnit',
  async (unitId: number) => {
    await apiService.deleteUnit(unitId);
    return unitId;
  }
);

const catalogsSlice = createSlice({
  name: 'catalogs',
  initialState,
  reducers: {
    clearCurrentCategory: (state) => {
      state.currentCategory = null;
    },
    clearCurrentBrand: (state) => {
      state.currentBrand = null;
    },
    clearCurrentUnit: (state) => {
      state.currentUnit = null;
    },
    clearError: (state) => {
      state.error = null;
    },
  },
  extraReducers: (builder) => {
    builder
      // Categories
      .addCase(fetchCategories.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchCategories.fulfilled, (state, action) => {
        state.loading = false;
        state.categories = action.payload;
      })
      .addCase(fetchCategories.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to fetch categories';
      })
      .addCase(createCategory.fulfilled, (state, action) => {
        state.categories.push(action.payload);
      })
      .addCase(updateCategory.fulfilled, (state, action) => {
        const index = state.categories.findIndex(c => c.id === action.payload.id);
        if (index !== -1) {
          state.categories[index] = action.payload;
        }
      })
      .addCase(deleteCategory.fulfilled, (state, action) => {
        state.categories = state.categories.filter(c => c.id !== action.payload);
      })
      // Brands
      .addCase(fetchBrands.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchBrands.fulfilled, (state, action) => {
        state.loading = false;
        state.brands = action.payload;
      })
      .addCase(fetchBrands.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to fetch brands';
      })
      .addCase(createBrand.fulfilled, (state, action) => {
        state.brands.push(action.payload);
      })
      .addCase(updateBrand.fulfilled, (state, action) => {
        const index = state.brands.findIndex(b => b.id === action.payload.id);
        if (index !== -1) {
          state.brands[index] = action.payload;
        }
      })
      .addCase(deleteBrand.fulfilled, (state, action) => {
        state.brands = state.brands.filter(b => b.id !== action.payload);
      })
      // Units
      .addCase(fetchUnits.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchUnits.fulfilled, (state, action) => {
        state.loading = false;
        state.units = action.payload;
      })
      .addCase(fetchUnits.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to fetch units';
      })
      .addCase(createUnit.fulfilled, (state, action) => {
        state.units.push(action.payload);
      })
      .addCase(updateUnit.fulfilled, (state, action) => {
        const index = state.units.findIndex(u => u.id === action.payload.id);
        if (index !== -1) {
          state.units[index] = action.payload;
        }
      })
      .addCase(deleteUnit.fulfilled, (state, action) => {
        state.units = state.units.filter(u => u.id !== action.payload);
      });
  },
});

export const { clearCurrentCategory, clearCurrentBrand, clearCurrentUnit, clearError } = catalogsSlice.actions;
export default catalogsSlice.reducer;
