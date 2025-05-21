import 'package:expense_tracker_app/core/common/constant/app_const.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter =
      NumberFormat.decimalPatternDigits(locale: 'en_US');
  final bool allowMinus;

  CurrencyInputFormatter({this.allowMinus = false});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;

    if (allowMinus) {
      if (newText == '0-' || newText == '-') {
        return const TextEditingValue(
          text: '-',
          selection: TextSelection.collapsed(offset: 1),
        );
      }
    }

    if (newText.isEmpty || newText == "." || newText == ' ') {
      return const TextEditingValue(
        text: '0',
        selection: TextSelection.collapsed(offset: 1),
      );
    }

    bool startWithMinus = allowMinus && newText.startsWith('-');

    bool endsWithDot = newText.endsWith('.');
    bool hasDot = newText.contains('.');

    final parts = newText.split('.');
    String integerPart = parts[0].replaceAll(RegExp(r'[^0-9]'), '');
    String decimalPart =
        parts.length > 1 ? parts[1].replaceAll(RegExp(r'[^0-9]'), '') : '';

    String formattedInteger = _formatter.format(int.tryParse(integerPart) ?? 0);
    String newFormatted = formattedInteger;

    if (startWithMinus) {
      newFormatted = '-$newFormatted';
    }
    if (hasDot) {
      if (endsWithDot && decimalPart.isEmpty) {
        newFormatted += '.';
      } else {
        newFormatted += '.$decimalPart';
      }
    }

    return TextEditingValue(
      text: newFormatted,
      selection: TextSelection.collapsed(offset: newFormatted.length),
    );
  }
}

class CurrencyFormatter {
  CurrencyFormatter._();

  static String format({
    required double amount,
    required String toCurrency,
    bool isShowSymbol = true,
  }) {
    final NumberFormat formatter = NumberFormat();
    amount = convertCurrency(
      amount: amount,
      fromCurrency: 'VND',
      toCurrency: toCurrency,
    );
    return '${formatter.format(amount)}${isShowSymbol ? ' ${AppConst.currencies.firstWhere((currency) => currency.currencyCode == toCurrency).currencySymbol}' : ''}';
  }

  static double unFormat({
    required String amount,
    required String fromCurrency,
  }) {
    String rawText = amount.replaceAll(',', '');
    double value = double.parse(rawText);
    value = convertCurrency(
      amount: value,
      fromCurrency: fromCurrency,
      toCurrency: 'VND',
    );
    return value;
  }

  static double convertCurrency({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) {
    final fromRate = AppConst.exchangeRates[fromCurrency] ?? 1.0;
    final toRate = AppConst.exchangeRates[toCurrency] ?? 1.0;
    return amount / fromRate * toRate;
  }
}
