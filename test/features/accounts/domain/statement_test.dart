import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/accounts/domain/entities/statement.dart';

void main() {
  final start = DateTime(2026);

  Statement statement({Money? opening, Money? closing}) => Statement(
        id: 's1',
        accountId: 'acc_chk',
        periodStart: start,
        periodEnd: DateTime(2026, 2),
        opening: opening ?? Money.parse('100.00', Currency.usd),
        closing: closing ?? Money.parse('150.00', Currency.usd),
        transactionCount: 4,
      );

  group('Statement', () {
    test('netChange is closing minus opening', () {
      expect(statement().netChange, Money.parse('50.00', Currency.usd));
      expect(
        statement(
          opening: Money.parse('150.00', Currency.usd),
          closing: Money.parse('100.00', Currency.usd),
        ).netChange,
        Money.parse('-50.00', Currency.usd),
      );
    });

    test('value equality holds field-by-field', () {
      expect(statement(), statement());
      expect(statement().hashCode, statement().hashCode);
      expect(
        statement(),
        isNot(statement(closing: Money.parse('200.00', Currency.usd))),
      );
    });
  });

  group('StatementLine', () {
    StatementLine line({String id = 'l1'}) => StatementLine(
          id: id,
          title: 'Coffee',
          amount: Money.parse('-4.50', Currency.usd),
          occurredAt: DateTime(2026, 1, 5),
        );

    test('value equality holds field-by-field', () {
      expect(line(), line());
      expect(line().hashCode, line().hashCode);
      expect(line(), isNot(line(id: 'l2')));
    });
  });

  test('StatementDetail carries a statement and its lines', () {
    final detail = StatementDetail(
      statement: statement(),
      lines: [
        StatementLine(
          id: 'l1',
          title: 'Opening',
          amount: Money.parse('1.00', Currency.usd),
          occurredAt: start,
        ),
      ],
    );
    expect(detail.statement.id, 's1');
    expect(detail.lines, hasLength(1));
  });
}
