import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/app/app.dart';
import 'package:vaulta/core/config/app_config.dart';

void main() {
  testWidgets('shell renders with injected config', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(
            const AppConfig(
              flavor: Flavor.dev,
              apiBaseUrl: 'https://api.test.local',
              enableNetworkLogs: false,
            ),
          ),
        ],
        child: const VaultaApp(),
      ),
    );

    expect(find.text('Vaulta'), findsOneWidget);
    expect(find.text('DEV'), findsOneWidget);
    expect(find.textContaining('12,480.50'), findsOneWidget);
  });
}
