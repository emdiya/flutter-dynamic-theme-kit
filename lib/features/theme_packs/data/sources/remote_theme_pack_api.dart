import 'package:dynamic_theme_kit_app/features/theme_packs/data/models/pack_model.dart';

abstract class RemoteThemePackApi {
  Future<List<PackModel>> fetchIndex();
  Future<PackModel> fetchPack(String packId);
  Future<List<int>> fetchAssetBytes(String packId, String assetPath);
}

class InMemoryRemoteThemePackApi implements RemoteThemePackApi {
  InMemoryRemoteThemePackApi({
    required List<Map<String, dynamic>> indexJson,
    required Map<String, Map<String, dynamic>> packJsonById,
    Map<String, List<int>> assetBytesByPath = const <String, List<int>>{},
  }) : _indexJson = indexJson,
       _packJsonById = packJsonById,
       _assetBytesByPath = assetBytesByPath;

  final List<Map<String, dynamic>> _indexJson;
  final Map<String, Map<String, dynamic>> _packJsonById;
  final Map<String, List<int>> _assetBytesByPath;

  @override
  Future<List<PackModel>> fetchIndex() async {
    return _indexJson.map(PackModel.fromJson).toList();
  }

  @override
  Future<PackModel> fetchPack(String packId) async {
    final json = _packJsonById[packId];
    if (json == null) {
      throw StateError('Theme pack not found: $packId');
    }
    return PackModel.fromJson(json);
  }

  @override
  Future<List<int>> fetchAssetBytes(String packId, String assetPath) async {
    final key = '$packId/$assetPath';
    final bytes = _assetBytesByPath[key];
    if (bytes == null) {
      throw StateError('Theme asset not found: $key');
    }
    return bytes;
  }
}
