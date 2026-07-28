import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/design_system/design_system.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';
import 'package:vaulta/features/savings/presentation/widgets/pot_tile.dart';

Widget _host(Widget child) =>
    MaterialApp(theme: AppTheme.dark(), home: Scaffold(body: child));

void main() {
  final pot = Pot(
    id: 'pot_rainy',
    accountId: 'acc_chk',
    name: 'Rainy Day',
    balance: Money.parse('450.00', Currency.usd),
    goal: Money.parse('2000.00', Currency.usd),
  );

  testWidgets('shows the pot name and a goal subtitle', (tester) async {
    await tester.pumpWidget(_host(PotTile(pot: pot, onTap: () {})));
    expect(find.text('Rainy Day'), findsOneWidget);
    expect(find.text('Saving toward a goal'), findsOneWidget);
  });

  testWidgets('labels a round-ups pot', (tester) async {
    await tester.pumpWidget(
      _host(
        PotTile(pot: pot.copyWith(roundUpsEnabled: true), onTap: () {}),
      ),
    );
    expect(find.text('Round-ups on'), findsOneWidget);
  });

  testWidgets('fires onTap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _host(PotTile(pot: pot, onTap: () => tapped = true)),
    );
    await tester.tap(find.byType(PotTile));
    expect(tapped, isTrue);
  });
}
