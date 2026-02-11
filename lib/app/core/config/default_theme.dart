import 'package:flutter/material.dart';

class DefaultTheme {
  static const Map<String, Color> colors = {
    'primary': Color(0xFF1E40AF),
    'background': Color(0xFFFFFFFF),
    'textPrimary': Color(0xFF111827),
  };

  static const Map<String, String> icons = {
    'home': 'assets/default_theme/icons/home.png',
    'transfer': 'assets/default_theme/icons/transfer.png',
    'scan': 'assets/default_theme/icons/scan.png',
  };

  static const Map<String, String> backgrounds = {
    'homeBackground': 'assets/default_theme/backgrounds/background.png',
    'loginBackground': 'assets/default_theme/backgrounds/preview.png',
  };
}
