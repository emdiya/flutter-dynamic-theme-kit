import 'package:dio/dio.dart';
import 'package:dynamic_theme_kit_app/app/core/config/base_url.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/data/repositories/theme_pack_repository_impl.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/data/sources/theme_pack_local_source.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/data/sources/theme_pack_remote_source.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/domain/repositories/theme_pack_repository.dart';
import 'package:dynamic_theme_kit_app/features/theme_packs/presentation/pages/theme_bootstrap_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/theme_packs/presentation/controller/theme_pack_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dio = Dio();
  final remote = ThemePackRemoteSource(dio, baseUrl: BaseUrl.theme);
  final local = ThemePackLocalSource();
  final repo = ThemePackRepositoryImpl(remote, local);

  Get.put(local);
  Get.put<ThemePackRepository>(repo);
  Get.put(ThemePackController(repo));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dynamic Theme Kit',
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: const ThemeBootstrapPage(),
    );
  }
}
