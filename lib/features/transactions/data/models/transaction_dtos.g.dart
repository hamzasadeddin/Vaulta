// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionsPageDto _$TransactionsPageDtoFromJson(Map<String, dynamic> json) =>
    _TransactionsPageDto(
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((e) => TransactionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TransactionDto>[],
      nextCursor: json['nextCursor'] as String?,
    );

Map<String, dynamic> _$TransactionsPageDtoToJson(
        _TransactionsPageDto instance) =>
    <String, dynamic>{
      'transactions': instance.transactions,
      'nextCursor': instance.nextCursor,
    };

_TransactionDto _$TransactionDtoFromJson(Map<String, dynamic> json) =>
    _TransactionDto(
      id: json['id'] as String,
      accountId: json['accountId'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      amountMinor: (json['amountMinor'] as num).toInt(),
      currency: json['currency'] as String,
      occurredAt: json['occurredAt'] as String,
      reference: json['reference'] as String,
      status: json['status'] as String? ?? 'completed',
      balanceAfterMinor: (json['balanceAfterMinor'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransactionDtoToJson(_TransactionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'title': instance.title,
      'category': instance.category,
      'amountMinor': instance.amountMinor,
      'currency': instance.currency,
      'occurredAt': instance.occurredAt,
      'reference': instance.reference,
      'status': instance.status,
      'balanceAfterMinor': instance.balanceAfterMinor,
    };

_DisputeReceiptDto _$DisputeReceiptDtoFromJson(Map<String, dynamic> json) =>
    _DisputeReceiptDto(
      disputeId: json['disputeId'] as String,
      transactionId: json['transactionId'] as String,
    );

Map<String, dynamic> _$DisputeReceiptDtoToJson(_DisputeReceiptDto instance) =>
    <String, dynamic>{
      'disputeId': instance.disputeId,
      'transactionId': instance.transactionId,
    };
