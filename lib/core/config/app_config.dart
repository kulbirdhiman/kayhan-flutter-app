/// Build-time configuration.
///
/// Values are injected with `--dart-define` (see Dockerfile / README), so the
/// same code can target staging and production without edits.
class AppConfig {
  AppConfig._();

  static const appName = 'Kayhan Audio';

  /// May be relative (e.g. `/api`) for the Docker web build, where nginx
  /// proxies the API and CDN so the browser avoids CORS.
  static final apiBaseUrl = _absolute(const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.kayhanaudio.com.au',
  ));

  static const _defaultCdn = 'https://d198m4c88a0fux.cloudfront.net';
  static final cdnBaseUrl = _absolute(const String.fromEnvironment('CDN_BASE_URL', defaultValue: _defaultCdn));

  static const oneSignalAppId = String.fromEnvironment(
    'ONESIGNAL_APP_ID',
    defaultValue: 'e499e747-b75d-4316-acc3-fdbb9517d58e',
  );

  static String _absolute(String url) => url.startsWith('/') ? Uri.base.resolve(url).toString() : url;

  /// Turns an API image path (e.g. `uploads/123.png`) into a full CDN URL.
  /// Absolute CDN links (from CMS HTML) are rewritten to [cdnBaseUrl] too.
  static String imageUrl(String path) {
    if (path.startsWith(_defaultCdn)) path = path.substring(_defaultCdn.length);
    if (path.startsWith('http')) return path;
    final clean = path.startsWith('/') ? path.substring(1) : path;
    return Uri.encodeFull('$cdnBaseUrl/$clean');
  }
}
