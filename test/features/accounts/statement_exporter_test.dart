import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/core/result/result.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/entities/statement.dart';
import 'package:vaulta/features/accounts/domain/repositories/accounts_repository.dart';
import 'package:vaulta/features/accounts/presentation/pdf/statement_exporter.dart';
import 'package:vaulta/features/accounts/presentation/pdf/statement_pdf_builder.dart';

class _MockAccountsRepository extends Mock implements AccountsRepository {}

final _account = Account(
  id: 'acc_chk',
  name: 'Main Checking',
  type: AccountType.checking,
  iban: 'JO82VBNK0001000000000010204573',
  balance: Money.parse('12480.50', Currency.usd),
  openedAt: DateTime(2022, 3, 14),
);

final _statement = Statement(
  id: 'stm_acc_chk_202605',
  accountId: 'acc_chk',
  periodStart: DateTime(2026, 5),
  periodEnd: DateTime(2026, 5, 31),
  opening: Money.parse('11000.00', Currency.usd),
  closing: Money.parse('12480.50', Currency.usd),
  transactionCount: 2,
);

final _detail = StatementDetail(
  statement: _statement,
  lines: [
    StatementLine(
      id: 'stl_1',
      title: 'Carrefour',
      amount: Money.parse('-86.20', Currency.usd),
      occurredAt: DateTime(2026, 5, 12, 10, 30),
    ),
  ],
);

/// A builder stub so exporter tests don't depend on font assets or real PDF
/// rendering — that path is covered by statement_pdf_builder_test.
class _StubPdfBuilder implements StatementPdfBuilder {
  const _StubPdfBuilder(this.bytes);

  final Uint8List bytes;

  @override
  Future<Uint8List> build({
    required Account account,
    required StatementDetail detail,
  }) async =>
      bytes;
}

class _ThrowingPdfBuilder implements StatementPdfBuilder {
  const _ThrowingPdfBuilder();

  @override
  Future<Uint8List> build({
    required Account account,
    required StatementDetail detail,
  }) async =>
      throw StateError('render failed');
}

void main() {
  late _MockAccountsRepository repository;

  setUp(() => repository = _MockAccountsRepository());

  test('fetches the detail, builds a PDF and shares it', () async {
    when(() => repository.getStatement(any(), any()))
        .thenAnswer((_) async => Result.success(_detail));

    Uint8List? shared;
    String? sharedName;
    final exporter = StatementExporter(
      repository: repository,
      builder: _StubPdfBuilder(Uint8List.fromList([1, 2, 3])),
      share: (bytes, filename) async {
        shared = bytes;
        sharedName = filename;
      },
    );

    final failure =
        await exporter.export(account: _account, statement: _statement);

    expect(failure, isNull);
    expect(shared, [1, 2, 3]);
    // slug from the account name + the statement's period month.
    expect(sharedName, 'vaulta-statement-main-checking-2026-05.pdf');
    verify(() => repository.getStatement('acc_chk', 'stm_acc_chk_202605'))
        .called(1);
  });

  test('returns the failure when the detail fetch fails, without sharing',
      () async {
    when(() => repository.getStatement(any(), any()))
        .thenAnswer((_) async => const Result.failure(NetworkFailure()));

    var shareCalls = 0;
    final exporter = StatementExporter(
      repository: repository,
      builder: _StubPdfBuilder(Uint8List(0)),
      share: (bytes, filename) async => shareCalls++,
    );

    final failure =
        await exporter.export(account: _account, statement: _statement);

    expect(failure, isA<NetworkFailure>());
    expect(shareCalls, 0, reason: 'nothing to share when the fetch failed');
  });

  test('wraps a rendering error as UnexpectedFailure', () async {
    when(() => repository.getStatement(any(), any()))
        .thenAnswer((_) async => Result.success(_detail));

    final exporter = StatementExporter(
      repository: repository,
      builder: const _ThrowingPdfBuilder(),
      share: (bytes, filename) async {},
    );

    final failure =
        await exporter.export(account: _account, statement: _statement);

    expect(failure, isA<UnexpectedFailure>());
  });

  test('wraps a share error as UnexpectedFailure', () async {
    when(() => repository.getStatement(any(), any()))
        .thenAnswer((_) async => Result.success(_detail));

    final exporter = StatementExporter(
      repository: repository,
      builder: _StubPdfBuilder(Uint8List.fromList([9])),
      share: (bytes, filename) async => throw StateError('share sheet failed'),
    );

    final failure =
        await exporter.export(account: _account, statement: _statement);

    expect(failure, isA<UnexpectedFailure>());
  });
}
