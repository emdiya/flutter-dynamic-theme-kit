# MinIO Setup for Dynamic Theme Kit

This document explains how to use MinIO as the primary storage for Dynamic Theme Kit assets in a production-style deployment.

## Primary Storage: MinIO

Dynamic Theme Kit works well with MinIO as primary storage for theme assets.

MinIO is used as object storage plus static hosting, not as application backend logic. From the Flutter app perspective, MinIO behaves like GitHub Pages, Firebase Hosting, or Cloudflare R2 because the app only reads public HTTP URLs.

## Why MinIO

- Self-hosted control (on-prem or cloud)
- S3-compatible API
- Large asset support (images, fonts, animations)
- Easy integration with CDN or NGINX
- Good fit for enterprise and banking-style apps

Ideal use cases:

- Seasonal themes
- Brand and white-label themes
- Internal enterprise apps
- Controlled rollout of UI assets

## Recommended MinIO Architecture

```text
Flutter App
   │
   │ HTTPS (GET)
   ▼
CDN / NGINX (optional but recommended)
   │
   ▼
MinIO (Public Read Bucket)
```

## MinIO Setup (Static Hosting Mode)

1. Run MinIO (Docker):

```bash
docker run -d \
  --name minio \
  -p 9000:9000 \
  -p 9001:9001 \
  -e MINIO_ROOT_USER=minioadmin \
  -e MINIO_ROOT_PASSWORD=minioadmin123 \
  quay.io/minio/minio server /data --console-address ":9001"
```

API: `http://localhost:9000`  
Console: `http://localhost:9001`

2. Create a public read bucket (example: `theme-assets`) and apply read-only object access.

Example bucket policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": ["s3:GetObject"],
      "Resource": ["arn:aws:s3:::theme-assets/*"]
    }
  ]
}
```

3. Upload `themes/` as-is:

```text
theme-assets/
└── themes/
    ├── index.json
    ├── khmer_new_year_2026/
    │   ├── pack.json
    │   ├── preview.png
    │   ├── icons/
    │   └── backgrounds/
    └── water_festival_2026/
        ├── pack.json
        ├── preview.png
        ├── icons/
        └── backgrounds/
```

4. Verify public URLs in browser (example domain `https://minio.example.com`):

- `https://minio.example.com/theme-assets/themes/index.json`
- `https://minio.example.com/theme-assets/themes/khmer_new_year_2026/pack.json`
- `https://minio.example.com/theme-assets/themes/khmer_new_year_2026/icons/home.png`

## Flutter Configuration (MinIO)

```dart
const themeBaseUrl = "https://minio.example.com/theme-assets/themes";
```

## Production Best Practices

- Put MinIO behind NGINX, Cloudflare, or load balancer
- Enable HTTPS termination at the edge
- Add caching headers, compression, and rate limiting
