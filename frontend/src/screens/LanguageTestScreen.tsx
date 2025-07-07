import React from 'react';
import { ScrollView, StyleSheet } from 'react-native';
import LanguageDemo from '../components/LanguageDemo';
import { colors } from '../styles/theme';

export default function LanguageTestScreen() {
  return (
    <ScrollView style={styles.container}>
      <LanguageDemo />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
});
