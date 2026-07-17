import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/design_system/design_system.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    theme: AppTheme.dark(),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('AnimatedBalanceText', () {
    testWidgets('tweens through intermediates and lands exactly',
        (tester) async {
      var money = Money.parse('100.00', Currency.usd);
      late StateSetter rebuild;

      await tester.pumpWidget(
        _harness(
          StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return AnimatedBalanceText(
                money,
                duration: const Duration(milliseconds: 200),
              );
            },
          ),
        ),
      );
      // First build renders the target immediately — no intro animation.
      expect(find.text(r'$100.00'), findsOneWidget);

      rebuild(() => money = Money.parse('250.00', Currency.usd));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Mid-flight: strictly between the endpoints.
      expect(find.text(r'$100.00'), findsNothing);
      expect(find.text(r'$250.00'), findsNothing);

      await tester.pumpAndSettle();
      expect(find.text(r'$250.00'), findsOneWidget);
    });

    testWidgets('masked hides the amount behind the symbol', (tester) async {
      await tester.pumpWidget(
        _harness(
          AnimatedBalanceText(
            Money.parse('100.00', Currency.usd),
            masked: true,
          ),
        ),
      );

      expect(find.text(r'$ ••••'), findsOneWidget);
      expect(find.textContaining('100'), findsNothing);
    });
  });
}
