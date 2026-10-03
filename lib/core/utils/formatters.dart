import 'package:intl/intl.dart';

import '../config/store_config.dart';

class Formatters {
  Formatters._();

  static final _currency = NumberFormat.currency(
    locale: StoreConfig.currencyLocale,
    symbol: StoreConfig.currencySymbol,
    decimalDigits: 2,
  );
  static final _currencyWhole = NumberFormat.currency(
    locale: StoreConfig.currencyLocale,
    symbol: StoreConfig.currencySymbol,
    decimalDigits: 0,
  );
  static final _date = DateFormat('d MMM yyyy');
  static final _dateTime = DateFormat('d MMM yyyy, h:mm a');

  /// `$1,395` for whole amounts, `$1,676.75` otherwise.
  static String price(num value) =>
      value == value.roundToDouble() ? _currencyWhole.format(value) : _currency.format(value);

  static String money(num value) => _currency.format(value);
  static String date(DateTime d) => _date.format(d);
  static String dateTime(DateTime d) => _dateTime.format(d);

  /// Parses API numbers that may arrive as `1395`, `"920.7"` or `"$1676.75"`.
  static double parseAmount(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    }
    return 0;
  }
}
