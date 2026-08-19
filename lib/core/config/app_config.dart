class AppConfig {
  AppConfig._();

  /// Node/Express backend.
  ///
  /// Android emulator uses 10.0.2.2 to reach the Windows host machine.
  /// Override for a physical phone or production build with:
  /// flutter run --dart-define=API_BASE_URL=https://your-domain.example
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000',
  );

  /// Socket.IO runs on the same HTTP server as the API.
  static const String socketBaseUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: 'http://10.0.2.2:5000',
  );
}
