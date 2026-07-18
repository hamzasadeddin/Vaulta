// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountsResponseDto _$AccountsResponseDtoFromJson(Map<String, dynamic> json) =>
    _AccountsResponseDto(
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map((e) => AccountDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AccountDto>[],
    );

Map<String, dynamic> _$AccountsResponseDtoToJson(
        _AccountsResponseDto instance) =>
    <String, dynamic>{
      'accounts': instance.accounts,
    };

_AccountDto _$AccountDtoFromJson(Map<String, dynamic> json) => _AccountDto(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      iban: json['iban'] as String,
      currency: json['currency'] as String,
      balanceMinor: (json['balanceMinor'] as num).toInt(),
      openedAt: json['openedAt'] as String,
    );

Map<String, dynamic> _$AccountDtoToJson(_AccountDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'iban': instance.iban,
      'currency': instance.currency,
      'balanceMinor': instance.balanceMinor,
      'openedAt': instance.openedAt,
    };

_AccountHistoryDto _$AccountHistoryDtoFromJson(Map<String, dynamic> json) =>
    _AccountHistoryDto(
      accountId: json['accountId'] as String,
      currency: json['currency'] as String,
      points: (json['points'] as List<dynamic>?)
              ?.map((e) => HistoryPointDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <HistoryPointDto>[],
    );

Map<String, dynamic> _$AccountHistoryDtoToJson(_AccountHistoryDto instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'currency': instance.currency,
      'points': instance.points,
    };

_HistoryPointDto _$HistoryPointDtoFromJson(Map<String, dynamic> json) =>
    _HistoryPointDto(
      date: json['date'] as String,
      balanceMinor: (json['balanceMinor'] as num).toInt(),
    );

Map<String, dynamic> _$HistoryPointDtoToJson(_HistoryPointDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'balanceMinor': instance.balanceMinor,
    };

_StatementsResponseDto _$StatementsResponseDtoFromJson(
        Map<String, dynamic> json) =>
    _StatementsResponseDto(
      statements: (json['statements'] as List<dynamic>?)
              ?.map((e) => StatementDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <StatementDto>[],
    );

Map<String, dynamic> _$StatementsResponseDtoToJson(
        _StatementsResponseDto instance) =>
    <String, dynamic>{
      'statements': instance.statements,
    };

_StatementDto _$StatementDtoFromJson(Map<String, dynamic> json) =>
    _StatementDto(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      periodStart: json['periodStart'] as String,
      periodEnd: json['periodEnd'] as String,
      currency: json['currency'] as String,
      openingBalanceMinor: (json['openingBalanceMinor'] as num).toInt(),
      closingBalanceMinor: (json['closingBalanceMinor'] as num).toInt(),
      transactionCount: (json['transactionCount'] as num).toInt(),
    );

Map<String, dynamic> _$StatementDtoToJson(_StatementDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'periodStart': instance.periodStart,
      'periodEnd': instance.periodEnd,
      'currency': instance.currency,
      'openingBalanceMinor': instance.openingBalanceMinor,
      'closingBalanceMinor': instance.closingBalanceMinor,
      'transactionCount': instance.transactionCount,
    };

_StatementDetailDto _$StatementDetailDtoFromJson(Map<String, dynamic> json) =>
    _StatementDetailDto(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      periodStart: json['periodStart'] as String,
      periodEnd: json['periodEnd'] as String,
      currency: json['currency'] as String,
      openingBalanceMinor: (json['openingBalanceMinor'] as num).toInt(),
      closingBalanceMinor: (json['closingBalanceMinor'] as num).toInt(),
      transactionCount: (json['transactionCount'] as num).toInt(),
      lines: (json['lines'] as List<dynamic>?)
              ?.map((e) => StatementLineDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <StatementLineDto>[],
    );

Map<String, dynamic> _$StatementDetailDtoToJson(_StatementDetailDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'periodStart': instance.periodStart,
      'periodEnd': instance.periodEnd,
      'currency': instance.currency,
      'openingBalanceMinor': instance.openingBalanceMinor,
      'closingBalanceMinor': instance.closingBalanceMinor,
      'transactionCount': instance.transactionCount,
      'lines': instance.lines,
    };

_StatementLineDto _$StatementLineDtoFromJson(Map<String, dynamic> json) =>
    _StatementLineDto(
      id: json['id'] as String,
      title: json['title'] as String,
      amountMinor: (json['amountMinor'] as num).toInt(),
      occurredAt: json['occurredAt'] as String,
    );

Map<String, dynamic> _$StatementLineDtoToJson(_StatementLineDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'amountMinor': instance.amountMinor,
      'occurredAt': instance.occurredAt,
    };
