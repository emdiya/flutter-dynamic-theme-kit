import 'package:dynamic_theme_kit_app/features/theme_packs/domain/repositories/theme_pack_repository.dart';

class SetActivePack {
  const SetActivePack(this._repository);

  final ThemePackRepository _repository;

  Future<void> call(String packId) {
    return _repository.setActivePack(packId);
  }
}
