import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/entities/statement.dart';
import 'package:vaulta/features/accounts/presentation/pdf/statement_pdf_builder.dart';

/// Smoke test: the builder loads the bundled Inter faces (flutter_test
/// serves declared assets to `rootBundle`) and produces a valid PDF byte
/// stream. Visual QA of the layout stays manual — pixel-diffing PDFs
/// buys little at this stage.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final account = Account(
    id: 'acc_chk',
    name: 'Main Checking',
    type: AccountType.checking,
    iban: 'JO82VBNK0001000000000010204573',
    balance: Money.parse('12480.50', Currency.usd),
    openedAt: DateTime(2022, 3, 14),
  );

  final detail = StatementDetail(
    statement: Statement(
      id: 'stm_acc_chk_202606',
      accountId: 'acc_chk',
      periodStart: DateTime(2026, 6),
      periodEnd: DateTime(2026, 6, 30),
      opening: Money.parse('11000.00', Currency.usd),
      closing: Money.parse('12480.50', Currency.usd),
      transactionCount: 3,
    ),
    lines: [
      StatementLine(
        id: 'stl_1',
        title: 'Carrefour',
        amount: Money.parse('-86.20', Currency.usd),
        occurredAt: DateTime(2026, 6, 3, 18, 40),
      ),
      StatementLine(
        id: 'stl_2',
        title: 'Salary \u2014 Vaulta Labs',
        amount: Money.parse('4250.00', Currency.usd),
        occurredAt: DateTime(2026, 6, 27, 9),
      ),
      StatementLine(
        id: 'stl_3',
        title: 'Blue Fig Caf\u00e9',
        amount: Money.parse('-4.75', Currency.usd),
        occurredAt: DateTime(2026, 6, 29, 8, 15),
      ),
    ],
  );

  test('renders a statement to valid PDF bytes', () async {
    final bytes = await const StatementPdfBuilder().build(
      account: account,
      detail: detail,
    );

    expect(bytes, isNotEmpty);
    // '%PDF' magic number.
    expect(bytes.sublist(0, 4), [0x25, 0x50, 0x44, 0x46]);
  });

  test('renders an empty statement (no lines) without throwing', () async {
    final bytes = await const StatementPdfBuilder().build(
      account: account,
      detail: StatementDetail(statement: detail.statement, lines: const []),
    );

    expect(bytes.sublist(0, 4), [0x25, 0x50, 0x44, 0x46]);
  });
}
