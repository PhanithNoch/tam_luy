import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionFirestore {
  final String? id;
  final String? title;
  final num? amount;
  final String? category;
  final TransactionType? type;
  final String? description;
  final String? currency;
  final DateTime? date;
  String? userId;

  TransactionFirestore(
      {this.id,
      this.title,
      this.amount,
      this.type,
      this.description,
      this.category,
      this.date,
      this.currency,
      this.userId});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'amount': amount,
      'category': category,
      'currency': currency,
      'date': date,
      'type': type.toString().split('.').last,
      'userId': userId,
    };
  }

  static TransactionFirestore fromMap(Map<String, dynamic> map, String id) {
    final firebaseTimestamp = map['date'] as Timestamp;
    DateTime date = firebaseTimestamp.toDate();
    return TransactionFirestore(
      id: id,
      title: map['title'],
      description: map['description'],
      amount: map['amount'],
      category: map['category'],
      currency: map['currency'],
      date: date,
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () =>
            TransactionType.expense, // Default to expense if not found
      ),
    );
  }
}

enum TransactionType { income, expense }

class Currency {
  final String code;
  final String name;
  final String symbol;
  final double exchangeRate;

  Currency.name(this.code, this.name, this.symbol, this.exchangeRate);

  static final List<Currency> supportedCurrencies = [
    Currency.name('USD', 'United States Dollar', '\$', 1.0),
    //Khmer Riel
    Currency.name('KHR', 'Khmer Riel', '៛', 0.00025), // Example exchange rate
    // Add more currencies as needed
  ];
}
