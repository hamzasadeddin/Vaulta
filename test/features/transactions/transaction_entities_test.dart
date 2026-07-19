import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/transactions/data/models/transaction_dtos.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction_filter.dart';

void main() {
  group('TransactionFilter', () {
    test('value equality across all dimensions', () {
      const a = TransactionFilter(
        accountId: 'acc_chk',
        category: TransactionCategory.dining,
        status: TransactionStatus.pending,
        query: 'fig',
      );
      const b = TransactionFilter(
        accountId: 'acc_chk',
        category: TransactionCategory.dining,
        status: TransactionStatus.pending,
        query: 'fig',
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(const TransactionFilter(accountId: 'acc_chk')));
    });

    test('isActive ignores whitespace-only queries', () {
      expect(const TransactionFilter().isActive, isFalse);
      expect(const TransactionFilter(query: '   ').isActive, isFalse);
      expect(const TransactionFilter(query: ' fig ').isActive, isTrue);
      expect(
        const TransactionFilter(status: TransactionStatus.failed).isActive,
        isTrue,
      );
    });
  });

  group('TransactionsPage', () {
    test('hasMore follows the cursor', () {
      const empty = TransactionsPage(items: [], nextCursor: null);
      const more = TransactionsPage(items: [], nextCursor: 'abc');
      expect(empty.hasMore, isFalse);
      expect(more.hasMore, isTrue);
    });
  });

  group('TransactionDto.toDomain', () {
    const dto = TransactionDto(
      id: 'txn_1',
      accountId: 'acc_jod',
      title: 'Zain',
      category: 'utilities',
      amountMinor: -24500,
      currency: 'JOD',
      occurredAt: '2026-07-14T13:20:00.000',
      reference: 'VLT-2026-123456',
      balanceAfterMinor: 3415750,
    );

    test('maps money as exact minor units (JOD, 3 digits — the canary)', () {
      final txn = dto.toDomain();
      expect(txn.amount, Money.parse('-24.500', Currency.jod));
      expect(txn.balanceAfter, Money.parse('3415.750', Currency.jod));
      expect(txn.status, TransactionStatus.completed);
      expect(txn.category, TransactionCategory.utilities);
      expect(txn.reference, 'VLT-2026-123456');
      expect(txn.isCredit, isFalse);
    });

    test('a missing balance stays null (unsettled entries)', () {
      const pending = TransactionDto(
        id: 'txn_2',
        accountId: 'acc_chk',
        title: 'Blue Fig',
        category: 'dining',
        amountMinor: -475,
        currency: 'USD',
        occurredAt: '2026-07-19T10:24:00.000',
        reference: 'VLT-2026-000001',
        status: 'pending',
      );
      final txn = pending.toDomain();
      expect(txn.balanceAfter, isNull);
      expect(txn.isPending, isTrue);
    });

    test('unknown category and status degrade instead of throwing', () {
      const unknown = TransactionDto(
        id: 'txn_3',
        accountId: 'acc_chk',
        title: 'Mystery',
        category: 'crypto',
        amountMinor: -100,
        currency: 'USD',
        occurredAt: '2026-07-01T09:00:00.000',
        reference: 'VLT-2026-000002',
        status: 'reversed',
      );
      final txn = unknown.toDomain();
      expect(txn.category, TransactionCategory.other);
      expect(txn.status, TransactionStatus.completed);
    });
  });

  group('TransactionsPageDto.toDomain', () {
    test('carries the cursor through and maps every item', () {
      const dto = TransactionsPageDto(
        transactions: [
          TransactionDto(
            id: 'txn_1',
            accountId: 'acc_chk',
            title: 'Careem',
            category: 'transport',
            amountMinor: -1250,
            currency: 'USD',
            occurredAt: '2026-07-19T07:41:00.000',
            reference: 'VLT-2026-000003',
          ),
        ],
        nextCursor: 'cursor-token',
      );
      final page = dto.toDomain();
      expect(page.items, hasLength(1));
      expect(page.items.single.title, 'Careem');
      expect(page.nextCursor, 'cursor-token');
      expect(page.hasMore, isTrue);
    });
  });

  group('DisputeReceiptDto.toDomain', () {
    test('maps the acknowledgement', () {
      const dto = DisputeReceiptDto(
        disputeId: 'dsp_9',
        transactionId: 'txn_101',
      );
      expect(
        dto.toDomain(),
        const DisputeReceipt(id: 'dsp_9', transactionId: 'txn_101'),
      );
    });
  });
}
