import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:vaulta/app/app.dart';
import 'package:vaulta/core/config/app_config.dart';
import 'package:vaulta/core/logging/logging_providers.dart';
import 'package:vaulta/core/network/mock/mock_api_interceptor.dart';
import 'package:vaulta/core/network/network_providers.dart';
import 'package:vaulta/core/security/biometric_service.dart';
import 'package:vaulta/features/auth/presentation/screens/login_screen.dart';
import 'package:vaulta/features/auth/presentation/screens/otp_screen.dart';
import 'package:vaulta/features/dashboard/presentation/screens/dashboard_screen.dart';

class _MockBiometricService extends Mock implements BiometricService {}

/// End-to-end widget journey: real router, real controller, real
/// repository, real Dio pipeline — only the socket (mock API) and
/// biometrics are fake.
void main() {
  const config = AppConfig(
    flavor: Flavor.dev,
    apiBaseUrl: 'https://mock.vaulta.test/v1',
    enableNetworkLogs: false,
    useMockApi: true,
  );

  late _MockBiometricService biometrics;

  setUp(() {
    biometrics = _MockBiometricService();
    when(() => biometrics.authenticate(reason: any(named: 'reason')))
        .thenAnswer((_) async => true);
  });

  Widget harness() {
    return ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        talkerProvider.overrideWithValue(Talker()),
        mockApiInterceptorProvider.overrideWith(
          (ref) => MockApiInterceptor(latency: Duration.zero),
        ),
        biometricServiceProvider.overrideWithValue(biometrics),
        // In-memory token store (core default) — no platform channels.
      ],
      child: const VaultaApp(),
    );
  }

  testWidgets('cold start with no session lands on login', (tester) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('login → OTP → authenticated home', (tester) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'name@example.com'),
      'dana@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Your password'),
      'hunter2hunter2',
    );
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.byType(OtpScreen), findsOneWidget);
    expect(find.textContaining('d***@example.com'), findsOneWidget);

    await tester.enterText(
      find.byType(TextField).last,
      MockApiInterceptor.otpCode,
    );
    await tester.pumpAndSettle();

    expect(find.byType(DashboardScreen), findsOneWidget);
  });

  testWidgets('wrong OTP shows a field error and stays put', (tester) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'name@example.com'),
      'dana@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Your password'),
      'hunter2hunter2',
    );
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).last, '000000');
    await tester.pumpAndSettle();

    expect(find.byType(OtpScreen), findsOneWidget);
    expect(find.textContaining('Incorrect'), findsOneWidget);
  });

  testWidgets('local validation blocks submission with field errors',
      (tester) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'name@example.com'),
      'not-an-email',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Your password'),
      'short',
    );
    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('At least 8 characters'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
