import 'package:dynamic_theme_kit_app/app/core/utils/app_logger.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/data/models/pack_model.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/data/sources/theme_pack_local_source.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/data/sources/theme_pack_remote_source.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/domain/entities/theme_pack.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/domain/repositories/theme_pack_repository.dart';

class ThemePackRepositoryImpl implements ThemePackRepository {
  ThemePackRepositoryImpl(this._remoteApi, this._localStore);

  final ThemePackRemoteSource _remoteApi;
  final ThemePackLocalSource _localStore;

  @override
  Future<List<ThemePack>> fetchAvailablePacks() async {
    final packs = await _remoteApi.fetchIndex();
    return packs.map((pack) => pack.toEntity()).toList();
  }

  @override
  Future<ThemePack> installPack(String packId) async {
    AppLogger.info('Installing theme pack: $packId');
    final pack = await _remoteApi.fetchPack(packId);
    await _downloadPackAssets(pack);
    await _localStore.saveInstalledPack(pack);
    AppLogger.info('Theme pack installed: $packId');
    return pack.toEntity();
  }

  @override
  Future<void> setActivePack(String packId) async {
    AppLogger.info('Setting active theme pack: $packId');
    final installed = await _localStore.getInstalledPack(packId);
    if (installed == null) {
      AppLogger.info('Theme pack not installed locally, installing first: $packId');
      await installPack(packId);
    } else {
      AppLogger.info('Using installed local theme pack: $packId');
    }
    await _localStore.setActivePackId(packId);
    AppLogger.info('Active theme pack saved in manifest: $packId');
  }

  @override
  Future<void> clearActivePack() async {
    AppLogger.info('Clearing active theme pack (back to default)');
    await _localStore.clearActivePackId();
  }

  @override
  Future<ThemePack?> getActivePack() async {
    final activePackId = await _localStore.getActivePackId();
    if (activePackId == null) {
      return null;
    }
    final installed = await _localStore.getInstalledPack(activePackId);
    return installed?.toEntity();
  }

  Future<void> _downloadPackAssets(PackModel pack) async {
    final paths = <String>{
      ...pack.icons.values,
      ...pack.assets.values,
      if (pack.preview != null && pack.preview!.isNotEmpty) pack.preview!,
    }.where(_isValidAssetPath).toSet();

    for (final path in paths) {
      final bytes = await _remoteApi.fetchAssetBytes(pack.id, path);
      await _localStore.writeAsset(pack.id, path, bytes);
      AppLogger.info('Theme asset written locally: ${pack.id}/$path');
    }
  }

  bool _isValidAssetPath(String path) {
    final value = path.trim();
    return value.isNotEmpty && value.toLowerCase() != 'null';
  }
}
