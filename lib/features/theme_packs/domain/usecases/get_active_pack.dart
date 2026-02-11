import 'package:dynamic_theme_kit_app/features/theme_packs/domain/entities/theme_pack.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/domain/repositories/theme_pack_repository.dart';

class GetActivePack {
  const GetActivePack(this._repository);

  final ThemePackRepository _repository;

  Future<ThemePack?> call() {
    return _repository.getActivePack();
  }
}
