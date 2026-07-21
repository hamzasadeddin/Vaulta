import 'package:flutter_test/flutter_test.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/cards/domain/entities/bank_card.dart';

CardLimits _limits() => CardLimits(
      daily: Money.parse('500.00', Currency.usd),
      monthly: Money.parse('12000.00', Currency.usd),
      spentToday: Money.parse('120.00', Currency.usd),
      spentThisMonth: Money.parse('3400.00', Currency.usd),
    );

BankCard _card({CardStatus status = CardStatus.active}) => BankCard(
      id: 'crd_1',
      accountId: 'acc_chk',
      label: 'Everyday',
      type: CardType.physical,
      network: CardNetwork.visa,
      status: status,
      panLast4: '4242',
      expiryMonth: 9,
      expiryYear: 2028,
      limits: _limits(),
    );

void main() {
  group('BankCard', () {
    test('expiryLabel is zero-padded MM/YY', () {
      expect(_card().expiryLabel, '09/28');
      final march = BankCard(
        id: 'c',
        accountId: 'a',
        label: 'l',
        type: CardType.virtual,
        network: CardNetwork.mastercard,
        status: CardStatus.active,
        panLast4: '1111',
        expiryMonth: 3,
        expiryYear: 2031,
        limits: _limits(),
      );
      expect(march.expiryLabel, '03/31');
    });

    test('isFrozen reflects status', () {
      expect(_card().isFrozen, isFalse);
      expect(_card(status: CardStatus.frozen).isFrozen, isTrue);
    });

    test('copyWith touches only status and limits', () {
      final frozen = _card().copyWith(status: CardStatus.frozen);
      expect(frozen.isFrozen, isTrue);
      expect(frozen.id, 'crd_1');
      expect(frozen.panLast4, '4242');
      expect(frozen.limits, _card().limits);
    });

    test('value equality', () {
      expect(_card(), _card());
      expect(_card(), isNot(_card(status: CardStatus.frozen)));
    });
  });

  group('CardPan', () {
    const pan = CardPan(
      pan: '4242424242424242',
      cvv: '123',
      expiryMonth: 9,
      expiryYear: 2028,
    );

    test('grouped inserts a space every four digits', () {
      expect(pan.grouped, '4242 4242 4242 4242');
    });

    test('toString masks everything but the last four digits', () {
      final text = pan.toString();
      expect(text.contains('4242424242424242'), isFalse);
      expect(text.contains('123'), isFalse);
      expect(text.contains('4242'), isTrue);
    });

    test('value equality', () {
      expect(
        pan,
        const CardPan(
          pan: '4242424242424242',
          cvv: '123',
          expiryMonth: 9,
          expiryYear: 2028,
        ),
      );
    });
  });
}
