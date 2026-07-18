import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/accounts/domain/entities/account.dart';
import 'package:vaulta/features/accounts/domain/entities/balance_point.dart';
import 'package:vaulta/features/accounts/domain/entities/statement.dart';

part 'account_dtos.freezed.dart';
part 'account_dtos.g.dart';

/// Wire shapes for `/accounts*`. Money travels as integer minor units plus
/// an ISO code and becomes [Money] exactly once, in `toDomain()` — API
/// shape never leaks past this file.

@freezed
abstract class AccountsResponseDto with _$AccountsResponseDto {
  const factory AccountsResponseDto({
    @Default(<AccountDto>[]) List<AccountDto> accounts,
  }) = _AccountsResponseDto;

  const AccountsResponseDto._();

  factory AccountsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AccountsResponseDtoFromJson(json);

  List<Account> toDomain() =>
      [for (final account in accounts) account.toDomain()];
}

@freezed
abstract class AccountDto with _$AccountDto {
  const factory AccountDto({
    required String id,
    required String name,
    required String type,
    required String iban,
    required String currency,
    required int balanceMinor,
    required String openedAt,
  }) = _AccountDto;

  const AccountDto._();

  factory AccountDto.fromJson(Map<String, dynamic> json) =>
      _$AccountDtoFromJson(json);

  Account toDomain() {
    return Account(
      id: id,
      name: name,
      // Unknown types degrade to checking rather than crashing the list —
      // the server may grow types faster than the client ships.
      type: AccountType.values.asNameMap()[type] ?? AccountType.checking,
      iban: iban,
      balance: Money.fromMinorUnits(
        BigInt.from(balanceMinor),
        Currency.fromCode(currency),
      ),
      openedAt: DateTime.parse(openedAt),
    );
  }
}

@freezed
abstract class AccountHistoryDto with _$AccountHistoryDto {
  const factory AccountHistoryDto({
    required String accountId,
    required String currency,
    @Default(<HistoryPointDto>[]) List<HistoryPointDto> points,
  }) = _AccountHistoryDto;

  const AccountHistoryDto._();

  factory AccountHistoryDto.fromJson(Map<String, dynamic> json) =>
      _$AccountHistoryDtoFromJson(json);

  List<BalancePoint> toDomain() {
    final resolved = Currency.fromCode(currency);
    return [for (final point in points) point.toDomain(resolved)];
  }
}

@freezed
abstract class HistoryPointDto with _$HistoryPointDto {
  const factory HistoryPointDto({
    required String date,
    required int balanceMinor,
  }) = _HistoryPointDto;

  const HistoryPointDto._();

  factory HistoryPointDto.fromJson(Map<String, dynamic> json) =>
      _$HistoryPointDtoFromJson(json);

  BalancePoint toDomain(Currency currency) {
    return BalancePoint(
      date: DateTime.parse(date),
      balance: Money.fromMinorUnits(BigInt.from(balanceMinor), currency),
    );
  }
}

@freezed
abstract class StatementsResponseDto with _$StatementsResponseDto {
  const factory StatementsResponseDto({
    @Default(<StatementDto>[]) List<StatementDto> statements,
  }) = _StatementsResponseDto;

  const StatementsResponseDto._();

  factory StatementsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$StatementsResponseDtoFromJson(json);

  List<Statement> toDomain() =>
      [for (final statement in statements) statement.toDomain()];
}

@freezed
abstract class StatementDto with _$StatementDto {
  const factory StatementDto({
    required String id,
    required String accountId,
    required String periodStart,
    required String periodEnd,
    required String currency,
    required int openingBalanceMinor,
    required int closingBalanceMinor,
    required int transactionCount,
  }) = _StatementDto;

  const StatementDto._();

  factory StatementDto.fromJson(Map<String, dynamic> json) =>
      _$StatementDtoFromJson(json);

  Statement toDomain() {
    final resolved = Currency.fromCode(currency);
    return Statement(
      id: id,
      accountId: accountId,
      periodStart: DateTime.parse(periodStart),
      periodEnd: DateTime.parse(periodEnd),
      opening: Money.fromMinorUnits(BigInt.from(openingBalanceMinor), resolved),
      closing: Money.fromMinorUnits(BigInt.from(closingBalanceMinor), resolved),
      transactionCount: transactionCount,
    );
  }
}

@freezed
abstract class StatementDetailDto with _$StatementDetailDto {
  const factory StatementDetailDto({
    required String id,
    required String accountId,
    required String periodStart,
    required String periodEnd,
    required String currency,
    required int openingBalanceMinor,
    required int closingBalanceMinor,
    required int transactionCount,
    @Default(<StatementLineDto>[]) List<StatementLineDto> lines,
  }) = _StatementDetailDto;

  const StatementDetailDto._();

  factory StatementDetailDto.fromJson(Map<String, dynamic> json) =>
      _$StatementDetailDtoFromJson(json);

  StatementDetail toDomain() {
    final resolved = Currency.fromCode(currency);
    return StatementDetail(
      statement: Statement(
        id: id,
        accountId: accountId,
        periodStart: DateTime.parse(periodStart),
        periodEnd: DateTime.parse(periodEnd),
        opening:
            Money.fromMinorUnits(BigInt.from(openingBalanceMinor), resolved),
        closing:
            Money.fromMinorUnits(BigInt.from(closingBalanceMinor), resolved),
        transactionCount: transactionCount,
      ),
      lines: [for (final line in lines) line.toDomain(resolved)],
    );
  }
}

@freezed
abstract class StatementLineDto with _$StatementLineDto {
  const factory StatementLineDto({
    required String id,
    required String title,
    required int amountMinor,
    required String occurredAt,
  }) = _StatementLineDto;

  const StatementLineDto._();

  factory StatementLineDto.fromJson(Map<String, dynamic> json) =>
      _$StatementLineDtoFromJson(json);

  StatementLine toDomain(Currency currency) {
    return StatementLine(
      id: id,
      title: title,
      amount: Money.fromMinorUnits(BigInt.from(amountMinor), currency),
      occurredAt: DateTime.parse(occurredAt),
    );
  }
}
