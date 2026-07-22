import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/iban/iban.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/repositories/accounts_repository.dart';
import 'package:vaulta/features/accounts/presentation/providers/accounts_providers.dart';
import 'package:vaulta/features/transfers/domain/entities/beneficiary.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';
import 'package:vaulta/features/transfers/domain/repositories/transfers_repository.dart';
import 'package:vaulta/features/transfers/presentation/providers/transfers_providers.dart';

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

TransferQuote _quote({
  String id = 'trf_1',
  String key = 'idem_trf_1',
  DateTime? scheduledFor,
}) =>
    TransferQuote(
      id: id,
      idempotencyKey: key,
      sourceAccountId: 'acc_chk',
      destinationLabel: 'Sara Malik',
      destinationDetail: '\u2022\u2022\u2022\u2022 9903',
      amount: Money.parse('250.00', Currency.usd),
      fee: Money.zero(Currency.usd),
      totalDebit: Money.parse('250.00', Currency.usd),
      destinationAmount: Money.parse('250.00', Currency.usd),
      scheduledFor: scheduledFor,
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

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  setUpAll(() {
    registerFallbackValue(_FakeTransferRequest());
  });

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

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        transfersRepositoryProvider.overrideWithValue(transfers),
        accountsRepositoryProvider.overrideWithValue(accounts),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  /// The flow parses the amount in the source account's currency, so the
  /// accounts controller has to have loaded first.
  Future<ProviderContainer> readyContainer() async {
    final container = makeContainer()
      ..listen(accountsControllerProvider, (_, __) {})
      ..listen(transferFlowProvider, (_, __) {});
    await settle();
    await settle();
    return container;
  }

  group('TransferFlow — building a draft', () {
    test('starts on the recipient step with nothing chosen', () {
      final container = makeContainer()
        ..listen(transferFlowProvider, (_, __) {});
      final state = container.read(transferFlowProvider);

      expect(state.step, TransferStep.recipient);
      expect(state.destination, isNull);
      expect(state.canQuote, isFalse);
    });

    test('a typed IBAN is only accepted once it passes mod-97', () async {
      final container = await readyContainer();
      // bad check digits
      final notifier = container.read(transferFlowProvider.notifier)
        ..holderNameChanged('Omar Nasser')
        ..ibanChanged('JO83VBNK0001000000000010204573');
      expect(notifier.useTypedIban(), isFalse);
      expect(container.read(transferFlowProvider).destination, isNull);

      notifier.ibanChanged('jo71 hbho 0020 0000 0000 0012 0099 02');
      expect(notifier.useTypedIban(), isTrue);

      final destination = container.read(transferFlowProvider).destination;
      expect(destination, isA<IbanDestination>());
      expect(
        (destination! as IbanDestination).iban.value,
        'JO71HBHO0020000000000012009902',
      );
    });

    test('editing an input clears a stale quote', () async {
      when(() => transfers.createTransfer(any()))
          .thenAnswer((_) async => Result.success(_quote()));

      final container = await readyContainer();
      final notifier = container.read(transferFlowProvider.notifier)
        ..selectSource('acc_chk')
        ..selectDestination(const BeneficiaryDestination('ben_sara'))
        ..amountChanged('250.00');
      await notifier.requestQuote();
      expect(container.read(transferFlowProvider).quote, isNotNull);

      // A price the user has moved on from must never be confirmable.
      notifier.amountChanged('300.00');
      expect(container.read(transferFlowProvider).quote, isNull);
      expect(container.read(transferFlowProvider).step, TransferStep.review);
    });
  });

  group('TransferFlow — quoting', () {
    test('a successful quote advances to review', () async {
      when(() => transfers.createTransfer(any()))
          .thenAnswer((_) async => Result.success(_quote()));

      final container = await readyContainer();
      final notifier = container.read(transferFlowProvider.notifier)
        ..selectSource('acc_chk')
        ..selectDestination(const BeneficiaryDestination('ben_sara'))
        ..amountChanged('250.00');

      final failure = await notifier.requestQuote();

      expect(failure, isNull);
      final state = container.read(transferFlowProvider);
      expect(state.step, TransferStep.review);
      expect(state.quote?.idempotencyKey, 'idem_trf_1');
      expect(state.busy, isFalse);
    });

    test('the amount is parsed in the source account currency', () async {
      when(() => transfers.createTransfer(any()))
          .thenAnswer((_) async => Result.success(_quote()));

      final container = await readyContainer();
      await (container.read(transferFlowProvider.notifier)
            ..selectSource('acc_chk')
            ..selectDestination(const BeneficiaryDestination('ben_sara'))
            ..amountChanged('250.00'))
          .requestQuote();

      final captured = verify(
        () => transfers.createTransfer(captureAny()),
      ).captured.single as TransferRequest;

      expect(captured.amount, Money.parse('250.00', Currency.usd));
      expect(captured.amount.currency, Currency.usd);
    });

    test('a rejected quote stays on the amount step and returns the failure',
        () async {
      when(() => transfers.createTransfer(any())).thenAnswer(
        (_) async => const Result.failure(
          ValidationFailure(
            fieldErrors: {
              'amountMinor': ['Not enough available balance'],
            },
          ),
        ),
      );

      final container = await readyContainer();
      // The recipient step advances the flow before the user can enter an
      // amount, so mirror that here — otherwise the assertion below is
      // asserting against the step the flow never left.
      final failure = await (container.read(transferFlowProvider.notifier)
            ..selectSource('acc_chk')
            ..selectDestination(const BeneficiaryDestination('ben_sara'))
            ..goTo(TransferStep.amount)
            ..amountChanged('250.00'))
          .requestQuote();

      expect(failure, isA<ValidationFailure>());
      final state = container.read(transferFlowProvider);
      // The point of the test: a rejected quote must not advance to
      // review, so the user cannot confirm a price the server refused.
      expect(state.step, TransferStep.amount);
      expect(state.quote, isNull);
      expect(state.busy, isFalse);
    });

    test('an unparseable amount never reaches the network', () async {
      final container = await readyContainer();
      final failure = await (container.read(transferFlowProvider.notifier)
            ..selectSource('acc_chk')
            ..selectDestination(const BeneficiaryDestination('ben_sara'))
            ..amountChanged('abc'))
          .requestQuote();

      expect(failure, isNull);
      verifyNever(() => transfers.createTransfer(any()));
    });
  });

  group('TransferFlow — confirming', () {
    Future<ProviderContainer> quoted() async {
      when(() => transfers.createTransfer(any()))
          .thenAnswer((_) async => Result.success(_quote()));
      final container = await readyContainer();
      await (container.read(transferFlowProvider.notifier)
            ..selectSource('acc_chk')
            ..selectDestination(const BeneficiaryDestination('ben_sara'))
            ..amountChanged('250.00'))
          .requestQuote();
      return container;
    }

    test('confirm is pessimistic — no receipt until the server answers',
        () async {
      final completer = Completer<Result<Transfer, Failure>>();
      when(
        () => transfers.confirmTransfer(
          transferId: any(named: 'transferId'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenAnswer((_) => completer.future);

      final container = await quoted();
      final pending = container.read(transferFlowProvider.notifier).confirm();

      // Still on review, still busy — nothing is shown as sent.
      var state = container.read(transferFlowProvider);
      expect(state.step, TransferStep.review);
      expect(state.transfer, isNull);
      expect(state.busy, isTrue);

      completer.complete(Result.success(_transfer()));
      await pending;

      state = container.read(transferFlowProvider);
      expect(state.step, TransferStep.receipt);
      expect(state.transfer?.reference, 'VLT-2026-123456');
      expect(state.busy, isFalse);
    });

    test('replays the quote-issued idempotency key', () async {
      when(
        () => transfers.confirmTransfer(
          transferId: any(named: 'transferId'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenAnswer((_) async => Result.success(_transfer()));

      final container = await quoted();
      await container.read(transferFlowProvider.notifier).confirm();

      verify(
        () => transfers.confirmTransfer(
          transferId: 'trf_1',
          idempotencyKey: 'idem_trf_1',
        ),
      ).called(1);
    });

    test('a second tap while one confirm is in flight is a no-op', () async {
      final completer = Completer<Result<Transfer, Failure>>();
      when(
        () => transfers.confirmTransfer(
          transferId: any(named: 'transferId'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenAnswer((_) => completer.future);

      final container = await quoted();
      final notifier = container.read(transferFlowProvider.notifier);
      final first = notifier.confirm();
      await notifier.confirm(); // ignored — one already in flight

      completer.complete(Result.success(_transfer()));
      await first;

      verify(
        () => transfers.confirmTransfer(
          transferId: any(named: 'transferId'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).called(1);
    });

    test('a failed confirm keeps the quote so the user can retry', () async {
      when(
        () => transfers.confirmTransfer(
          transferId: any(named: 'transferId'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      ).thenAnswer((_) async => const Result.failure(TimeoutFailure()));

      final container = await quoted();
      final failure =
          await container.read(transferFlowProvider.notifier).confirm();

      expect(failure, isA<TimeoutFailure>());
      final state = container.read(transferFlowProvider);
      expect(state.step, TransferStep.review);
      expect(state.transfer, isNull);
      // Same quote, same key — a retry cannot become a second transfer.
      expect(state.quote?.idempotencyKey, 'idem_trf_1');
      expect(state.busy, isFalse);
    });

    test('confirming without a quote does nothing', () async {
      final container = await readyContainer();
      final failure =
          await container.read(transferFlowProvider.notifier).confirm();

      expect(failure, isNull);
      verifyNever(
        () => transfers.confirmTransfer(
          transferId: any(named: 'transferId'),
          idempotencyKey: any(named: 'idempotencyKey'),
        ),
      );
    });
  });

  group('TransferFlow — navigation', () {
    test('back walks the steps and stops at the start', () async {
      final container = await readyContainer();
      final notifier = container.read(transferFlowProvider.notifier)
        ..goTo(TransferStep.review)
        ..back();
      expect(container.read(transferFlowProvider).step, TransferStep.amount);

      notifier.back();
      expect(
        container.read(transferFlowProvider).step,
        TransferStep.recipient,
      );

      notifier.back();
      expect(
        container.read(transferFlowProvider).step,
        TransferStep.recipient,
      );
    });

    test('the receipt is terminal', () async {
      final container = await readyContainer();
      container.read(transferFlowProvider.notifier)
        ..goTo(TransferStep.receipt)
        ..back();

      expect(container.read(transferFlowProvider).step, TransferStep.receipt);
    });

    test('reset clears the draft', () async {
      when(() => transfers.createTransfer(any()))
          .thenAnswer((_) async => Result.success(_quote()));

      final container = await readyContainer();
      final notifier = container.read(transferFlowProvider.notifier)
        ..selectSource('acc_chk')
        ..selectDestination(const BeneficiaryDestination('ben_sara'))
        ..amountChanged('250.00');
      await notifier.requestQuote();
      notifier.reset();

      final state = container.read(transferFlowProvider);
      expect(state.step, TransferStep.recipient);
      expect(state.quote, isNull);
      expect(state.destination, isNull);
      expect(state.amount.value, '');
    });
  });

  group('BeneficiariesController', () {
    test('loads the payee list', () async {
      when(transfers.getBeneficiaries).thenAnswer(
        (_) async => Result.success([
          Beneficiary(
            id: 'ben_sara',
            name: 'Sara Malik',
            iban: _iban('JO85CABK0030000000000012009903'),
            bankName: 'Cairo Amman Bank',
            currency: Currency.usd,
          ),
        ]),
      );

      final container = makeContainer();
      final sub = container.listen(beneficiariesControllerProvider, (_, __) {});
      expect(sub.read().isLoading, isTrue);

      await settle();
      await settle();

      expect(sub.read().value?.single.name, 'Sara Malik');
    });

    test('a failure surfaces as an error state', () async {
      when(transfers.getBeneficiaries)
          .thenAnswer((_) async => const Result.failure(NetworkFailure()));

      final container = makeContainer();
      final sub = container.listen(beneficiariesControllerProvider, (_, __) {});
      await settle();
      await settle();

      expect(sub.read().hasError, isTrue);
    });
  });
}

Iban _iban(String value) => Iban.tryParse(value)!;
