// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pot_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PotsDto _$PotsDtoFromJson(Map<String, dynamic> json) => _PotsDto(
      pots: (json['pots'] as List<dynamic>?)
              ?.map((e) => PotDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PotDto>[],
    );

Map<String, dynamic> _$PotsDtoToJson(_PotsDto instance) => <String, dynamic>{
      'pots': instance.pots,
    };

_PotDto _$PotDtoFromJson(Map<String, dynamic> json) => _PotDto(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      name: json['name'] as String,
      balanceMinor: (json['balanceMinor'] as num).toInt(),
      currency: json['currency'] as String,
      goalMinor: (json['goalMinor'] as num?)?.toInt(),
      roundUpsEnabled: json['roundUpsEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$PotDtoToJson(_PotDto instance) => <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'name': instance.name,
      'balanceMinor': instance.balanceMinor,
      'currency': instance.currency,
      'goalMinor': instance.goalMinor,
      'roundUpsEnabled': instance.roundUpsEnabled,
    };
