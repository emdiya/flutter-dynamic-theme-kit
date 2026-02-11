import 'dart:io';

import 'package:dynamic_theme_kit_app/app/core/config/default_theme.dart';
import 'package:dynamic_theme_kit_app/app/core/utils/app_logger.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/data/sources/theme_pack_local_source.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/theme_runtime/theme_runtime.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/theme_pack_controller.dart';

class ThemedBackground extends StatelessWidget {
  const ThemedBackground({
    super.key,
    required this.assetKey,
    required this.child,
    this.fallbackColor = const Color(0xFFFFFFFF),
  });

  final String assetKey;
  final Widget child;
  final Color fallbackColor;

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ThemePackController>();
    return Obx(() {
      final packId = ctrl.activePack.value?.id;
      final rel = ThemeRuntime.instance.assetRel(assetKey);

      if (packId != null && rel != null) {
        return FutureBuilder<String>(
          future: Get.find<ThemePackLocalSource>().resolvePath(packId, rel),
          builder: (_, snap) {
            final path = snap.data;
            final file = path == null ? null : File(path);
            final exists = file?.existsSync() ?? false;
            if (path != null) {
              AppLogger.info(
                'Background resolve: key=$assetKey pack=$packId path=$path exists=$exists',
              );
            }

            final image = exists
                ? DecorationImage(image: FileImage(file!), fit: BoxFit.cover)
                : _defaultFallbackImage();

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: Container(
                key: ValueKey<String>('${packId}_${path ?? 'fallback'}'),
                decoration: BoxDecoration(color: fallbackColor, image: image),
                child: child,
              ),
            );
          },
        );
      }

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: Container(
          key: const ValueKey<String>('default_background'),
          decoration: BoxDecoration(
            color: fallbackColor,
            image: _defaultFallbackImage(),
          ),
          child: child,
        ),
      );
    });
  }

  DecorationImage? _defaultFallbackImage() {
    final asset = DefaultTheme.backgrounds[assetKey];
    if (asset == null) {
      return null;
    }
    return DecorationImage(image: AssetImage(asset), fit: BoxFit.cover);
  }
}
