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
  group('AppButton', () {
    testWidgets('invokes onPressed when tapped', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _harness(AppButton(label: 'Tap', onPressed: () => taps++)),
      );
      await tester.tap(find.text('Tap'));
      expect(taps, 1);
    });

    testWidgets('suppresses taps and shows spinner while loading',
        (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _harness(
          AppButton(label: 'Confirm', loading: true, onPressed: () => taps++),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.text('Confirm'), warnIfMissed: false);
      expect(taps, 0);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('BalanceText', () {
    testWidgets('renders the formatted amount', (tester) async {
      await tester.pumpWidget(
        _harness(BalanceText(Money.parse('1234.56', Currency.usd))),
      );
      expect(find.textContaining('1,234.56'), findsOneWidget);
    });

    testWidgets('masks the amount but keeps the symbol', (tester) async {
      await tester.pumpWidget(
        _harness(
          BalanceText(Money.parse('1234.56', Currency.usd), masked: true),
        ),
      );
      expect(find.textContaining('••••'), findsOneWidget);
      expect(find.textContaining('1,234'), findsNothing);
    });
  });

  group('AppTextField', () {
    testWidgets('obscure toggle reveals and hides input', (tester) async {
      await tester.pumpWidget(
        _harness(const AppTextField(label: 'Password', obscure: true)),
      );

      EditableText editable() =>
          tester.widget<EditableText>(find.byType(EditableText));

      expect(editable().obscureText, isTrue);
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(editable().obscureText, isFalse);
    });
  });

  group('SkeletonBox', () {
    testWidgets('renders static tone when animation is off', (tester) async {
      await tester.pumpWidget(
        _harness(const SkeletonBox(width: 100, animate: false)),
      );
      expect(find.byType(SkeletonBox), findsOneWidget);
      // Static skeletons must not schedule frames forever.
      expect(tester.hasRunningAnimations, isFalse);
    });
  });

  group('Breakpoint', () {
    test('maps widths per spec §5', () {
      expect(Breakpoint.fromWidth(320), Breakpoint.compact);
      expect(Breakpoint.fromWidth(599), Breakpoint.compact);
      expect(Breakpoint.fromWidth(600), Breakpoint.medium);
      expect(Breakpoint.fromWidth(1024), Breakpoint.medium);
      expect(Breakpoint.fromWidth(1025), Breakpoint.expanded);
    });
  });

  group('AdaptiveScaffold', () {
    const destinations = [
      AdaptiveDestination(icon: Icons.home, label: 'Home'),
      AdaptiveDestination(icon: Icons.credit_card, label: 'Cards'),
    ];

    Widget shell({Widget? secondary}) {
      return MaterialApp(
        theme: AppTheme.dark(),
        home: AdaptiveScaffold(
          destinations: destinations,
          selectedIndex: 0,
          onDestinationSelected: (_) {},
          body: const Text('primary'),
          secondaryBody: secondary,
        ),
      );
    }

    Future<void> resize(WidgetTester tester, Size size) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('compact uses bottom navigation', (tester) async {
      await resize(tester, const Size(400, 800));
      await tester.pumpWidget(shell());
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });

    testWidgets('medium uses a navigation rail', (tester) async {
      await resize(tester, const Size(800, 800));
      await tester.pumpWidget(shell());
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('expanded shows the secondary pane', (tester) async {
      await resize(tester, const Size(1400, 900));
      await tester.pumpWidget(shell(secondary: const Text('detail')));
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.text('detail'), findsOneWidget);
    });

    testWidgets('secondary pane is hidden below expanded', (tester) async {
      await resize(tester, const Size(800, 800));
      await tester.pumpWidget(shell(secondary: const Text('detail')));
      expect(find.text('detail'), findsNothing);
    });
  });
}
