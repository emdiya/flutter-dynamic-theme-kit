import 'package:dynamic_theme_kit_app/features/theme_packs/domain/entities/theme_pack.dart';

class ThemePackModel {
  ThemePackModel({
    required this.id,
    required this.name,
    required this.version,
    required this.colors,
    required this.icons,
    required this.assets,
  });

  final String id;
  final String name;
  final int version;
  final Map<String, String> colors;
  final Map<String, String> icons;
  final Map<String, String> assets;

  factory ThemePackModel.fromJson(
    Map<String, dynamic> json, {
    required String packId,
  }) {
    return ThemePackModel(
      id: packId,
      name: (json['name'] ?? packId).toString(),
      version: (json['version'] ?? 1) as int,
      colors: Map<String, String>.from(json['colors'] ?? {}),
      icons: Map<String, String>.from(json['icons'] ?? {}),
      assets: Map<String, String>.from(json['assets'] ?? {}),
    );
  }

  factory ThemePackModel.fromEntity(ThemePack entity) {
    return ThemePackModel(
      id: entity.id,
      name: entity.name,
      version: entity.version,
      colors: entity.colors,
      icons: entity.icons,
      assets: entity.assets,
    );
  }
}
