// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BeneficiariesDto _$BeneficiariesDtoFromJson(Map<String, dynamic> json) =>
    _BeneficiariesDto(
      beneficiaries: (json['beneficiaries'] as List<dynamic>?)
              ?.map((e) => BeneficiaryDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <BeneficiaryDto>[],
    );

Map<String, dynamic> _$BeneficiariesDtoToJson(_BeneficiariesDto instance) =>
    <String, dynamic>{
      'beneficiaries': instance.beneficiaries,
    };

_BeneficiaryDto _$BeneficiaryDtoFromJson(Map<String, dynamic> json) =>
    _BeneficiaryDto(
      id: json['id'] as String,
      name: json['name'] as String,
      iban: json['iban'] as String,
      bankName: json['bankName'] as String,
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$BeneficiaryDtoToJson(_BeneficiaryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iban': instance.iban,
      'bankName': instance.bankName,
      'currency': instance.currency,
    };

_TransferQuoteDto _$TransferQuoteDtoFromJson(Map<String, dynamic> json) =>
    _TransferQuoteDto(
      id: json['id'] as String,
      idempotencyKey: json['idempotencyKey'] as String,
      sourceAccountId: json['sourceAccountId'] as String,
      destinationLabel: json['destinationLabel'] as String,
      destinationDetail: json['destinationDetail'] as String,
      amountMinor: (json['amountMinor'] as num).toInt(),
      currency: json['currency'] as String,
      feeMinor: (json['feeMinor'] as num).toInt(),
      totalDebitMinor: (json['totalDebitMinor'] as num).toInt(),
      destinationAmountMinor: (json['destinationAmountMinor'] as num).toInt(),
      destinationCurrency: json['destinationCurrency'] as String,
      rate: json['rate'] as String?,
      scheduledFor: json['scheduledFor'] as String?,
    );

Map<String, dynamic> _$TransferQuoteDtoToJson(_TransferQuoteDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idempotencyKey': instance.idempotencyKey,
      'sourceAccountId': instance.sourceAccountId,
      'destinationLabel': instance.destinationLabel,
      'destinationDetail': instance.destinationDetail,
      'amountMinor': instance.amountMinor,
      'currency': instance.currency,
      'feeMinor': instance.feeMinor,
      'totalDebitMinor': instance.totalDebitMinor,
      'destinationAmountMinor': instance.destinationAmountMinor,
      'destinationCurrency': instance.destinationCurrency,
      'rate': instance.rate,
      'scheduledFor': instance.scheduledFor,
    };

_TransferDto _$TransferDtoFromJson(Map<String, dynamic> json) => _TransferDto(
      id: json['id'] as String,
      reference: json['reference'] as String,
      status: json['status'] as String,
      sourceAccountId: json['sourceAccountId'] as String,
      destinationLabel: json['destinationLabel'] as String,
      destinationDetail: json['destinationDetail'] as String,
      amountMinor: (json['amountMinor'] as num).toInt(),
      currency: json['currency'] as String,
      feeMinor: (json['feeMinor'] as num).toInt(),
      totalDebitMinor: (json['totalDebitMinor'] as num).toInt(),
      destinationAmountMinor: (json['destinationAmountMinor'] as num).toInt(),
      destinationCurrency: json['destinationCurrency'] as String,
      createdAt: json['createdAt'] as String,
      rate: json['rate'] as String?,
      scheduledFor: json['scheduledFor'] as String?,
      balanceAfterMinor: (json['balanceAfterMinor'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransferDtoToJson(_TransferDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reference': instance.reference,
      'status': instance.status,
      'sourceAccountId': instance.sourceAccountId,
      'destinationLabel': instance.destinationLabel,
      'destinationDetail': instance.destinationDetail,
      'amountMinor': instance.amountMinor,
      'currency': instance.currency,
      'feeMinor': instance.feeMinor,
      'totalDebitMinor': instance.totalDebitMinor,
      'destinationAmountMinor': instance.destinationAmountMinor,
      'destinationCurrency': instance.destinationCurrency,
      'createdAt': instance.createdAt,
      'rate': instance.rate,
      'scheduledFor': instance.scheduledFor,
      'balanceAfterMinor': instance.balanceAfterMinor,
    };
