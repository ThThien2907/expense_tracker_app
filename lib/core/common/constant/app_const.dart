class AppConst {
  AppConst._();

  static const List<String> languages = [
    'en',
    'vi',
  ];

  static const List<Currency> currencies = [
    Currency(
      currencyName: 'United States Dollar',
      currencyCode: 'USD',
      currencySymbol: '\$',
    ),
    Currency(
      currencyName: 'Việt Nam Đồng',
      currencyCode: 'VND',
      currencySymbol: '₫',
    ),
  ];

  static const exchangeRates = {
    'USD': 0.000038,
    'VND': 1.0,
  };
}

class Currency {
  final String currencyName;
  final String currencyCode;
  final String currencySymbol;

  const Currency({
    required this.currencyName,
    required this.currencyCode,
    required this.currencySymbol,
  });
}
