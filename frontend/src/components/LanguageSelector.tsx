import React from 'react';
import { View, StyleSheet } from 'react-native';
import { List, RadioButton, Text } from 'react-native-paper';
import { useDispatch, useSelector } from 'react-redux';
import { useTranslation } from 'react-i18next';
import { RootState, AppDispatch } from '../store/store';
import { changeLanguage } from '../store/slices/settingsSlice';
import { colors, spacing } from '../styles/theme';

interface LanguageSelectorProps {
  onClose?: () => void;
}

export default function LanguageSelector({ onClose }: LanguageSelectorProps) {
  const { t } = useTranslation();
  const dispatch = useDispatch<AppDispatch>();
  const currentLanguage = useSelector((state: RootState) => state.settings.language);

  const languages = [
    { code: 'en', name: t('languages.en'), flag: '🇺🇸' },
    { code: 'es', name: t('languages.es'), flag: '🇪🇸' },
  ];

  const handleLanguageChange = async (languageCode: string) => {
    try {
      await dispatch(changeLanguage(languageCode)).unwrap();
      if (onClose) onClose();
    } catch (error) {
      console.error('Error changing language:', error);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>{t('settings.selectLanguage')}</Text>
      
      <RadioButton.Group
        onValueChange={handleLanguageChange}
        value={currentLanguage}
      >
        {languages.map((language) => (
          <List.Item
            key={language.code}
            title={`${language.flag} ${language.name}`}
            onPress={() => handleLanguageChange(language.code)}
            left={() => (
              <RadioButton
                value={language.code}
                status={currentLanguage === language.code ? 'checked' : 'unchecked'}
              />
            )}
            style={styles.languageItem}
          />
        ))}
      </RadioButton.Group>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    padding: spacing.lg,
    backgroundColor: colors.white,
    borderRadius: 8,
    margin: spacing.md,
  },
  title: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: spacing.lg,
    color: colors.text,
    textAlign: 'center',
  },
  languageItem: {
    paddingVertical: spacing.sm,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
  },
});
