import 'dart:io';

import 'package:dynamic_theme_kit_app/app/core/config/default_theme.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/data/sources/theme_pack_local_source.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/theme_runtime/theme_runtime.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/theme_pack_controller.dart';

class ThemedIcon extends StatelessWidget {
  const ThemedIcon(
    this.keyName, {
    super.key,
    this.size = 24,
    this.fallbackAsset,
  });

  final String keyName;
  final double size;
  final String? fallbackAsset;

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ThemePackController>();
    return Obx(() {
      final packId = ctrl.activePack.value?.id;
      final rel = ThemeRuntime.instance.iconRel(keyName);

      if (packId != null && rel != null) {
        return FutureBuilder<String>(
          future: Get.find<ThemePackLocalSource>().resolvePath(packId, rel),
          builder: (_, snap) {
            if (!snap.hasData) return SizedBox(width: size, height: size);
            final file = File(snap.data!);
            if (!file.existsSync()) return _fallback();
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: Image.file(
                file,
                key: ValueKey<String>(file.path),
                width: size,
                height: size,
                gaplessPlayback: true,
              ),
            );
          },
        );
      }
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: SizedBox(
          key: const ValueKey<String>('icon_fallback'),
          width: size,
          height: size,
          child: _fallback(),
        ),
      );
    });
  }

  Widget _fallback() {
    final asset = fallbackAsset ?? DefaultTheme.icons[keyName];
    if (asset != null) {
      return Image.asset(asset, width: size, height: size);
    }
    return SizedBox(width: size, height: size);
  }
}
