import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import AsyncStorage from '@react-native-async-storage/async-storage';
import i18n from '../../i18n';

interface SettingsState {
  language: string;
  theme: 'light' | 'dark';
  notifications: boolean;
  loading: boolean;
}

const initialState: SettingsState = {
  language: 'en',
  theme: 'light',
  notifications: true,
  loading: false,
};

// Async thunks
export const changeLanguage = createAsyncThunk(
  'settings/changeLanguage',
  async (language: string) => {
    await AsyncStorage.setItem('user-language', language);
    await i18n.changeLanguage(language);
    return language;
  }
);

export const loadSettings = createAsyncThunk(
  'settings/loadSettings',
  async () => {
    try {
      const savedLanguage = await AsyncStorage.getItem('user-language');
      const savedTheme = await AsyncStorage.getItem('user-theme');
      const savedNotifications = await AsyncStorage.getItem('user-notifications');
      
      return {
        language: savedLanguage || 'en',
        theme: (savedTheme as 'light' | 'dark') || 'light',
        notifications: savedNotifications ? JSON.parse(savedNotifications) : true,
      };
    } catch (error) {
      return {
        language: 'en',
        theme: 'light' as const,
        notifications: true,
      };
    }
  }
);

export const changeTheme = createAsyncThunk(
  'settings/changeTheme',
  async (theme: 'light' | 'dark') => {
    await AsyncStorage.setItem('user-theme', theme);
    return theme;
  }
);

export const toggleNotifications = createAsyncThunk(
  'settings/toggleNotifications',
  async (enabled: boolean) => {
    await AsyncStorage.setItem('user-notifications', JSON.stringify(enabled));
    return enabled;
  }
);

const settingsSlice = createSlice({
  name: 'settings',
  initialState,
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(loadSettings.pending, (state) => {
        state.loading = true;
      })
      .addCase(loadSettings.fulfilled, (state, action) => {
        state.loading = false;
        state.language = action.payload.language;
        state.theme = action.payload.theme;
        state.notifications = action.payload.notifications;
      })
      .addCase(loadSettings.rejected, (state) => {
        state.loading = false;
      })
      .addCase(changeLanguage.fulfilled, (state, action) => {
        state.language = action.payload;
      })
      .addCase(changeTheme.fulfilled, (state, action) => {
        state.theme = action.payload;
      })
      .addCase(toggleNotifications.fulfilled, (state, action) => {
        state.notifications = action.payload;
      });
  },
});

export default settingsSlice.reducer;
