import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vaulta/core/money/currency.dart';
import 'package:vaulta/core/money/money.dart';
import 'package:vaulta/features/savings/domain/entities/pot.dart';

part 'pot_dtos.freezed.dart';
part 'pot_dtos.g.dart';

/// Wire shapes for `/pots`.
///
/// Unlike the fraud feed (an in-process stream, no boundary — handoff 9c
/// §3.2), `/pots` is a real wire boundary, so it earns a DTO: money
/// travels as integer minor units plus an ISO code and becomes [Money]
/// exactly once, in `toDomain()`.

@freezed
abstract class PotsDto with _$PotsDto {
  const factory PotsDto({
    @Default(<PotDto>[]) List<PotDto> pots,
  }) = _PotsDto;

  const PotsDto._();

  factory PotsDto.fromJson(Map<String, dynamic> json) =>
      _$PotsDtoFromJson(json);

  /// Rows the client cannot faithfully represent are dropped, not coerced
  /// — the same discipline `BeneficiariesDto` applies: a pot in an
  /// unsupported currency would otherwise become a bucket the user can see
  /// but never deposit into.
  List<Pot> toDomain() => [
        for (final dto in pots)
          if (dto.toDomainOrNull() case final pot?) pot,
      ];
}

@freezed
abstract class PotDto with _$PotDto {
  const factory PotDto({
    required String id,
    required String accountId,
    required String name,
    required int balanceMinor,
    required String currency,
    int? goalMinor,
    @Default(false) bool roundUpsEnabled,
  }) = _PotDto;

  const PotDto._();

  factory PotDto.fromJson(Map<String, dynamic> json) =>
      _$PotDtoFromJson(json);

  Pot? toDomainOrNull() {
    final resolvedCurrency = Currency.tryFromCode(currency);
    if (resolvedCurrency == null) return null;
    final target = goalMinor;
    return Pot(
      id: id,
      accountId: accountId,
      name: name,
      balance: Money.fromMinorUnits(
        BigInt.from(balanceMinor),
        resolvedCurrency,
      ),
      goal: target == null
          ? null
          : Money.fromMinorUnits(BigInt.from(target), resolvedCurrency),
      roundUpsEnabled: roundUpsEnabled,
    );
  }
}
