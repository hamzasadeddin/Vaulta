import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/design_system/theme/app_theme.dart';

/// Global test bootstrap. Golden tests render against the dark theme
/// (the brand's primary mode). Platform goldens are generated locally for
/// human review; CI compares only the deterministic Ahem-font variants.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final isCi = Platform.environment.containsKey('CI');

  // Goldens are generated on a developer machine (Windows) and verified on
  // a Linux runner. Skia antialiases rounded corners and gradients a hair
  // differently across platforms, which fails a byte-exact comparison for
  // reasons that have nothing to do with the UI. Allow sub-perceptual
  // drift; anything structural — a colour change, a layout shift, a
  // missing widget — moves far more than this threshold and still fails.
  final comparator = goldenFileComparator;
  if (comparator is LocalFileComparator) {
    goldenFileComparator = _TolerantGoldenComparator(comparator.basedir);
  }

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      theme: AppTheme.dark(),
      platformGoldensConfig: PlatformGoldensConfig(enabled: !isCi),
    ),
    run: testMain,
  );
}

class _TolerantGoldenComparator extends LocalFileComparator {
  _TolerantGoldenComparator(Uri basedir)
      : super(Uri.parse('${basedir}test.dart'));

  /// Maximum fraction of differing pixels treated as noise (0.5%).
  static const _tolerance = 0.005;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    if (result.passed || result.diffPercent <= _tolerance) return true;
    throw FlutterError(
      await generateFailureOutput(result, golden, basedir),
    );
  }
}
