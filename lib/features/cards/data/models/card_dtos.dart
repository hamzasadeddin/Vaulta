import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/cards/domain/entities/bank_card.dart';

part 'card_dtos.freezed.dart';
part 'card_dtos.g.dart';

/// Wire shapes for `/cards*`. Money travels as integer minor units plus an
/// ISO code and becomes [Money] exactly once, in `toDomain()`.

@freezed
abstract class CardsDto with _$CardsDto {
  const factory CardsDto({
    @Default(<CardDto>[]) List<CardDto> cards,
  }) = _CardsDto;

  const CardsDto._();

  factory CardsDto.fromJson(Map<String, dynamic> json) =>
      _$CardsDtoFromJson(json);

  List<BankCard> toDomain() => [for (final card in cards) card.toDomain()];
}

@freezed
abstract class CardDto with _$CardDto {
  const factory CardDto({
    required String id,
    required String accountId,
    required String label,
    required String type,
    required String network,
    required String status,
    required String panLast4,
    required int expiryMonth,
    required int expiryYear,
    required String currency,
    required CardLimitsDto limits,
  }) = _CardDto;

  const CardDto._();

  factory CardDto.fromJson(Map<String, dynamic> json) =>
      _$CardDtoFromJson(json);

  BankCard toDomain() {
    final resolved = Currency.fromCode(currency);
    return BankCard(
      id: id,
      accountId: accountId,
      label: label,
      // Unknown enum values degrade, never throw. Two of these degrades
      // are risk decisions, not conveniences: an unrecognized *status*
      // fails closed to frozen (treating an unknown card state as active
      // would be the wrong direction on a payment instrument), and an
      // unrecognized *network* becomes `unknown` rather than borrowing a
      // scheme it isn't.
      type: CardType.values.asNameMap()[type] ?? CardType.physical,
      network: CardNetwork.values.asNameMap()[network] ?? CardNetwork.unknown,
      status: CardStatus.values.asNameMap()[status] ?? CardStatus.frozen,
      panLast4: panLast4,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      limits: limits.toDomain(resolved),
    );
  }
}

@freezed
abstract class CardLimitsDto with _$CardLimitsDto {
  const factory CardLimitsDto({
    required int dailyMinor,
    required int monthlyMinor,
    @Default(0) int spentTodayMinor,
    @Default(0) int spentThisMonthMinor,
  }) = _CardLimitsDto;

  const CardLimitsDto._();

  factory CardLimitsDto.fromJson(Map<String, dynamic> json) =>
      _$CardLimitsDtoFromJson(json);

  CardLimits toDomain(Currency currency) {
    return CardLimits(
      daily: Money.fromMinorUnits(BigInt.from(dailyMinor), currency),
      monthly: Money.fromMinorUnits(BigInt.from(monthlyMinor), currency),
      spentToday: Money.fromMinorUnits(BigInt.from(spentTodayMinor), currency),
      spentThisMonth:
          Money.fromMinorUnits(BigInt.from(spentThisMonthMinor), currency),
    );
  }
}

/// Deliberately NOT freezed, unlike every other DTO in the codebase: the
/// generated `toString` would happily print the PAN and CVV into any log,
/// error report, or test failure that stringifies the object. Hand-rolling
/// the class keeps `toString` masked and the blast radius of a stray
/// `print(dto)` at zero.
class CardPanDto {
  const CardPanDto({
    required this.pan,
    required this.cvv,
    required this.expiryMonth,
    required this.expiryYear,
  });

  factory CardPanDto.fromJson(Map<String, dynamic> json) {
    return CardPanDto(
      pan: json['pan'] as String? ?? '',
      cvv: json['cvv'] as String? ?? '',
      expiryMonth: (json['expiryMonth'] as num?)?.toInt() ?? 0,
      expiryYear: (json['expiryYear'] as num?)?.toInt() ?? 0,
    );
  }

  final String pan;
  final String cvv;
  final int expiryMonth;
  final int expiryYear;

  CardPan toDomain() => CardPan(
        pan: pan,
        cvv: cvv,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
      );

  @override
  String toString() {
    final tail = pan.length < 4 ? '????' : pan.substring(pan.length - 4);
    return 'CardPanDto(\u2022\u2022\u2022\u2022 $tail)';
  }
}
