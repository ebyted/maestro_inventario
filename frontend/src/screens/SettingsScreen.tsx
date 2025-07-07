import React, { useState } from 'react';
import { View, StyleSheet, ScrollView } from 'react-native';
import { Title, List, Switch, Portal, Modal, Button } from 'react-native-paper';
import { useDispatch, useSelector } from 'react-redux';
import { useTranslation } from 'react-i18next';
import { RootState, AppDispatch } from '../store/store';
import { toggleNotifications } from '../store/slices/settingsSlice';
import LanguageSelector from '../components/LanguageSelector';
import { colors, spacing } from '../styles/theme';

export default function SettingsScreen() {
  const { t } = useTranslation();
  const dispatch = useDispatch<AppDispatch>();
  const { language, notifications } = useSelector((state: RootState) => state.settings);
  const [showLanguageModal, setShowLanguageModal] = useState(false);

  const handleToggleNotifications = () => {
    dispatch(toggleNotifications(!notifications));
  };

  const getLanguageName = (code: string) => {
    switch (code) {
      case 'es':
        return t('languages.es');
      case 'en':
      default:
        return t('languages.en');
    }
  };

  return (
    <ScrollView style={styles.container}>
      <Title style={styles.title}>{t('settings.title')}</Title>
      
      <View style={styles.section}>
        <List.Item
          title={t('settings.language')}
          description={getLanguageName(language)}
          left={(props) => <List.Icon {...props} icon="translate" />}
          right={(props) => <List.Icon {...props} icon="chevron-right" />}
          onPress={() => setShowLanguageModal(true)}
          style={styles.listItem}
        />
        
        <List.Item
          title={t('settings.notifications')}
          description={notifications ? t('common.yes') : t('common.no')}
          left={(props) => <List.Icon {...props} icon="bell" />}
          right={() => (
            <Switch
              value={notifications}
              onValueChange={handleToggleNotifications}
            />
          )}
          style={styles.listItem}
        />
        
        <List.Item
          title={t('settings.about')}
          description={t('app.name')}
          left={(props) => <List.Icon {...props} icon="information" />}
          right={(props) => <List.Icon {...props} icon="chevron-right" />}
          onPress={() => {}}
          style={styles.listItem}
        />
      </View>

      <Portal>
        <Modal
          visible={showLanguageModal}
          onDismiss={() => setShowLanguageModal(false)}
          contentContainerStyle={styles.modalContent}
        >
          <LanguageSelector onClose={() => setShowLanguageModal(false)} />
          <Button
            mode="outlined"
            onPress={() => setShowLanguageModal(false)}
            style={styles.closeButton}
          >
            {t('common.cancel')}
          </Button>
        </Modal>
      </Portal>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    padding: spacing.lg,
    color: colors.text,
  },
  section: {
    backgroundColor: colors.white,
    marginHorizontal: spacing.md,
    borderRadius: 8,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  listItem: {
    paddingVertical: spacing.sm,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
  },
  modalContent: {
    backgroundColor: colors.white,
    margin: spacing.xl,
    borderRadius: 8,
  },
  closeButton: {
    margin: spacing.md,
  },
});
