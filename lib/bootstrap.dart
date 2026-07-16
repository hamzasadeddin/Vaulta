import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:vaulta/app/app.dart';
import 'package:vaulta/app/di/di_overrides.dart';
import 'package:vaulta/core/config/app_config.dart';

/// Shared startup path for every flavor entrypoint.
Future<void> bootstrap({required Flavor flavor}) async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment(flavor: flavor);
  final talker = TalkerFlutter.init();

  // Framework build/layout errors.
  FlutterError.onError = (details) {
    talker.handle(details.exception, details.stack, 'FlutterError');
  };
  // Uncaught async errors — supersedes runZonedGuarded.
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    talker.handle(error, stackTrace, 'PlatformDispatcher');
    return true;
  };

  talker.info('Booting Vaulta [${flavor.name}] → ${config.apiBaseUrl}');

  runApp(
    buildAppScope(
      config: config,
      talker: talker,
      child: const VaultaApp(),
    ),
  );
}
