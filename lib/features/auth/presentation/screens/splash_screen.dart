import 'package:flutter/material.dart';
import 'package:vaulta/design_system/design_system.dart';

/// Shown while the stored session is being restored (AuthUnknown).
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Vaulta', style: context.textStyles.displaySmall),
            SizedBox(height: context.spacing.lg),
            const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ],
        ),
      ),
    );
  }
}
