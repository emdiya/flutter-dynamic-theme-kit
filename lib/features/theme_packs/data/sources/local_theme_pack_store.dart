import 'package:dynamic_theme_kit_app/features/theme_packs/data/models/pack_model.dart';

class LocalThemePackStore {
  final Map<String, PackModel> _installedById = <String, PackModel>{};
  String? _activePackId;

  Future<void> saveInstalledPack(PackModel pack) async {
    _installedById[pack.id] = pack;
  }

  Future<List<PackModel>> getInstalledPacks() async {
    return _installedById.values.toList();
  }

  Future<PackModel?> getInstalledPack(String packId) async {
    return _installedById[packId];
  }

  Future<void> setActivePackId(String packId) async {
    _activePackId = packId;
  }

  Future<String?> getActivePackId() async {
    return _activePackId;
  }
}
