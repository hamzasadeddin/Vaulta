import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/transactions/domain/entities/transaction.dart';

part 'transaction_dtos.freezed.dart';
part 'transaction_dtos.g.dart';

/// Wire shapes for `/transactions*`. Money travels as integer minor units
/// plus an ISO code and becomes [Money] exactly once, in `toDomain()` —
/// API shape never leaks past this file.

@freezed
abstract class TransactionsPageDto with _$TransactionsPageDto {
  const factory TransactionsPageDto({
    @Default(<TransactionDto>[]) List<TransactionDto> transactions,
    String? nextCursor,
  }) = _TransactionsPageDto;

  const TransactionsPageDto._();

  factory TransactionsPageDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionsPageDtoFromJson(json);

  TransactionsPage toDomain() {
    return TransactionsPage(
      items: [for (final txn in transactions) txn.toDomain()],
      nextCursor: nextCursor,
    );
  }
}

@freezed
abstract class TransactionDto with _$TransactionDto {
  const factory TransactionDto({
    required String id,
    required String accountId,
    required String title,
    required String category,
    required int amountMinor,
    required String currency,
    required String occurredAt,
    required String reference,
    @Default('completed') String status,
    int? balanceAfterMinor,
  }) = _TransactionDto;

  const TransactionDto._();

  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);

  Transaction toDomain() {
    final resolved = Currency.fromCode(currency);
    return Transaction(
      id: id,
      accountId: accountId,
      title: title,
      // Unknown enum values degrade, never throw — the server may grow
      // categories and statuses faster than the client ships.
      category: TransactionCategory.values.asNameMap()[category] ??
          TransactionCategory.other,
      amount: Money.fromMinorUnits(BigInt.from(amountMinor), resolved),
      occurredAt: DateTime.parse(occurredAt),
      reference: reference,
      status: TransactionStatus.values.asNameMap()[status] ??
          TransactionStatus.completed,
      balanceAfter: balanceAfterMinor == null
          ? null
          : Money.fromMinorUnits(BigInt.from(balanceAfterMinor!), resolved),
    );
  }
}

@freezed
abstract class DisputeReceiptDto with _$DisputeReceiptDto {
  const factory DisputeReceiptDto({
    required String disputeId,
    required String transactionId,
  }) = _DisputeReceiptDto;

  const DisputeReceiptDto._();

  factory DisputeReceiptDto.fromJson(Map<String, dynamic> json) =>
      _$DisputeReceiptDtoFromJson(json);

  DisputeReceipt toDomain() =>
      DisputeReceipt(id: disputeId, transactionId: transactionId);
}
