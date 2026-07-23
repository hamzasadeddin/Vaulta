import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/design_system/theme/app_theme.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/repositories/accounts_repository.dart';
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/transfers/domain/entities/beneficiary.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';
import 'package:vaulta/features/transfers/domain/repositories/transfers_repository.dart';
import 'package:vaulta/features/transfers/presentation/providers/transfers_providers.dart';
import 'package:vaulta/features/transfers/presentation/widgets/quote_countdown.dart';
import 'package:vaulta/features/transfers/presentation/widgets/review_step.dart';

class _MockTransfers extends Mock implements TransfersRepository {}

class _MockAccounts extends Mock implements AccountsRepository {}

class _FakeTransferRequest extends Fake implements TransferRequest {}

final _checking = Account(
  id: 'acc_chk',
  name: 'Main Checking',
  type: AccountType.checking,
  iban: 'JO82VBNK0001000000000010204573',
  balance: Money.parse('12480.50', Currency.usd),
  openedAt: DateTime(2022, 3, 14),
);

TransferQuote _fxQuote(DateTime expiresAt) => TransferQuote(
      id: 'trf_1',
      idempotencyKey: 'idem_trf_1',
      sourceAccountId: 'acc_chk',
      destinationLabel: 'Layla Haddad',
      destinationDetail: '\u2022\u2022\u2022\u2022 4573',
      amount: Money.parse('250.00', Currency.usd),
      fee: Money.parse('1.25', Currency.usd),
      totalDebit: Money.parse('251.25', Currency.usd),
      destinationAmount: Money.parse('177.250', Currency.jod),
      expiresAt: expiresAt,
    );

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.dark(),
        home: Scaffold(body: child),
      );

  group('QuoteCountdown', () {
    testWidgets('renders the remaining hold as minutes and seconds',
        (tester) async {
      await tester.pumpWidget(
        wrap(const QuoteCountdown(remaining: Duration(seconds: 90))),
      );

      expect(find.text('Rate held 1:30'), findsOneWidget);
    });

    testWidgets('pads the seconds so the width never jumps', (tester) async {
      await tester.pumpWidget(
        wrap(const QuoteCountdown(remaining: Duration(seconds: 65))),
      );

      expect(find.text('Rate held 1:05'), findsOneWidget);
    });

    testWidgets('says so plainly once the hold is gone', (tester) async {
      await tester.pumpWidget(
        wrap(const QuoteCountdown(remaining: Duration.zero)),
      );

      expect(find.text('Rate expired'), findsOneWidget);
      expect(find.textContaining('Rate held'), findsNothing);
    });

    testWidgets('speaks the countdown rather than reading the clock face',
        (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(const QuoteCountdown(remaining: Duration(seconds: 45))),
      );

      // A screen reader gets a sentence, not "1 colon 30".
      expect(
        find.bySemanticsLabel('Exchange rate held for 45 seconds.'),
        findsOneWidget,
      );
      handle.dispose();
    });
  });

  group('ReviewStep — expired quote', () {
    late _MockTransfers transfers;
    late _MockAccounts accounts;
    final start = DateTime(2026, 7, 22, 10);

    setUpAll(() => registerFallbackValue(_FakeTransferRequest()));

    setUp(() {
      transfers = _MockTransfers();
      accounts = _MockAccounts();
      when(accounts.refreshAccounts)
          .thenAnswer((_) async => Result.success([_checking]));
      when(accounts.watchAccounts).thenAnswer(
        (_) => Stream.value(Result.success([_checking])),
      );
      when(transfers.getBeneficiaries)
          .thenAnswer((_) async => const Result.success(<Beneficiary>[]));
    });

    /// Drives the controller to a review step holding a quote that is
    /// already dead, then renders it. The clock is frozen past the expiry
    /// rather than waited out.
    Future<ProviderContainer> pumpExpired(WidgetTester tester) async {
      var now = start;
      when(() => transfers.createTransfer(any())).thenAnswer(
        (_) async => Result.success(
          _fxQuote(now.add(const Duration(seconds: 90))),
        ),
      );
      // Both providers get a permanent listener. Without one on the flow,
      // every `read` below opens a subscription and closes it, and the
      // last close schedules an auto-dispose on a zero-duration timer that
      // outlives the test body.
      final container = ProviderContainer(
        overrides: [
          transfersRepositoryProvider.overrideWithValue(transfers),
          accountsRepositoryProvider.overrideWithValue(accounts),
          transferClockProvider.overrideWithValue(() => now),
        ],
      )
        ..listen(accountsControllerProvider, (_, __) {})
        ..listen(transferFlowProvider, (_, __) {});
      await tester.pump();

      final notifier = container.read(transferFlowProvider.notifier)
        ..selectSource('acc_chk')
        ..selectDestination(const BeneficiaryDestination('ben_layla'))
        ..amountChanged('250.00');
      await notifier.requestQuote();
      now = now.add(const Duration(seconds: 90));
      notifier.tick();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: wrap(const ReviewStep()),
        ),
      );
      await tester.pump();
      return container;
    }

    /// Unmounts the tree and disposes the container **inside** the test
    /// body.
    ///
    /// `addTearDown` is too late: flutter_test asserts that no timer is
    /// pending at the end of the body, and teardown callbacks run after
    /// that. The countdown is a real periodic timer — production cancels
    /// it from `ref.onDispose`, which only fires when the container goes.
    Future<void> closeDown(
      WidgetTester tester,
      ProviderContainer container,
    ) async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
    }

    testWidgets('offers a new price instead of a confirm', (tester) async {
      final container = await pumpExpired(tester);

      expect(find.text('Get a new price'), findsOneWidget);
      expect(find.text('Confirm and send'), findsNothing);
      expect(find.text('Rate expired'), findsOneWidget);

      await closeDown(tester, container);
    });

    testWidgets('tapping it re-prices without ever confirming', (tester) async {
      final container = await pumpExpired(tester);
      when(() => transfers.createTransfer(any())).thenAnswer(
        (_) async => Result.success(
          _fxQuote(start.add(const Duration(seconds: 180))),
        ),
      );

      await tester.tap(find.text('Get a new price'));
      await tester.pumpAndSettle();

      // The dead draft was never sent — that is the point of the whole
      // feature, and no idempotency key can rescue a price the bank has
      // stopped honouring.
      verifyNever(
        () => transfers.confirmTransfer(
          transferId: any(named: 'transferId'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      );
      expect(container.read(transferFlowProvider).quoteExpired, isFalse);
      expect(find.text('Confirm and send'), findsOneWidget);

      // The fresh quote started a fresh ticker — that is the feature
      // working, so it has to be shut down deliberately.
      await closeDown(tester, container);
    });
  });
}
