const { getDefaultConfig } = require('expo/metro-config');

const config = getDefaultConfig(__dirname);

// Configuración específica para web
config.resolver.platforms = ['ios', 'android', 'web'];

module.exports = config;
