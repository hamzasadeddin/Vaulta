// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardSummaryDto _$DashboardSummaryDtoFromJson(Map<String, dynamic> json) =>
    _DashboardSummaryDto(
      accounts: (json['accounts'] as List<dynamic>)
          .map((e) => AccountSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentTransactions: (json['recentTransactions'] as List<dynamic>?)
              ?.map((e) => TransactionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TransactionDto>[],
    );

Map<String, dynamic> _$DashboardSummaryDtoToJson(
        _DashboardSummaryDto instance) =>
    <String, dynamic>{
      'accounts': instance.accounts,
      'recentTransactions': instance.recentTransactions,
    };

_AccountSummaryDto _$AccountSummaryDtoFromJson(Map<String, dynamic> json) =>
    _AccountSummaryDto(
      id: json['id'] as String,
      name: json['name'] as String,
      currency: json['currency'] as String,
      balanceMinor: (json['balanceMinor'] as num).toInt(),
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => BalancePointDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <BalancePointDto>[],
    );

Map<String, dynamic> _$AccountSummaryDtoToJson(_AccountSummaryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'currency': instance.currency,
      'balanceMinor': instance.balanceMinor,
      'history': instance.history,
    };

_BalancePointDto _$BalancePointDtoFromJson(Map<String, dynamic> json) =>
    _BalancePointDto(
      date: json['date'] as String,
      balanceMinor: (json['balanceMinor'] as num).toInt(),
    );

Map<String, dynamic> _$BalancePointDtoToJson(_BalancePointDto instance) =>
    <String, dynamic>{
      'date': instance.date,
      'balanceMinor': instance.balanceMinor,
    };

_TransactionDto _$TransactionDtoFromJson(Map<String, dynamic> json) =>
    _TransactionDto(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      title: json['title'] as String,
      amountMinor: (json['amountMinor'] as num).toInt(),
      currency: json['currency'] as String,
      occurredAt: json['occurredAt'] as String,
      category: json['category'] as String? ?? 'other',
      status: json['status'] as String? ?? 'completed',
    );

Map<String, dynamic> _$TransactionDtoToJson(_TransactionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'title': instance.title,
      'amountMinor': instance.amountMinor,
      'currency': instance.currency,
      'occurredAt': instance.occurredAt,
      'category': instance.category,
      'status': instance.status,
    };
