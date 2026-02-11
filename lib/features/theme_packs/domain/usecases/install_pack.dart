import 'package:dynamic_theme_kit_app/features/theme_packs/domain/entities/theme_pack.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/domain/repositories/theme_pack_repository.dart';

class InstallPack {
  const InstallPack(this._repository);

  final ThemePackRepository _repository;

  Future<ThemePack> call(String packId) {
    return _repository.installPack(packId);
  }
}
