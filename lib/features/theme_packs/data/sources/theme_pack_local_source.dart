import 'dart:convert';
import 'dart:io';

import 'package:dynamic_theme_kit_app/features/theme_packs/data/models/pack_model.dart';
import 'package:path_provider/path_provider.dart';

class ThemePackLocalSource {
  Future<Directory> rootDir() async {
    final dir = await getApplicationSupportDirectory();
    final root = Directory('${dir.path}/theme_packs');
    if (!await root.exists()) {
      await root.create(recursive: true);
    }
    return root;
  }

  Future<File> manifestFile() async {
    final root = await rootDir();
    return File('${root.path}/manifest.json');
  }

  Future<Map<String, dynamic>> readManifest() async {
    final file = await manifestFile();
    if (!await file.exists()) {
      return <String, dynamic>{
        'activePackId': null,
        'installed': <String, dynamic>{},
      };
    }
    return jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  }

  Future<void> writeManifest(Map<String, dynamic> manifest) async {
    final file = await manifestFile();
    await file.writeAsString(jsonEncode(manifest));
  }

  Future<Directory> packDir(String packId) async {
    final root = await rootDir();
    final dir = Directory('${root.path}/$packId');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<void> ensurePackStructure(String packId) async {
    final dir = await packDir(packId);
    final icons = Directory('${dir.path}/icons');
    final backgrounds = Directory('${dir.path}/backgrounds');
    if (!await icons.exists()) {
      await icons.create(recursive: true);
    }
    if (!await backgrounds.exists()) {
      await backgrounds.create(recursive: true);
    }
  }

  Future<void> writePackJson(String packId, Map<String, dynamic> json) async {
    final dir = await packDir(packId);
    await File('${dir.path}/pack.json').writeAsString(jsonEncode(json));
  }

  Future<Map<String, dynamic>?> readPackJson(String packId) async {
    final dir = await packDir(packId);
    final file = File('${dir.path}/pack.json');
    if (!await file.exists()) {
      return null;
    }
    return jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  }

  Future<void> writeAsset(
    String packId,
    String relativePath,
    List<int> bytes,
  ) async {
    final dir = await packDir(packId);
    final file = File('${dir.path}/$relativePath');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
  }

  Future<String> resolvePath(String packId, String relativePath) async {
    final dir = await packDir(packId);
    return '${dir.path}/$relativePath';
  }

  Future<bool> hasAllPackAssets(PackModel pack) async {
    final paths = <String>{
      ...pack.icons.values,
      ...pack.assets.values,
      if (pack.preview != null && pack.preview!.isNotEmpty) pack.preview!,
    };

    for (final relPath in paths) {
      final path = await resolvePath(pack.id, relPath);
      if (!await File(path).exists()) {
        return false;
      }
    }
    return true;
  }

  Future<Directory> tempPackDir(String packId) async {
    final root = await rootDir();
    final temp = Directory('${root.path}/.__tmp__$packId');
    if (await temp.exists()) {
      await temp.delete(recursive: true);
    }
    await temp.create(recursive: true);
    return temp;
  }

  Future<void> commitTempToPack(String packId) async {
    final root = await rootDir();
    final temp = Directory('${root.path}/.__tmp__$packId');
    final finalDir = Directory('${root.path}/$packId');

    if (await finalDir.exists()) {
      await finalDir.delete(recursive: true);
    }
    await temp.rename(finalDir.path);
  }

  // Compatibility helpers for current repository implementation.
  Future<void> saveInstalledPack(PackModel pack) async {
    await ensurePackStructure(pack.id);
    final json = <String, dynamic>{
      'id': pack.id,
      'name': pack.name,
      'version': pack.version,
      if (pack.preview != null) 'preview': pack.preview,
      'colors': pack.colors,
      'assets': pack.assets,
      'icons': pack.icons,
    };

    await writePackJson(pack.id, json);

    final manifest = await readManifest();
    final installed =
        (manifest['installed'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};
    installed[pack.id] = <String, dynamic>{
      'version': pack.version,
      'path': pack.id,
    };
    manifest['installed'] = installed;
    await writeManifest(manifest);
  }

  Future<PackModel?> getInstalledPack(String packId) async {
    final json = await readPackJson(packId);
    if (json == null) {
      return null;
    }
    return PackModel.fromJson(json);
  }

  Future<void> setActivePackId(String packId) async {
    final manifest = await readManifest();
    manifest['activePackId'] = packId;
    await writeManifest(manifest);
  }

  Future<void> clearActivePackId() async {
    final manifest = await readManifest();
    manifest['activePackId'] = null;
    await writeManifest(manifest);
  }

  Future<String?> getActivePackId() async {
    final manifest = await readManifest();
    final activePackId = manifest['activePackId'];
    if (activePackId is String && activePackId.isNotEmpty) {
      return activePackId;
    }
    return null;
  }
}
