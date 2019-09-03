import { NativeModules, Platform } from 'react-native';

if (Platform.OS === 'ios') {
  NativeModules.AccessibilityManager.setAccessibilityContentSizeMultipliers({
    extraSmall: 1.0,
    small: 1.0,
    medium: 1.0,
    large: 1.0,
    extraLarge: 1.0,
    extraExtraLarge: 1.0,
    extraExtraExtraLarge: 1.0,
    accessibilityMedium: 1.0,
    accessibilityLarge: 1.0,
    accessibilityExtraLarge: 1.0,
    accessibilityExtraExtraLarge: 1.0,
    accessibilityExtraExtraExtraLarge: 1.0,
  });
}
