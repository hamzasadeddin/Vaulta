import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:vaulta/design_system/theme/app_theme.dart';

/// Global test bootstrap. Golden tests render against the dark theme
/// (the brand's primary mode). Platform goldens are generated locally for
/// human review; CI compares only the deterministic Ahem-font variants.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final isCi = Platform.environment.containsKey('CI');
  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      theme: AppTheme.dark(),
      platformGoldensConfig: PlatformGoldensConfig(enabled: !isCi),
    ),
    run: testMain,
  );
}
