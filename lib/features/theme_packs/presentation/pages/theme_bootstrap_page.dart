import 'package:dynamic_theme_kit_app/features/theme_packs/presentation/pages/home_demo_page.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/presentation/widgets/theme_loading_splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/theme_pack_controller.dart';

class ThemeBootstrapPage extends StatelessWidget {
  const ThemeBootstrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ThemePackController>();

    return Obx(() {
      if (!ctrl.isThemeApplying.value) {
        return const HomeDemoPage();
      }

      return const Scaffold(body: Stack(children: [ThemeLoadingSplash()]));
    });
  }
}
