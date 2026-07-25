import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/connectivity/connectivity_monitor.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/iban/iban.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/design_system/theme/app_theme.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/repositories/accounts_repository.dart';
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/auth/presentation/providers/auth_providers.dart';
import 'package:vaulta/features/transfers/domain/entities/beneficiary.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';
import 'package:vaulta/features/transfers/domain/repositories/transfers_repository.dart';
import 'package:vaulta/features/transfers/presentation/providers/outbox_providers.dart';
import 'package:vaulta/features/transfers/presentation/providers/transfers_providers.dart';
import 'package:vaulta/features/transfers/presentation/screens/transfer_flow_screen.dart';

import 'support/fake_outbox.dart';

class _MockTransfers extends Mock implements TransfersRepository {}

class _MockAccounts extends Mock implements AccountsRepository {}

class _FakeTransferRequest extends Fake implements TransferRequest {}

final _accounts = [
  Account(
    id: 'acc_chk',
    name: 'Main Checking',
    type: AccountType.checking,
    iban: 'JO82VBNK0001000000000010204573',
    balance: Money.parse('12480.50', Currency.usd),
    openedAt: DateTime(2022, 3, 14),
  ),
  Account(
    id: 'acc_sav',
    name: 'Savings',
    type: AccountType.savings,
    iban: 'JO55VBNK0001000000000010204574',
    balance: Money.parse('8932.00', Currency.eur),
    openedAt: DateTime(2023),
  ),
];

final _payees = [
  Beneficiary(
    id: 'ben_sara',
    name: 'Sara Malik',
    iban: Iban.tryParse('JO85CABK0030000000000012009903')!,
    bankName: 'Cairo Amman Bank',
    currency: Currency.usd,
  ),
];

TransferQuote _quote() => TransferQuote(
      id: 'trf_1',
      idempotencyKey: 'idem_trf_1',
      sourceAccountId: 'acc_chk',
      destinationLabel: 'Sara Malik',
      destinationDetail: '\u2022\u2022\u2022\u2022 9903',
      amount: Money.parse('250.00', Currency.usd),
      fee: Money.zero(Currency.usd),
      totalDebit: Money.parse('250.00', Currency.usd),
      destinationAmount: Money.parse('250.00', Currency.usd),
    );

Transfer _transfer() => Transfer(
      id: 'trf_1',
      reference: 'VLT-2026-123456',
      status: TransferStatus.completed,
      sourceAccountId: 'acc_chk',
      destinationLabel: 'Sara Malik',
      destinationDetail: '\u2022\u2022\u2022\u2022 9903',
      amount: Money.parse('250.00', Currency.usd),
      fee: Money.zero(Currency.usd),
      totalDebit: Money.parse('250.00', Currency.usd),
      destinationAmount: Money.parse('250.00', Currency.usd),
      createdAt: DateTime(2026, 7, 22, 10),
      balanceAfter: Money.parse('12230.50', Currency.usd),
    );

void main() {
  late _MockTransfers transfers;
  late _MockAccounts accounts;

  setUpAll(() => registerFallbackValue(_FakeTransferRequest()));

  setUp(() {
    transfers = _MockTransfers();
    accounts = _MockAccounts();
    when(accounts.refreshAccounts)
        .thenAnswer((_) async => Result.success(_accounts));
    when(accounts.watchAccounts)
        .thenAnswer((_) => Stream.value(Result.success(_accounts)));
    when(transfers.getBeneficiaries)
        .thenAnswer((_) async => Result.success(_payees));
    when(() => transfers.createTransfer(any()))
        .thenAnswer((_) async => Result.success(_quote()));
    when(
      () => transfers.confirmTransfer(
        transferId: any(named: 'transferId'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer((_) async => Result.success(_transfer()));
  });

  Future<void> pumpFlow(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transfersRepositoryProvider.overrideWithValue(transfers),
          accountsRepositoryProvider.overrideWithValue(accounts),
          // See fake_outbox.dart: keeps the real Drift DB and the
          // connectivity channel out of the widget test.
          outboxRepositoryProvider.overrideWithValue(FakeOutboxRepository()),
          connectivityMonitorProvider
              .overrideWithValue(const SilentConnectivityMonitor()),
          // A queued confirm only drains inside a session (see signedIn
          // in fake_outbox.dart) — model one so reaching the outbox
          // doesn't build the real auth/config chain.
          authControllerProvider.overrideWithValue(signedIn),
        ],
        child: MaterialApp(
          theme: AppTheme.dark(),
          home: const TransferFlowScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Walks recipient → amount → review, leaving the confirm untapped.
  Future<void> reachReview(WidgetTester tester) async {
    await tester.tap(find.text('Saved'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sara Malik'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '250.00');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Review transfer'));
    await tester.pumpAndSettle();
  }

  testWidgets('opens on the recipient step listing the user accounts',
      (tester) async {
    await pumpFlow(tester);

    expect(find.text('Send money'), findsOneWidget);
    expect(find.text('Main Checking'), findsWidgets);
    expect(find.text('Savings'), findsWidgets);
  });

  testWidgets('a saved payee can be picked and carried to review',
      (tester) async {
    await pumpFlow(tester);
    await reachReview(tester);

    expect(find.text('Review'), findsOneWidget);
    expect(find.text('Sara Malik'), findsWidgets);
    expect(find.text('Confirm and send'), findsOneWidget);
  });

  testWidgets('an invalid IBAN blocks progress with an inline error',
      (tester) async {
    await pumpFlow(tester);

    await tester.tap(find.text('New IBAN'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Omar Nasser');
    await tester.enterText(fields.at(1), 'JO83VBNK0001000000000010204573');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('That IBAN isn\u2019t valid'), findsOneWidget);
    // Still on step one — nothing was quoted.
    expect(find.text('Send money'), findsOneWidget);
    verifyNever(() => transfers.createTransfer(any()));
  });

  testWidgets('confirming shows the receipt with its reference',
      (tester) async {
    await pumpFlow(tester);
    await reachReview(tester);

    await tester.tap(find.text('Confirm and send'));
    await tester.pumpAndSettle();

    expect(find.text('Transfer sent'), findsOneWidget);
    expect(find.text('VLT-2026-123456'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);

    verify(
      () => transfers.confirmTransfer(
        transferId: 'trf_1',
        idempotencyKey: 'idem_trf_1',
      ),
    ).called(1);
  });

  testWidgets('a transport failure lands on the saved-to-send surface',
      (tester) async {
    // 9b: a network drop no longer strands the user on review. The
    // confirm is queued and the flow moves to its terminal "saved to
    // send" screen — which must read as pending, not as a receipt.
    when(
      () => transfers.confirmTransfer(
        transferId: any(named: 'transferId'),
        idempotencyKey: any(named: 'idempotencyKey'),
      ),
    ).thenAnswer((_) async => const Result.failure(NetworkFailure()));

    await pumpFlow(tester);
    await reachReview(tester);

    await tester.tap(find.text('Confirm and send'));
    await tester.pumpAndSettle();

    // Off review, onto the queued surface.
    expect(find.text('Confirm and send'), findsNothing);
    expect(find.text('Saved to send'), findsWidgets);
    // The one line that stops a duplicate send.
    expect(
      find.textContaining('Nothing has left your account'),
      findsOneWidget,
    );
  });

  testWidgets('back steps through the flow rather than leaving it',
      (tester) async {
    await pumpFlow(tester);
    await reachReview(tester);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Amount'), findsWidgets);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Send money'), findsOneWidget);
  });
}
