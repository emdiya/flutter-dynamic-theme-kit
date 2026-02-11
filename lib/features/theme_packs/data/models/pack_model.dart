import 'package:dynamic_theme_kit_app/features/theme_packs/domain/entities/theme_pack.dart';

class PackModel {
  const PackModel({
    required this.id,
    required this.name,
    required this.version,
    this.preview,
    this.colors = const <String, String>{},
    this.assets = const <String, String>{},
    this.icons = const <String, String>{},
  });

  final String id;
  final String name;
  final int version;
  final String? preview;
  final Map<String, String> colors;
  final Map<String, String> assets;
  final Map<String, String> icons;

  factory PackModel.fromJson(Map<String, dynamic> json) {
    return PackModel(
      id: json['id'] as String,
      name: json['name'] as String,
      version: (json['version'] as num?)?.toInt() ?? 1,
      preview: json['preview'] as String?,
      colors: _toStringMap(json['colors']),
      assets: _toStringMap(json['assets']),
      icons: _toStringMap(json['icons']),
    );
  }

  ThemePack toEntity() {
    return ThemePack(
      id: id,
      name: name,
      version: version,
      preview: preview,
      colors: colors,
      assets: assets,
      icons: icons,
    );
  }

  static Map<String, String> _toStringMap(dynamic raw) {
    final result = <String, String>{};
    if (raw is Map) {
      for (final entry in raw.entries) {
        result[entry.key.toString()] = entry.value.toString();
      }
    }
    return result;
  }
}
