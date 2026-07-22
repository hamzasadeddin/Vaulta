import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vaulta/core/iban/iban.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/transfers/domain/entities/beneficiary.dart';
import 'package:vaulta/features/transfers/domain/entities/transfer.dart';

part 'transfer_dtos.freezed.dart';
part 'transfer_dtos.g.dart';

/// Wire shapes for `/beneficiaries` and `/transfers*`.
///
/// Money travels as integer minor units plus an ISO code and becomes
/// [Money] exactly once, in `toDomain()`. An FX **rate** is not money, so
/// it travels as a decimal *string* and parses to [Decimal] — a `double`
/// would silently round a multiplier applied to a balance.

@freezed
abstract class BeneficiariesDto with _$BeneficiariesDto {
  const factory BeneficiariesDto({
    @Default(<BeneficiaryDto>[]) List<BeneficiaryDto> beneficiaries,
  }) = _BeneficiariesDto;

  const BeneficiariesDto._();

  factory BeneficiariesDto.fromJson(Map<String, dynamic> json) =>
      _$BeneficiariesDtoFromJson(json);

  /// Rows the client cannot faithfully represent are dropped, not
  /// coerced: a payee whose currency is unsupported or whose IBAN fails
  /// mod-97 would otherwise become a destination the user could select
  /// and never successfully send to.
  List<Beneficiary> toDomain() => [
        for (final dto in beneficiaries)
          if (dto.toDomainOrNull() case final beneficiary?) beneficiary,
      ];
}

@freezed
abstract class BeneficiaryDto with _$BeneficiaryDto {
  const factory BeneficiaryDto({
    required String id,
    required String name,
    required String iban,
    required String bankName,
    required String currency,
  }) = _BeneficiaryDto;

  const BeneficiaryDto._();

  factory BeneficiaryDto.fromJson(Map<String, dynamic> json) =>
      _$BeneficiaryDtoFromJson(json);

  Beneficiary? toDomainOrNull() {
    final resolvedCurrency = Currency.tryFromCode(currency);
    final resolvedIban = Iban.tryParse(iban);
    if (resolvedCurrency == null || resolvedIban == null) return null;
    return Beneficiary(
      id: id,
      name: name,
      iban: resolvedIban,
      bankName: bankName,
      currency: resolvedCurrency,
    );
  }
}

@freezed
abstract class TransferQuoteDto with _$TransferQuoteDto {
  const factory TransferQuoteDto({
    required String id,
    required String idempotencyKey,
    required String sourceAccountId,
    required String destinationLabel,
    required String destinationDetail,
    required int amountMinor,
    required String currency,
    required int feeMinor,
    required int totalDebitMinor,
    required int destinationAmountMinor,
    required String destinationCurrency,
    String? rate,
    String? scheduledFor,
  }) = _TransferQuoteDto;

  const TransferQuoteDto._();

  factory TransferQuoteDto.fromJson(Map<String, dynamic> json) =>
      _$TransferQuoteDtoFromJson(json);

  TransferQuote toDomain() {
    final source = Currency.fromCode(currency);
    final destination = Currency.fromCode(destinationCurrency);
    return TransferQuote(
      id: id,
      idempotencyKey: idempotencyKey,
      sourceAccountId: sourceAccountId,
      destinationLabel: destinationLabel,
      destinationDetail: destinationDetail,
      amount: Money.fromMinorUnits(BigInt.from(amountMinor), source),
      fee: Money.fromMinorUnits(BigInt.from(feeMinor), source),
      totalDebit: Money.fromMinorUnits(BigInt.from(totalDebitMinor), source),
      destinationAmount: Money.fromMinorUnits(
        BigInt.from(destinationAmountMinor),
        destination,
      ),
      rate: rate == null ? null : Decimal.tryParse(rate!),
      scheduledFor:
          scheduledFor == null ? null : DateTime.tryParse(scheduledFor!),
    );
  }
}

@freezed
abstract class TransferDto with _$TransferDto {
  const factory TransferDto({
    required String id,
    required String reference,
    required String status,
    required String sourceAccountId,
    required String destinationLabel,
    required String destinationDetail,
    required int amountMinor,
    required String currency,
    required int feeMinor,
    required int totalDebitMinor,
    required int destinationAmountMinor,
    required String destinationCurrency,
    required String createdAt,
    String? rate,
    String? scheduledFor,
    int? balanceAfterMinor,
  }) = _TransferDto;

  const TransferDto._();

  factory TransferDto.fromJson(Map<String, dynamic> json) =>
      _$TransferDtoFromJson(json);

  Transfer toDomain() {
    final source = Currency.fromCode(currency);
    final destination = Currency.fromCode(destinationCurrency);
    final settledBalance = balanceAfterMinor;
    return Transfer(
      id: id,
      reference: reference,
      // Unknown statuses degrade to `pending` — see the enum's doc for
      // why that is the only safe direction on a money movement.
      status:
          TransferStatus.values.asNameMap()[status] ?? TransferStatus.pending,
      sourceAccountId: sourceAccountId,
      destinationLabel: destinationLabel,
      destinationDetail: destinationDetail,
      amount: Money.fromMinorUnits(BigInt.from(amountMinor), source),
      fee: Money.fromMinorUnits(BigInt.from(feeMinor), source),
      totalDebit: Money.fromMinorUnits(BigInt.from(totalDebitMinor), source),
      destinationAmount: Money.fromMinorUnits(
        BigInt.from(destinationAmountMinor),
        destination,
      ),
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      rate: rate == null ? null : Decimal.tryParse(rate!),
      scheduledFor:
          scheduledFor == null ? null : DateTime.tryParse(scheduledFor!),
      balanceAfter: settledBalance == null
          ? null
          : Money.fromMinorUnits(BigInt.from(settledBalance), source),
    );
  }
}
