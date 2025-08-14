class Currency {
  final String code;
  final String name;
  final String symbol;
  final double exchangeRate;

  Currency(this.code, this.name, this.symbol, this.exchangeRate);

  static final List<Currency> supportedCurrencies = [
    Currency('USD', 'United States Dollar', '\$', 1.0),
    //Khmer Riel
    Currency('KHR', 'Khmer Riel', '៛', 4100.0),
    // Add more currencies as needed
  ];

  @override
  String toString() {
    return '$name ($code) - $symbol';
  }

  static Currency getCurrency(String code) {
    return supportedCurrencies.firstWhere((currency) => currency.code == code,
        orElse: () => supportedCurrencies.first);
  }

  static bool isSupported(String code) {
    return supportedCurrencies.any((currency) => currency.code == code);
  }

  // Get exchange rate text
  String get exchangeRateText {
    if (code == 'USD') {
      return 'Base currency'; // Base currency
    }
    if (code == 'KHR') {
      return '1 USD = $exchangeRate KHR'; // Example exchange rate
    }
    return '1 USD = $exchangeRate $code'; // Default exchange rate format
  }

  double getReverseRate() {
    if (exchangeRate <= 0) {
      throw ArgumentError('Exchange rate must be greater than zero');
    }
    return 1 / exchangeRate;
  }

  //total income
  double get totalIncome {
    return supportedCurrencies
        .where((currency) => currency.code == 'USD')
        .fold(0.0, (sum, currency) => sum + currency.exchangeRate);
  }

  //total expense
  double get totalExpense {
    return supportedCurrencies
        .where((currency) => currency.code == 'KHR')
        .fold(0.0, (sum, currency) => sum + currency.exchangeRate);
  }

  //get balance
  double get balance {
    return totalIncome - totalExpense;
  }
}
