import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Build flavor. One entrypoint per flavor (`main_<flavor>.dart`).
enum Flavor { dev, staging, prod }

/// Immutable environment configuration.
///
/// Values are injected at build time with `--dart-define-from-file=env/<flavor>.json`.
/// No `.env` files ship in the binary.
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.apiBaseUrl,
    required this.enableNetworkLogs,
  });

  /// Reads compile-time defines. Must be called with `const`-resolvable keys.
  factory AppConfig.fromEnvironment({required Flavor flavor}) {
    return AppConfig(
      flavor: flavor,
      apiBaseUrl: const String.fromEnvironment('API_BASE_URL'),
      enableNetworkLogs: const bool.fromEnvironment('ENABLE_NETWORK_LOGS'),
    );
  }

  final Flavor flavor;
  final String apiBaseUrl;
  final bool enableNetworkLogs;

  bool get isProd => flavor == Flavor.prod;
}

/// Overridden in `bootstrap()` with the flavor-specific config.
/// Reading it without an override is a wiring bug — fail loudly.
final appConfigProvider = Provider<AppConfig>(
  (ref) => throw UnimplementedError(
    'appConfigProvider must be overridden in bootstrap()',
  ),
);
