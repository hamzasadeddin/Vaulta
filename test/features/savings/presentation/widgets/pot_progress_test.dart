import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';
import 'package:vaulta/features/savings/presentation/widgets/pot_progress.dart';

Pot _pot({required Money balance, Money? goal}) => Pot(
      id: 'p',
      accountId: 'acc_chk',
      name: 'Rainy Day',
      balance: balance,
      goal: goal,
    );

Widget _host(Widget child) =>
    MaterialApp(theme: AppTheme.dark(), home: Scaffold(body: child));

void main() {
  testWidgets('renders nothing for an open-ended pot', (tester) async {
    await tester.pumpWidget(
      _host(
        PotProgress(pot: _pot(balance: Money.parse('10.00', Currency.usd))),
      ),
    );
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('shows percentage for a goal in progress', (tester) async {
    await tester.pumpWidget(
      _host(
        PotProgress(
          pot: _pot(
            balance: Money.parse('500.00', Currency.usd),
            goal: Money.parse('2000.00', Currency.usd),
          ),
        ),
      ),
    );
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.textContaining('25%'), findsOneWidget);
  });

  testWidgets('shows goal reached when funded past target', (tester) async {
    await tester.pumpWidget(
      _host(
        PotProgress(
          pot: _pot(
            balance: Money.parse('2500.00', Currency.usd),
            goal: Money.parse('2000.00', Currency.usd),
          ),
        ),
      ),
    );
    expect(find.text('Goal reached'), findsOneWidget);
  });

  testWidgets('compact renders only the bar, no figures', (tester) async {
    await tester.pumpWidget(
      _host(
        PotProgress(
          pot: _pot(
            balance: Money.parse('500.00', Currency.usd),
            goal: Money.parse('2000.00', Currency.usd),
          ),
          compact: true,
        ),
      ),
    );
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.textContaining('%'), findsNothing);
  });
}
