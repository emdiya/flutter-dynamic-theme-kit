import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dynamic_theme_kit_app/app/core/utils/app_logger.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/data/models/pack_model.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/data/sources/remote_theme_pack_api.dart';

class ThemePackRemoteSource implements RemoteThemePackApi {
  ThemePackRemoteSource(this._dio, {required String baseUrl})
    : _baseUrl = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl;

  final Dio _dio;
  final String _baseUrl;

  @override
  Future<List<PackModel>> fetchIndex() async {
    final url = '$_baseUrl/index.json';
    AppLogger.info('Theme URL fetch index: $url');
    final response = await _dio.get<dynamic>(url);
    AppLogger.info(
      'Theme index response: status=${response.statusCode} body=${_previewData(response.data)}',
    );
    final data = response.data;
    if (data is! List) {
      AppLogger.error('Invalid index.json response from $url');
      throw StateError('Invalid index.json response');
    }
    AppLogger.info('Theme index loaded (${data.length} packs)');
    return data
        .whereType<Map>()
        .map((item) => PackModel.fromJson(item.cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<PackModel> fetchPack(String packId) async {
    final url = '$_baseUrl/$packId/pack.json';
    AppLogger.info('Theme URL fetch pack: $url');
    final response = await _dio.get<dynamic>(url);
    AppLogger.info(
      'Theme pack response: id=$packId status=${response.statusCode} body=${_previewData(response.data)}',
    );
    final data = response.data;
    if (data is! Map) {
      AppLogger.error('Invalid pack.json response for $packId from $url');
      throw StateError('Invalid pack.json response for $packId');
    }
    final json = data.cast<String, dynamic>();
    final icons = Map<String, dynamic>.from(
      (json['icons'] as Map?) ?? <String, dynamic>{},
    );
    _copyIconAliasFromAny(
      icons,
      toKey: 'home',
      fromKeys: const [
        'home',
        'angkor',
        'coin',
        'incense',
        'tukata_hat',
        'boat',
      ],
    );
    _copyIconAliasFromAny(
      icons,
      toKey: 'transfer',
      fromKeys: const [
        'transfer',
        'lotus',
        'dragon',
        'offering',
        'tukata_smile',
        'river',
      ],
    );
    _copyIconAliasFromAny(
      icons,
      toKey: 'scan',
      fromKeys: const [
        'scan',
        'water',
        'lantern',
        'pagoda',
        'tukata_wave',
        'splash',
      ],
    );

    final assets = Map<String, dynamic>.from(
      (json['assets'] as Map?) ?? <String, dynamic>{},
    );
    assets['homeBackground'] = 'backgrounds/background.png';

    AppLogger.info('Theme pack loaded: $packId');
    return PackModel.fromJson(<String, dynamic>{
      'id': packId,
      if (json['name'] != null) 'name': json['name'],
      if (json['version'] != null) 'version': json['version'],
      if (json['preview'] != null) 'preview': json['preview'],
      'colors': json['colors'] ?? <String, dynamic>{},
      'icons': icons,
      'assets': assets,
    });
  }

  @override
  Future<List<int>> fetchAssetBytes(String packId, String assetPath) async {
    final normalizedPath = assetPath.startsWith('/')
        ? assetPath.substring(1)
        : assetPath;
    final isAbsoluteUrl =
        normalizedPath.startsWith('http://') ||
        normalizedPath.startsWith('https://');
    final url = isAbsoluteUrl
        ? normalizedPath
        : '$_baseUrl/$packId/$normalizedPath';
    AppLogger.info('Theme URL fetch asset: $url');

    final response = await _dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    final data = response.data;
    if (data == null) {
      AppLogger.error('Invalid asset response from $url');
      throw StateError('Invalid asset response: $url');
    }
    AppLogger.info('Theme asset downloaded: $assetPath (${data.length} bytes)');
    return data;
  }

  String _previewData(dynamic data) {
    try {
      final text = jsonEncode(data);
      const maxLen = 600;
      if (text.length <= maxLen) {
        return text;
      }
      return '${text.substring(0, maxLen)}...(truncated)';
    } catch (_) {
      final text = data.toString();
      const maxLen = 600;
      if (text.length <= maxLen) {
        return text;
      }
      return '${text.substring(0, maxLen)}...(truncated)';
    }
  }

  void _copyIconAliasFromAny(
    Map<String, dynamic> icons, {
    required String toKey,
    required List<String> fromKeys,
  }) {
    final current = icons[toKey];
    if (current is String && current.isNotEmpty) {
      return;
    }

    for (final key in fromKeys) {
      final source = icons[key];
      if (source is String && source.isNotEmpty) {
        icons[toKey] = source;
        AppLogger.info('Theme icon alias mapped: $toKey <- $key');
        return;
      }
    }
  }
}
