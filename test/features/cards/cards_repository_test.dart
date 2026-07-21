import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vaulta/core/error/failure.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/cards/data/datasources/cards_remote_data_source.dart';
import 'package:vaulta/features/cards/data/models/card_dtos.dart';
import 'package:vaulta/features/cards/data/repositories/cards_repository_impl.dart';
import 'package:vaulta/features/cards/domain/entities/bank_card.dart';

class _MockRemote extends Mock implements CardsRemoteDataSource {}

Map<String, dynamic> _cardJson({
  String type = 'physical',
  String network = 'visa',
  String status = 'active',
  String currency = 'USD',
}) {
  return {
    'id': 'crd_1',
    'accountId': 'acc_chk',
    'label': 'Everyday',
    'type': type,
    'network': network,
    'status': status,
    'panLast4': '4242',
    'expiryMonth': 9,
    'expiryYear': 2028,
    'currency': currency,
    'limits': {
      'dailyMinor': 50000,
      'monthlyMinor': 1200000,
      'spentTodayMinor': 12000,
      'spentThisMonthMinor': 340000,
    },
  };
}

void main() {
  group('CardDto.toDomain', () {
    test('maps minor units to Money under the card currency', () {
      final card = CardDto.fromJson(_cardJson()).toDomain();
      expect(card.limits.daily, Money.parse('500.00', Currency.usd));
      expect(card.limits.monthly, Money.parse('12000.00', Currency.usd));
      expect(card.limits.spentToday, Money.parse('120.00', Currency.usd));
      expect(card.panLast4, '4242');
      expect(card.type, CardType.physical);
      expect(card.network, CardNetwork.visa);
      expect(card.status, CardStatus.active);
    });

    test('JOD card keeps three minor-unit digits (the canary)', () {
      final card = CardDto.fromJson(
        _cardJson(currency: 'JOD')
          ..['limits'] = {
            'dailyMinor': 150000,
            'monthlyMinor': 2500000,
            'spentTodayMinor': 0,
            'spentThisMonthMinor': 0,
          },
      ).toDomain();
      expect(card.limits.daily, Money.parse('150.000', Currency.jod));
      expect(card.limits.daily.currency.minorUnitDigits, 3);
    });

    test('unknown type and network degrade without throwing', () {
      final card = CardDto.fromJson(_cardJson(type: 'metal', network: 'amex'))
          .toDomain();
      expect(card.type, CardType.physical);
      expect(card.network, CardNetwork.unknown);
    });

    test('unknown status fails closed to frozen', () {
      final card = CardDto.fromJson(_cardJson(status: 'suspended')).toDomain();
      expect(card.status, CardStatus.frozen);
    });
  });

  group('CardPanDto', () {
    test('toString never leaks the PAN or CVV', () {
      final dto = CardPanDto.fromJson({
        'pan': '4242424242424242',
        'cvv': '321',
        'expiryMonth': 9,
        'expiryYear': 2028,
      });
      final text = dto.toString();
      expect(text.contains('4242424242424242'), isFalse);
      expect(text.contains('321'), isFalse);
    });
  });

  group('CardsRepositoryImpl', () {
    late _MockRemote remote;
    late CardsRepositoryImpl repository;

    setUp(() {
      remote = _MockRemote();
      repository = CardsRepositoryImpl(remote: remote);
    });

    test('getCards maps the wire list to domain', () async {
      when(remote.cards).thenAnswer(
        (_) async => CardsDto.fromJson({
          'cards': [_cardJson()],
        }),
      );

      final result = await repository.getCards();
      expect(result.valueOrNull?.single.label, 'Everyday');
    });

    test('updateCardLimits sends minor units to the wire', () async {
      when(
        () => remote.updateLimits(
          cardId: any(named: 'cardId'),
          dailyMinor: any(named: 'dailyMinor'),
          monthlyMinor: any(named: 'monthlyMinor'),
        ),
      ).thenAnswer((_) async => CardDto.fromJson(_cardJson()));

      await repository.updateCardLimits(
        cardId: 'crd_1',
        daily: Money.parse('500.00', Currency.usd),
        monthly: Money.parse('12000.00', Currency.usd),
      );

      verify(
        () => remote.updateLimits(
          cardId: 'crd_1',
          dailyMinor: 50000,
          monthlyMinor: 1200000,
        ),
      ).called(1);
    });

    test('a DioException becomes a Failure, never thrown', () async {
      when(remote.cards).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/cards'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.getCards();
      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<NetworkFailure>());
    });

    test('revealPan returns the domain PAN on success', () async {
      when(() => remote.revealPan('crd_1')).thenAnswer(
        (_) async => const CardPanDto(
          pan: '4242424242424242',
          cvv: '123',
          expiryMonth: 9,
          expiryYear: 2028,
        ),
      );

      final result = await repository.revealPan('crd_1');
      expect(result.valueOrNull?.grouped, '4242 4242 4242 4242');
    });
  });
}
