import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/iban/iban.dart';

void main() {
  // The account and beneficiary fixtures the mock serves — every one of
  // them must survive the client's own validator.
  const valid = [
    'JO82VBNK0001000000000010204573',
    'JO55VBNK0001000000000010204574',
    'JO73VBNK0002000000000010209981',
    'JO47ARAB0010000000000012009901',
    'JO71HBHO0020000000000012009902',
    'JO85CABK0030000000000012009903',
    'JO86ETIH0040000000000012009904',
  ];

  group('Iban.isValid', () {
    test('accepts every fixture IBAN', () {
      for (final iban in valid) {
        expect(Iban.isValid(iban), isTrue, reason: iban);
      }
    });

    test('accepts spaced and lowercase input', () {
      expect(Iban.isValid('jo82 vbnk 0001 0000 0000 0010 2045 73'), isTrue);
    });

    test('rejects a single transposed digit', () {
      // Same characters, two swapped — the classic typo mod-97 exists to
      // catch.
      expect(Iban.isValid('JO82VBNK0001000000000010204537'), isFalse);
    });

    test('rejects wrong check digits', () {
      expect(Iban.isValid('JO83VBNK0001000000000010204573'), isFalse);
    });

    test('rejects structurally malformed input', () {
      expect(Iban.isValid(''), isFalse);
      expect(Iban.isValid('JO82'), isFalse);
      expect(Iban.isValid('8282VBNK0001000000000010204573'), isFalse);
      expect(Iban.isValid('JOXXVBNK0001000000000010204573'), isFalse);
      expect(Iban.isValid('JO82VBNK000100000000001020457312345'), isFalse);
    });
  });

  group('Iban.tryParse', () {
    test('normalizes on the way in', () {
      final iban = Iban.tryParse('jo82 vbnk 0001 0000 0000 0010 2045 73');
      expect(iban, isNotNull);
      expect(iban!.value, 'JO82VBNK0001000000000010204573');
    });

    test('returns null for an invalid IBAN', () {
      expect(Iban.tryParse('JO83VBNK0001000000000010204573'), isNull);
    });

    test('an instance is proof of validity', () {
      // Construction is closed, so anything that is an Iban passed mod-97.
      final iban = Iban.tryParse(valid.first)!;
      expect(Iban.isValid(iban.value), isTrue);
    });
  });

  group('display', () {
    late Iban iban;

    setUp(() => iban = Iban.tryParse(valid.first)!);

    test('groups in fours', () {
      expect(iban.grouped, 'JO82 VBNK 0001 0000 0000 0010 2045 73');
    });

    test('exposes the tail and country', () {
      expect(iban.tail, '4573');
      expect(iban.countryCode, 'JO');
    });

    test('equality is by normalized value', () {
      expect(Iban.tryParse('jo82 vbnk 0001 0000 0000 0010 2045 73'), iban);
      expect(
        Iban.tryParse('jo82 vbnk 0001 0000 0000 0010 2045 73').hashCode,
        iban.hashCode,
      );
    });
  });
}
