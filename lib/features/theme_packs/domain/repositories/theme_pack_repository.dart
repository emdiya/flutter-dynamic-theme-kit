import 'package:dynamic_theme_kit_app/features/theme_packs/domain/entities/theme_pack.dart';

abstract class ThemePackRepository {
  Future<List<ThemePack>> fetchAvailablePacks();
  Future<ThemePack> installPack(String packId);
  Future<void> setActivePack(String packId);
  Future<void> clearActivePack();
  Future<ThemePack?> getActivePack();
}
