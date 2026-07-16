import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:vaulta/core/config/app_config.dart';
import 'package:vaulta/core/logging/logging_providers.dart';
import 'package:vaulta/core/network/network_providers.dart';
import 'package:vaulta/features/auth/data/datasources/api_token_refresher.dart';
import 'package:vaulta/features/auth/data/datasources/secure_token_store.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_providers.dart';

/// Global composition root: fills the core network seams with the auth
/// feature's implementations. Tests build their own scope instead.
///
/// Returns the scope rather than a raw override list so the Riverpod
/// override type never has to be named here.
ProviderScope buildAppScope({
  required AppConfig config,
  required Talker talker,
  required Widget child,
}) {
  return ProviderScope(
    overrides: [
      appConfigProvider.overrideWithValue(config),
      talkerProvider.overrideWithValue(talker),
      authTokenStoreProvider.overrideWith((ref) => SecureAuthTokenStore()),
      authTokenRefresherProvider.overrideWith(
        (ref) => ApiTokenRefresher(ref.watch(refreshDioProvider)),
      ),
      // Deferred read: resolving the controller here at build time would
      // create a dio → auth → dio provider cycle.
      sessionExpiredHandlerProvider.overrideWith(
        (ref) => () async =>
            ref.read(authControllerProvider.notifier).onSessionExpired(),
      ),
    ],
    child: child,
  );
}
