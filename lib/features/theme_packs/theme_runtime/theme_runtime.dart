import 'package:dynamic_theme_kit_app/app/core/config/default_theme.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/data/models/theme_pack_model.dart';
import 'package:flutter/material.dart';

class ThemeRuntime {
  ThemeRuntime._();
  static final instance = ThemeRuntime._();

  ThemePackModel? _pack;
  void setPack(ThemePackModel? pack) => _pack = pack;

  Color color(String key, {required Color fallback}) {
    final hex = _pack?.colors[key];
    if (hex == null) return DefaultTheme.colors[key] ?? fallback;
    return _hexToColor(hex, fallback: fallback);
  }

  String? iconRel(String key) => _pack?.icons[key];
  String? assetRel(String key) => _pack?.assets[key];

  Color _hexToColor(String hex, {required Color fallback}) {
    try {
      final clean = hex.replaceAll('#', '');
      final value = int.parse(
        clean.length == 6 ? 'FF$clean' : clean,
        radix: 16,
      );
      return Color(value);
    } catch (_) {
      return fallback;
    }
  }
}
