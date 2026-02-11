import 'package:dynamic_theme_kit_app/app/core/config/default_theme.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/domain/entities/theme_pack.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/presentation/widgets/home_demo_widgets.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/presentation/widgets/themed_background.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/presentation/widgets/theme_loading_splash.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/theme_runtime/theme_runtime.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/theme_pack_controller.dart';

class HomeDemoPage extends StatefulWidget {
  const HomeDemoPage({super.key});

  @override
  State<HomeDemoPage> createState() => _HomeDemoPageState();
}

class _HomeDemoPageState extends State<HomeDemoPage> {
  void _showThemePackBottomSheet({
    required BuildContext context,
    required ThemePackController controller,
    required String activePackId,
    required ThemePack pack,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ThemePackBottomSheet(
        name: pack.name,
        version: pack.version,
        id: pack.id,
        preview: pack.preview,
        active: activePackId == pack.id,
        onSelect: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selected theme: ${pack.name}')),
          );
        },
        onActivate: () async {
          await controller.setActive(pack.id);
          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Active theme: ${pack.name}')));
        },
      ),
    );
  }

  void _showThemePacksListBottomSheet({
    required BuildContext context,
    required ThemePackController controller,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Obx(() {
        final activeId = controller.activePack.value?.id;

        if (controller.isLoading.value) {
          return const SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (controller.availablePacks.isEmpty) {
          return const SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No theme packs found from API')),
            ),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Theme Packs',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Choose a theme pack to preview details, then activate it from the next sheet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 250,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.availablePacks.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        final isDefaultActive = activeId == null;
                        return SizedBox(
                          width: 210,
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () async {
                                await controller.setDefaultTheme();
                                if (!context.mounted) return;
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Active theme: Default'),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isDefaultActive
                                        ? const Color(0xFF1E40AF)
                                        : const Color(0xFFD7DFEE),
                                    width: 1.6,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 130,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            gradient: const LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xFFE6EEFF),
                                                Color(0xFFF7FAFF),
                                                Color(0xFFFFFFFF),
                                              ],
                                            ),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.palette_outlined,
                                              size: 38,
                                              color: Color(0xFF1E40AF),
                                            ),
                                          ),
                                        ),
                                        if (isDefaultActive)
                                          const Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Chip(
                                              label: Text('Active'),
                                              backgroundColor: Color(
                                                0xFFDCE8FF,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Default Theme',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Bundled fallback assets',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      final pack = controller.availablePacks[index - 1];
                      final isActive = activeId == pack.id;

                      return SizedBox(
                        width: 210,
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              _showThemePackBottomSheet(
                                context: context,
                                controller: controller,
                                activePackId: activeId ?? '',
                                pack: pack,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isActive
                                      ? const Color(0xFF1E40AF)
                                      : const Color(0xFFD7DFEE),
                                  width: 1.6,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Stack(
                                    children: [
                                      ThemePreviewImage(
                                        preview: pack.preview,
                                        width: double.infinity,
                                        height: 130,
                                      ),
                                      if (isActive)
                                        const Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Chip(
                                            label: Text('Active'),
                                            backgroundColor: Color(0xFFDCE8FF),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    pack.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'v${pack.version} • ${pack.id}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ThemePackController>();
    return Scaffold(
      body: ThemedBackground(
        assetKey: 'homeBackground',
        fallbackColor: const Color(0xFFF5F8FF),
        child: Stack(
          children: [
            Obx(() {
              final hasActivePack = ctrl.activePack.value != null;
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 220),
                opacity: hasActivePack ? 0 : 1,
                child: const KhmerBankingAtmosphere(),
              );
            }),
            Obx(() {
              if (!ctrl.isThemeApplying.value) {
                return const SizedBox.shrink();
              }
              return const ThemeLoadingSplash();
            }),
            SafeArea(
              child: Obx(() {
                final activeId = ctrl.activePack.value?.id;
                final primary = ThemeRuntime.instance.color(
                  'primary',
                  fallback:
                      DefaultTheme.colors['primary'] ?? const Color(0xFF1E40AF),
                );
                final textPrimary = ThemeRuntime.instance.color(
                  'textPrimary',
                  fallback:
                      DefaultTheme.colors['textPrimary'] ??
                      const Color(0xFF111827),
                );

                return RefreshIndicator(
                  onRefresh: ctrl.loadAvailablePacks,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    children: [
                      DemoHeader(
                        textPrimary: textPrimary,
                        activePackId: activeId,
                      ),
                      const SizedBox(height: 16),
                      BalanceCardWidget(primary: primary),
                      const SizedBox(height: 16),
                      QuickActionsWidget(primary: primary),
                      const SizedBox(height: 14),
                      ServiceStrip(primary: primary, textPrimary: textPrimary),
                      const SizedBox(height: 14),
                      InsightPanel(primary: primary),
                      const SizedBox(height: 14),
                      RecentTransactions(
                        primary: primary,
                        textPrimary: textPrimary,
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: ctrl.isLoading.value
                              ? null
                              : () async {
                                  await ctrl.loadAvailablePacks();
                                  if (!context.mounted) return;
                                  _showThemePacksListBottomSheet(
                                    context: context,
                                    controller: ctrl,
                                  );
                                },
                          icon: const Icon(Icons.palette_outlined),
                          label: const Text('Theme Packs'),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
