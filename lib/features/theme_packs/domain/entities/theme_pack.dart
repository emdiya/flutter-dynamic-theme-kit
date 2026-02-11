class ThemePack {
  const ThemePack({
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

  ThemePack copyWith({
    String? id,
    String? name,
    int? version,
    String? preview,
    Map<String, String>? colors,
    Map<String, String>? assets,
    Map<String, String>? icons,
  }) {
    return ThemePack(
      id: id ?? this.id,
      name: name ?? this.name,
      version: version ?? this.version,
      preview: preview ?? this.preview,
      colors: colors ?? this.colors,
      assets: assets ?? this.assets,
      icons: icons ?? this.icons,
    );
  }
}
