/// ISO 4217 currencies supported by the app.
///
/// [minorUnitDigits] drives all minor-unit conversion and rounding —
/// note JOD/KWD/BHD use 3, JPY uses 0. Never assume 2.
enum Currency {
  usd(code: 'USD', symbol: r'$', minorUnitDigits: 2),
  eur(code: 'EUR', symbol: '€', minorUnitDigits: 2),
  gbp(code: 'GBP', symbol: '£', minorUnitDigits: 2),
  jod(code: 'JOD', symbol: 'JD', minorUnitDigits: 3),
  aed(code: 'AED', symbol: 'د.إ', minorUnitDigits: 2),
  sar(code: 'SAR', symbol: '﷼', minorUnitDigits: 2),
  jpy(code: 'JPY', symbol: '¥', minorUnitDigits: 0);

  const Currency({
    required this.code,
    required this.symbol,
    required this.minorUnitDigits,
  });

  final String code;
  final String symbol;
  final int minorUnitDigits;

  static Currency fromCode(String code) {
    final normalized = code.toUpperCase();
    return values.firstWhere(
      (currency) => currency.code == normalized,
      orElse: () => throw ArgumentError.value(
        code,
        'code',
        'Unsupported currency',
      ),
    );
  }

  static Currency? tryFromCode(String code) {
    final normalized = code.toUpperCase();
    for (final currency in values) {
      if (currency.code == normalized) return currency;
    }
    return null;
  }
}
