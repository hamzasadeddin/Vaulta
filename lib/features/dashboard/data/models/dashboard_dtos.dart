import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/dashboard/domain/entities/account_summary.dart';
import 'package:vaulta/features/dashboard/domain/entities/balance_point.dart';
import 'package:vaulta/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:vaulta/features/dashboard/domain/entities/recent_transaction.dart';

part 'dashboard_dtos.freezed.dart';
part 'dashboard_dtos.g.dart';

// Wire shapes for `GET /dashboard/summary`. Amounts travel as integer
// minor units plus an ISO 4217 code and become [Money] exactly once, in
// `toDomain`.

@freezed
abstract class DashboardSummaryDto with _$DashboardSummaryDto {
  const factory DashboardSummaryDto({
    required List<AccountSummaryDto> accounts,
    @Default(<TransactionDto>[]) List<TransactionDto> recentTransactions,
  }) = _DashboardSummaryDto;

  const DashboardSummaryDto._();

  factory DashboardSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryDtoFromJson(json);

  DashboardSummary toDomain() => DashboardSummary(
        accounts: [for (final account in accounts) account.toDomain()],
        recentTransactions: [
          for (final txn in recentTransactions) txn.toDomain(),
        ],
      );
}

@freezed
abstract class AccountSummaryDto with _$AccountSummaryDto {
  const factory AccountSummaryDto({
    required String id,
    required String name,
    required String currency,
    required int balanceMinor,
    @Default(<BalancePointDto>[]) List<BalancePointDto> history,
  }) = _AccountSummaryDto;

  const AccountSummaryDto._();

  factory AccountSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$AccountSummaryDtoFromJson(json);

  AccountSummary toDomain() {
    final ccy = Currency.fromCode(currency);
    return AccountSummary(
      id: id,
      name: name,
      balance: Money.fromMinorUnits(BigInt.from(balanceMinor), ccy),
      history: [for (final point in history) point.toDomain(ccy)],
    );
  }
}

@freezed
abstract class BalancePointDto with _$BalancePointDto {
  const factory BalancePointDto({
    required String date,
    required int balanceMinor,
  }) = _BalancePointDto;

  const BalancePointDto._();

  factory BalancePointDto.fromJson(Map<String, dynamic> json) =>
      _$BalancePointDtoFromJson(json);

  /// The account owns the currency; points only carry the amount.
  BalancePoint toDomain(Currency currency) => BalancePoint(
        date: DateTime.parse(date),
        balance: Money.fromMinorUnits(BigInt.from(balanceMinor), currency),
      );
}

@freezed
abstract class TransactionDto with _$TransactionDto {
  const factory TransactionDto({
    required String id,
    required String accountId,
    required String title,
    required int amountMinor,
    required String currency,
    required String occurredAt,
    @Default('other') String category,
    @Default('completed') String status,
  }) = _TransactionDto;

  const TransactionDto._();

  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);

  /// Unknown categories and statuses degrade gracefully — the server may
  /// grow its vocabulary before the app does.
  RecentTransaction toDomain() => RecentTransaction(
        id: id,
        accountId: accountId,
        title: title,
        category: TransactionCategory.values.asNameMap()[category] ??
            TransactionCategory.other,
        amount: Money.fromMinorUnits(
          BigInt.from(amountMinor),
          Currency.fromCode(currency),
        ),
        occurredAt: DateTime.parse(occurredAt),
        status: TransactionStatus.values.asNameMap()[status] ??
            TransactionStatus.completed,
      );
}
