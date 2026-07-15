import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:vaulta/core/money/currency.dart';

/// An exact monetary amount in a single [Currency].
///
/// Backed by [Decimal] — `double` never touches money. Arithmetic between
/// mismatched currencies is a programmer error and throws [ArgumentError]
/// eagerly rather than producing a corrupt ledger value.
@immutable
class Money implements Comparable<Money> {
  const Money(this.amount, this.currency);

  /// Builds from minor units (`12345` minor JOD → `12.345 JOD`).
  ///
  /// Constructed via string to stay entirely in exact arithmetic.
  factory Money.fromMinorUnits(BigInt minorUnits, Currency currency) {
    final digits = currency.minorUnitDigits;
    final sign = minorUnits.isNegative ? '-' : '';
    final magnitude = minorUnits.abs().toString().padLeft(digits + 1, '0');
    final integerPart = magnitude.substring(0, magnitude.length - digits);
    final fractionPart =
        digits == 0 ? '' : '.${magnitude.substring(magnitude.length - digits)}';
    return Money(Decimal.parse('$sign$integerPart$fractionPart'), currency);
  }

  factory Money.zero(Currency currency) => Money(Decimal.zero, currency);

  /// Parses a plain decimal string (`"12.345"`). Throws [FormatException]
  /// on malformed input. Locale-aware parsing belongs in the input layer.
  factory Money.parse(String input, Currency currency) =>
      Money(Decimal.parse(input.trim()), currency);

  static Money? tryParse(String input, Currency currency) {
    final parsed = Decimal.tryParse(input.trim());
    return parsed == null ? null : Money(parsed, currency);
  }

  /// Exact amount in major units.
  final Decimal amount;

  final Currency currency;

  /// Amount in minor units, rounded half-up to the currency's precision.
  BigInt get minorUnits =>
      (amount * _pow10(currency.minorUnitDigits)).round().toBigInt();

  bool get isZero => amount == Decimal.zero;

  bool get isNegative => amount < Decimal.zero;

  bool get isPositive => amount > Decimal.zero;

  Money operator +(Money other) {
    _ensureSameCurrency(other, '+');
    return Money(amount + other.amount, currency);
  }

  Money operator -(Money other) {
    _ensureSameCurrency(other, '-');
    return Money(amount - other.amount, currency);
  }

  Money operator -() => Money(-amount, currency);

  Money operator *(int factor) =>
      Money(amount * Decimal.fromInt(factor), currency);

  /// Multiplies by an exact decimal factor (FX rates, percentages).
  /// Result keeps full precision; round at display/settlement time via
  /// [minorUnits] or [rounded].
  Money times(Decimal factor) => Money(amount * factor, currency);

  /// Rounds to the currency's minor-unit precision.
  Money rounded() => Money.fromMinorUnits(minorUnits, currency);

  Money abs() => Money(amount.abs(), currency);

  bool operator <(Money other) {
    _ensureSameCurrency(other, '<');
    return amount < other.amount;
  }

  bool operator <=(Money other) {
    _ensureSameCurrency(other, '<=');
    return amount <= other.amount;
  }

  bool operator >(Money other) {
    _ensureSameCurrency(other, '>');
    return amount > other.amount;
  }

  bool operator >=(Money other) {
    _ensureSameCurrency(other, '>=');
    return amount >= other.amount;
  }

  /// Splits this amount by [ratios] without losing a single minor unit
  /// (largest-remainder / Fowler allocation). The sum of the parts always
  /// equals the original amount.
  List<Money> allocate(List<int> ratios) {
    if (ratios.isEmpty) {
      throw ArgumentError.value(ratios, 'ratios', 'must not be empty');
    }
    if (ratios.any((ratio) => ratio < 0)) {
      throw ArgumentError.value(ratios, 'ratios', 'must be non-negative');
    }
    final totalRatio = ratios.fold<BigInt>(
      BigInt.zero,
      (sum, ratio) => sum + BigInt.from(ratio),
    );
    if (totalRatio == BigInt.zero) {
      throw ArgumentError.value(ratios, 'ratios', 'must sum to > 0');
    }

    final total = minorUnits;
    final shares = [
      for (final ratio in ratios) total * BigInt.from(ratio) ~/ totalRatio,
    ];
    var remainder =
        total - shares.fold<BigInt>(BigInt.zero, (sum, s) => sum + s);
    final step = remainder.isNegative ? -BigInt.one : BigInt.one;
    var index = 0;
    while (remainder != BigInt.zero) {
      shares[index % shares.length] += step;
      remainder -= step;
      index++;
    }
    return [
      for (final share in shares) Money.fromMinorUnits(share, currency),
    ];
  }

  @override
  int compareTo(Money other) {
    _ensureSameCurrency(other, 'compareTo');
    return amount.compareTo(other.amount);
  }

  void _ensureSameCurrency(Money other, String operation) {
    if (currency != other.currency) {
      throw ArgumentError(
        'Cannot apply "$operation" to ${currency.code} and '
        '${other.currency.code}. Convert explicitly first.',
      );
    }
  }

  static Decimal _pow10(int digits) => Decimal.parse('1${'0' * digits}');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Money && other.currency == currency && other.amount == amount;

  @override
  int get hashCode => Object.hash(amount, currency);

  @override
  String toString() => '${currency.code} $amount';
}
