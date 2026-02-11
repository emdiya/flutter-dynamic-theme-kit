abstract final class BaseUrl {
  // Theme pack CDN/root URL.
  static const String theme = String.fromEnvironment(
    'THEME_BASE_URL',
    defaultValue: 'http://localhost:9000/dynamic-theme-kit/themes',
  );

  // Main API/base URL (for other backend endpoints).
  static const String api = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );
}
