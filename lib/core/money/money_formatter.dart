import 'package:intl/intl.dart';
import 'package:vaulta/core/money/money.dart';

/// Display formatting only. The `toDouble()` here is safe because the value
/// is first rounded to the currency's exact minor-unit precision and is
/// never fed back into arithmetic — presentation is a one-way street.
extension MoneyFormatting on Money {
  /// `1234.5 USD` → `$1,234.50` (or locale-appropriate equivalent).
  String format({String? locale, bool withSymbol = true}) {
    final formatter = NumberFormat.currency(
      locale: locale,
      name: currency.code,
      symbol: withSymbol ? currency.symbol : '',
      decimalDigits: currency.minorUnitDigits,
    );
    return formatter.format(rounded().amount.toDouble()).trim();
  }

  /// Signed variant for transaction rows: `+$12.00` / `−$12.00`.
  String formatSigned({String? locale}) {
    final formatted = abs().format(locale: locale);
    if (isNegative) return '−$formatted';
    return '+$formatted';
  }
}
