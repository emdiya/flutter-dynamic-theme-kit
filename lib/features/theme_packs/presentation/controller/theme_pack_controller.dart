import 'package:dynamic_theme_kit_app/app/core/utils/app_logger.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/data/models/theme_pack_model.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/domain/entities/theme_pack.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/domain/repositories/theme_pack_repository.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/theme_runtime/theme_runtime.dart';
import 'package:get/get.dart';

class ThemePackController extends GetxController {
  ThemePackController(this._repository);

  final ThemePackRepository _repository;

  final RxList<ThemePack> availablePacks = <ThemePack>[].obs;
  final Rxn<ThemePack> activePack = Rxn<ThemePack>();
  final RxBool isLoading = false.obs;
  final RxBool isThemeApplying = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    _loadInitialTheme();
  }

  Future<void> _loadInitialTheme() async {
    isThemeApplying.value = true;
    await loadActivePack();
    isThemeApplying.value = false;
  }

  Future<void> loadAvailablePacks() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final packs = await _repository.fetchAvailablePacks();
      availablePacks.assignAll(packs);
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> install(String packId) async {
    errorMessage.value = null;
    try {
      await _repository.installPack(packId);
    } catch (error) {
      errorMessage.value = error.toString();
    }
  }

  Future<void> setActive(String packId) async {
    errorMessage.value = null;
    isThemeApplying.value = true;
    try {
      AppLogger.info('Controller setActive requested: $packId');
      await _repository.setActivePack(packId);
      await loadActivePack();
    } catch (error) {
      AppLogger.error('Controller setActive failed for $packId: $error');
      errorMessage.value = error.toString();
    } finally {
      isThemeApplying.value = false;
    }
  }

  Future<void> setDefaultTheme() async {
    errorMessage.value = null;
    isThemeApplying.value = true;
    try {
      AppLogger.info('Controller setDefaultTheme requested');
      await _repository.clearActivePack();
      await loadActivePack();
    } catch (error) {
      AppLogger.error('Controller setDefaultTheme failed: $error');
      errorMessage.value = error.toString();
    } finally {
      isThemeApplying.value = false;
    }
  }

  Future<void> loadActivePack() async {
    errorMessage.value = null;
    try {
      final pack = await _repository.getActivePack();
      activePack.value = pack;
      AppLogger.info(
        'Controller active pack loaded: ${pack?.id ?? 'none'} assets=${pack?.assets.keys.toList() ?? const []}',
      );
      ThemeRuntime.instance.setPack(
        pack == null ? null : ThemePackModel.fromEntity(pack),
      );
    } catch (error) {
      AppLogger.error('Controller loadActivePack failed: $error');
      errorMessage.value = error.toString();
      ThemeRuntime.instance.setPack(null);
    }
  }

  String iconPath(String iconKey, {required String fallbackAsset}) {
    final path = activePack.value?.icons[iconKey];
    return (path == null || path.isEmpty) ? fallbackAsset : path;
  }

  String backgroundPath(String assetKey, {required String fallbackAsset}) {
    final path = activePack.value?.assets[assetKey];
    return (path == null || path.isEmpty) ? fallbackAsset : path;
  }
}
