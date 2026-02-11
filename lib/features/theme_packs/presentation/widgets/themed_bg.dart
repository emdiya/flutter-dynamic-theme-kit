import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../controller/theme_pack_controller.dart';

class ThemedBg extends StatelessWidget {
  const ThemedBg({
    super.key,
    required this.assetKey,
    required this.fallbackAsset,
    required this.child,
    this.controller,
    this.fit = BoxFit.cover,
  });

  final String assetKey;
  final String fallbackAsset;
  final Widget child;
  final ThemePackController? controller;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final resolvedController =
        controller ??
        (Get.isRegistered<ThemePackController>()
            ? Get.find<ThemePackController>()
            : null);

    final path =
        resolvedController?.backgroundPath(
          assetKey,
          fallbackAsset: fallbackAsset,
        ) ??
        fallbackAsset;

    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: _buildImageProvider(path),
          fit: fit,
          onError: (_, __) {},
        ),
      ),
      child: child,
    );
  }

  ImageProvider _buildImageProvider(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }
    if (path.startsWith('/')) {
      return FileImage(File(path));
    }
    return AssetImage(path);
  }
}
