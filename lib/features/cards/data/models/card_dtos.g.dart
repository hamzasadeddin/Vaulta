// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CardsDto _$CardsDtoFromJson(Map<String, dynamic> json) => _CardsDto(
      cards: (json['cards'] as List<dynamic>?)
              ?.map((e) => CardDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CardDto>[],
    );

Map<String, dynamic> _$CardsDtoToJson(_CardsDto instance) => <String, dynamic>{
      'cards': instance.cards,
    };

_CardDto _$CardDtoFromJson(Map<String, dynamic> json) => _CardDto(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      label: json['label'] as String,
      type: json['type'] as String,
      network: json['network'] as String,
      status: json['status'] as String,
      panLast4: json['panLast4'] as String,
      expiryMonth: (json['expiryMonth'] as num).toInt(),
      expiryYear: (json['expiryYear'] as num).toInt(),
      currency: json['currency'] as String,
      limits: CardLimitsDto.fromJson(json['limits'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CardDtoToJson(_CardDto instance) => <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'label': instance.label,
      'type': instance.type,
      'network': instance.network,
      'status': instance.status,
      'panLast4': instance.panLast4,
      'expiryMonth': instance.expiryMonth,
      'expiryYear': instance.expiryYear,
      'currency': instance.currency,
      'limits': instance.limits,
    };

_CardLimitsDto _$CardLimitsDtoFromJson(Map<String, dynamic> json) =>
    _CardLimitsDto(
      dailyMinor: (json['dailyMinor'] as num).toInt(),
      monthlyMinor: (json['monthlyMinor'] as num).toInt(),
      spentTodayMinor: (json['spentTodayMinor'] as num?)?.toInt() ?? 0,
      spentThisMonthMinor: (json['spentThisMonthMinor'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CardLimitsDtoToJson(_CardLimitsDto instance) =>
    <String, dynamic>{
      'dailyMinor': instance.dailyMinor,
      'monthlyMinor': instance.monthlyMinor,
      'spentTodayMinor': instance.spentTodayMinor,
      'spentThisMonthMinor': instance.spentThisMonthMinor,
    };
