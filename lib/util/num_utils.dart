import 'package:intl/intl.dart';

extension NumberFormatting on num {
  String formatWithThousandSeparator() {
    final formatter = NumberFormat.decimalPattern();
    return formatter.format(this);
  }
}

extension CurrencyFormatting on num {
  String formatAsCurrency({String locale = 'en_US', String symbol = 'VND'}) {
    final formatter =
        NumberFormat.currency(locale: locale, symbol: symbol, decimalDigits: 0);
    return formatter.format(this);
  }
}
