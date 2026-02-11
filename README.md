# Dynamic Theme Kit

Dynamic Theme Kit is a Flutter theming system that lets you install, cache, and switch full UI theme packs at runtime.

You host theme files on your storage/CDN provider, and the app downloads them, caches them locally, and works offline after installation.

## Who This Guide Is For

- Developers looking for dynamic themes and backgrounds in Flutter apps
- Product teams shipping seasonal, campaign, or white-label theme experiences
- Projects using an admin portal to manage theme kits in MinIO
- Teams that want demo support for both MinIO static hosting and local theme files

## What You Will Build

- A hosted theme store (`index.json`)
- One or more installable theme packs (`pack.json` + assets)
- An app flow to install, apply, update, and recover themes safely

## Hosting Model

Theme kits are managed in a separate repository and uploaded to MinIO.
This app does not manage theme content; it only needs the hosted theme base URL.

Theme kit repository:
`https://github.com/emdiya/dynamic_theme_kit.git`

### Step 1: Configure Flutter Base URL

In this project, configure the theme host URL using `--dart-define` and `BaseUrl.theme`:

```dart
// lib/app/core/config/base_url.dart
static const String theme = String.fromEnvironment(
  'THEME_BASE_URL',
  defaultValue: 'http://localhost:9000/dynamic-theme-kit/themes',
);
```

Run example:

```bash
flutter run --dart-define=THEME_BASE_URL=https://<your-domain>/<bucket-or-path>/themes
```

### Step 2: Add Required Flutter Setup

1. Add default fallback assets in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/default_theme/icons/
    - assets/default_theme/backgrounds/
```

2. Create local storage folder on app start:

```text
<app_support>/theme_packs/
```

Example helper:

```dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<Directory> ensureThemeRootDir() async {
  final appSupport = await getApplicationSupportDirectory();
  final root = Directory('${appSupport.path}/theme_packs');
  if (!await root.exists()) {
    await root.create(recursive: true);
  }
  return root;
}
```

Call it during startup (before `runApp`):

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ensureThemeRootDir();
  runApp(const MyApp());
}
```

3. Keep downloaded theme assets out of `pubspec.yaml` (runtime files only).

### Step 3: Implement Theme Install in Flutter

Recommended install pipeline:

1. Fetch `index.json`
2. Show theme list in UI
3. User selects theme
4. Download `pack.json`
5. Validate JSON and required files
6. Download assets into local pack directory (`<app_support>/theme_packs/<pack_id>/...`)
7. Save/refresh local `pack.json`
8. Update local `manifest.json`
9. Apply selected theme

### Step 4: Save Local Manifest

On-device layout:

```text
/app_support/theme_packs/
├── manifest.json
└── khmer_new_year_2026/
    ├── pack.json
    ├── icons/
    └── backgrounds/
```

Example `manifest.json`:

```json
{
  "activePackId": "khmer_new_year_2026",
  "installed": {
    "khmer_new_year_2026": {
      "version": 3,
      "path": "khmer_new_year_2026"
    }
  }
}
```

### Step 5: Use Theme in Flutter Widgets

Themed icon:

```dart
ThemedIcon(
  "home",
  fallbackAsset: "assets/default_theme/icons/home.png",
)
```

Themed background:

```dart
ThemedBackground(
  assetKey: "homeBackground",
  child: HomeScreen(),
)
```

Runtime rules:

- Load installed files with `FileImage`
- Always provide fallback asset for icons/backgrounds
- If key is missing, use default bundled resource

## Minimal Flutter Project Structure

```text
lib/
├── app/core/
│   ├── config/
│   └── utils/
├── features/theme_packs/
│   ├── data/
│   ├── domain/
│   ├── presentation/
│   └── theme_runtime/
└── main.dart
```

## Final Check (Flutter)

- `THEME_BASE_URL` points to your hosted `themes`
- fallback assets are in `pubspec.yaml`
- install flow writes `manifest.json`
- app can restart and keep active theme
- missing asset uses fallback without crash
