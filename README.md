# Dynamic Theme Kit

Dynamic Theme Kit is a Flutter theming system that lets you install, cache, and switch full UI theme packs at runtime. It uses MinIO for theme asset hosting with a static-hosting workflow (no backend theme API required in this guide).

You host theme files on MinIO, and the app downloads them, caches them locally, and works offline after installation.

## Who This Guide Is For

- Developers looking for dynamic themes and backgrounds in Flutter apps
- Teams who want seasonal, campaign, or white-label themes
- Projects that may use backend code in production, but want a MinIO-based guide

## What You Will Build

- A hosted theme store (`index.json`)
- One or more installable theme packs (`pack.json` + assets)
- An app flow to install, apply, update, and recover themes safely

## Project Layout

```text
dynamic_theme_kit/
│
├── themes/                         # Deploy this folder to MinIO
│   ├── index.json
│   └── khmer_new_year_2026/
│       ├── pack.json
│       ├── preview.png
│       ├── icons/
│       └── backgrounds/
│
├── apps/
│   └── dynamic_theme_kit_app/      # Flutter app (example + production app)
│
├── packages/
│   └── dynamic_theme_kit/          # Future shared Flutter package
│
├── README.md
└── LICENSE
```

## Hosting Model (MinIO-Only)

This sample follows a backend-style content structure, but serves everything from MinIO static URLs.

Primary platform:

- MinIO (S3-compatible object storage, self-hosted or managed)

## Primary Storage: MinIO (Planned Production Setup)

MinIO is the primary storage for theme assets and is treated as static hosting from the app perspective.

For full MinIO setup (Docker, bucket policy, upload layout, URL checks, and production best practices), see `MINIO_SETUP.md`.

## End-to-End Setup

### Step 1: Create the Hosted Theme Folder

Create this structure under `themes/` with multiple theme packs:

```text
themes/
├── index.json
├── khmer_new_year_2026/
│   ├── pack.json
│   ├── preview.png
│   ├── icons/
│   └── backgrounds/
├── water_festival_2026/
│   ├── pack.json
│   ├── preview.png
│   ├── icons/
│   └── backgrounds/
└── company_brand_dark/
    ├── pack.json
    ├── preview.png
    ├── icons/
    └── backgrounds/
```

### Step 2: Create `index.json` (Theme Store)

`index.json` is the list of theme packs shown in your app.

Example:

```json
[
  {
    "id": "khmer_new_year_2026",
    "name": "Khmer New Year 2026",
    "version": 3,
    "preview": "khmer_new_year_2026/preview.png"
  }
]
```

Field guide:

- `id`: stable unique ID, lowercase with underscores recommended
- `name`: user-facing display name
- `version`: integer; increase when content changes
- `preview`: relative path to preview image from `themes/`

### Step 3: Create `pack.json` (Theme Definition)

Example:

```json
{
  "id": "khmer_new_year_2026",
  "name": "Khmer New Year 2026",
  "version": 3,
  "colors": {
    "primary": "#D61C4E",
    "background": "#FFFFFF",
    "textPrimary": "#111827"
  },
  "assets": {
    "homeBackground": "backgrounds/home_bg.webp"
  },
  "icons": {
    "home": "icons/home.png",
    "transfer": "icons/transfer.png",
    "scan": "icons/scan.png"
  }
}
```

Rules:

- `id` and `version` must match the entry in `index.json`
- Asset paths are relative to the pack folder
- Use only files you actually uploaded
- Downloaded pack assets are not declared in `pubspec.yaml`

### Step 4: Deploy `themes/` to MinIO

Upload the same `themes/` folder to a public MinIO bucket and use a URL like:

```text
https://<minio-domain>/<bucket-name>/themes/index.json
```

Minimum verification before app integration:

- `index.json` opens in browser
- `pack.json` opens in browser
- `preview.png` opens in browser
- icon and background paths return HTTP 200

### Step 5: Configure Flutter Base URL

In your Flutter project, set the theme host URL:

```dart
const themeBaseUrl = "https://<minio-domain>/<bucket-name>/themes";
```

### Step 6: Add Required Flutter Setup

1. Add default fallback assets in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/icons/home_default.png
    - assets/icons/transfer_default.png
    - assets/icons/scan_default.png
    - assets/backgrounds/home_bg_default.webp
```

2. Create local storage folder on app start:

```text
<app_support>/theme_packs/
```

3. Keep downloaded theme assets out of `pubspec.yaml` (runtime files only).

### Step 7: Implement Theme Install in Flutter

Recommended install pipeline:

1. Fetch `index.json`
2. Show theme list in UI
3. User selects theme
4. Download `pack.json`
5. Validate JSON and required files
6. Download assets into temp directory
7. Commit temp folder to final pack directory
8. Update local `manifest.json`
9. Apply selected theme

### Step 8: Save Local Manifest

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

### Step 9: Use Theme in Flutter Widgets

Themed icon:

```dart
ThemedIcon(
  "home",
  fallbackAsset: "assets/icons/home_default.png",
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
├── core/theme/
│   ├── theme_controller.dart
│   ├── theme_repository.dart
│   ├── theme_remote_source.dart
│   ├── theme_local_source.dart
│   └── theme_runtime.dart
├── widgets/
│   ├── themed_icon.dart
│   └── themed_background.dart
└── main.dart
```

## Final Check (Flutter)

- `themeBaseUrl` points to your hosted `themes`
- fallback assets are in `pubspec.yaml`
- install flow writes `manifest.json`
- app can restart and keep active theme
- missing asset uses fallback without crash
