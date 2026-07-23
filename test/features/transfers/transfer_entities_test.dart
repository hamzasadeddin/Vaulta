import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/transfers/data/models/transfer_dtos.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';

void main() {
  group('BeneficiariesDto.toDomain', () {
    test('maps a well-formed payee', () {
      final dto = BeneficiariesDto.fromJson(const {
        'beneficiaries': [
          {
            'id': 'ben_layla',
            'name': 'Layla Haddad',
            'iban': 'JO47ARAB0010000000000012009901',
            'bankName': 'Arab Bank',
            'currency': 'JOD',
          },
        ],
      });

      final payee = dto.toDomain().single;
      expect(payee.id, 'ben_layla');
      expect(payee.currency, Currency.jod);
      expect(payee.iban.tail, '9901');
      expect(payee.initials, 'LH');
    });

    test('drops payees the client cannot represent', () {
      // An unsupported currency and a failed mod-97 check are both
      // unsendable — they must not reach the picker as selectable rows.
      final dto = BeneficiariesDto.fromJson(const {
        'beneficiaries': [
          {
            'id': 'ben_bad_currency',
            'name': 'Someone',
            'iban': 'JO47ARAB0010000000000012009901',
            'bankName': 'Arab Bank',
            'currency': 'XYZ',
          },
          {
            'id': 'ben_bad_iban',
            'name': 'Someone Else',
            'iban': 'JO83VBNK0001000000000010204573',
            'bankName': 'Arab Bank',
            'currency': 'JOD',
          },
          {
            'id': 'ben_ok',
            'name': 'Sara Malik',
            'iban': 'JO85CABK0030000000000012009903',
            'bankName': 'Cairo Amman Bank',
            'currency': 'USD',
          },
        ],
      });

      expect(dto.toDomain().map((b) => b.id), ['ben_ok']);
    });

    test('a single-word name still yields initials', () {
      final dto = BeneficiaryDto.fromJson(const {
        'id': 'ben_x',
        'name': 'Meridian',
        'iban': 'JO86ETIH0040000000000012009904',
        'bankName': 'Etihad Bank',
        'currency': 'EUR',
      });
      expect(dto.toDomainOrNull()!.initials, 'M');
    });
  });

  group('TransferQuoteDto.toDomain', () {
    Map<String, dynamic> quoteJson({
      String currency = 'USD',
      String destinationCurrency = 'USD',
      int amountMinor = 25000,
      int feeMinor = 0,
      int destinationAmountMinor = 25000,
      String? rate,
      String? scheduledFor,
    }) =>
        {
          'id': 'trf_1',
          'idempotencyKey': 'idem_trf_1',
          'sourceAccountId': 'acc_chk',
          'destinationLabel': 'Savings',
          'destinationDetail': '\u2022\u2022\u2022\u2022 4574',
          'amountMinor': amountMinor,
          'currency': currency,
          'feeMinor': feeMinor,
          'totalDebitMinor': amountMinor + feeMinor,
          'destinationAmountMinor': destinationAmountMinor,
          'destinationCurrency': destinationCurrency,
          'rate': rate,
          'scheduledFor': scheduledFor,
        };

    test('same-currency quote carries no rate', () {
      final quote = TransferQuoteDto.fromJson(quoteJson()).toDomain();

      expect(quote.isCrossCurrency, isFalse);
      expect(quote.rate, isNull);
      expect(quote.amount, Money.parse('250.00', Currency.usd));
      expect(quote.totalDebit, Money.parse('250.00', Currency.usd));
      expect(quote.idempotencyKey, 'idem_trf_1');
    });

    test('cross-currency quote keeps an exact Decimal rate', () {
      final quote = TransferQuoteDto.fromJson(
        quoteJson(
          destinationCurrency: 'JOD',
          feeMinor: 125,
          destinationAmountMinor: 177250,
          rate: '0.709',
        ),
      ).toDomain();

      expect(quote.isCrossCurrency, isTrue);
      expect(quote.rate, Decimal.parse('0.709'));
      // The JOD canary: 3 minor digits, not 2.
      expect(
        quote.destinationAmount,
        Money.parse('177.250', Currency.jod),
      );
      expect(quote.fee, Money.parse('1.25', Currency.usd));
    });

    test('a scheduled quote parses its date', () {
      final quote = TransferQuoteDto.fromJson(
        quoteJson(scheduledFor: '2026-09-01T00:00:00.000'),
      ).toDomain();

      expect(quote.isScheduled, isTrue);
      expect(quote.scheduledFor, DateTime(2026, 9));
    });
  });

  group('TransferDto.toDomain', () {
    Map<String, dynamic> transferJson({
      String status = 'completed',
      int? balanceAfterMinor = 1223050,
    }) =>
        {
          'id': 'trf_1',
          'idempotencyKey': 'idem_trf_1',
          'reference': 'VLT-2026-123456',
          'status': status,
          'sourceAccountId': 'acc_chk',
          'destinationLabel': 'Savings',
          'destinationDetail': '\u2022\u2022\u2022\u2022 4574',
          'amountMinor': 25000,
          'currency': 'USD',
          'feeMinor': 0,
          'totalDebitMinor': 25000,
          'destinationAmountMinor': 25000,
          'destinationCurrency': 'USD',
          'createdAt': '2026-07-22T10:00:00.000',
          'balanceAfterMinor': balanceAfterMinor,
        };

    test('maps a settled transfer', () {
      final transfer = TransferDto.fromJson(transferJson()).toDomain();

      expect(transfer.status, TransferStatus.completed);
      expect(transfer.reference, 'VLT-2026-123456');
      expect(transfer.balanceAfter, Money.parse('12230.50', Currency.usd));
      expect(transfer.isScheduled, isFalse);
    });

    test('an unknown status degrades to pending, never completed', () {
      // Claiming success for a state we do not understand would tell the
      // user money arrived when it may not have.
      final transfer =
          TransferDto.fromJson(transferJson(status: 'settling')).toDomain();

      expect(transfer.status, TransferStatus.pending);
    });

    test('a pending transfer carries no balance', () {
      final transfer = TransferDto.fromJson(
        transferJson(status: 'pending', balanceAfterMinor: null),
      ).toDomain();

      expect(transfer.balanceAfter, isNull);
    });
  });

  group('TransferDestination', () {
    test('equality is structural', () {
      expect(
        const OwnAccountDestination('acc_sav'),
        const OwnAccountDestination('acc_sav'),
      );
      expect(
        const BeneficiaryDestination('ben_layla'),
        isNot(const OwnAccountDestination('ben_layla')),
      );
    });
  });

  group('TransferQuote price lock', () {
    final at = DateTime(2026, 7, 22, 10);

    TransferQuote quote({DateTime? expiresAt}) => TransferQuote(
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

    test('an unlocked quote never expires and has no countdown', () {
      final unlocked = quote();

      expect(unlocked.isLocked, isFalse);
      expect(unlocked.isExpiredAt(at.add(const Duration(days: 365))), isFalse);
      expect(unlocked.remainingAt(at), isNull);
    });

    test('the expiry instant itself counts as expired', () {
      final locked = quote(expiresAt: at);

      expect(
        locked.isExpiredAt(at.subtract(const Duration(seconds: 1))),
        isFalse,
      );
      expect(locked.isExpiredAt(at), isTrue);
      expect(locked.isExpiredAt(at.add(const Duration(seconds: 1))), isTrue);
    });

    test('remaining time floors at zero rather than going negative', () {
      final locked = quote(expiresAt: at.add(const Duration(seconds: 90)));

      expect(locked.remainingAt(at), const Duration(seconds: 90));
      expect(
        locked.remainingAt(at.add(const Duration(seconds: 89))),
        const Duration(seconds: 1),
      );
      expect(
        locked.remainingAt(at.add(const Duration(minutes: 5))),
        Duration.zero,
      );
    });
  });
}
