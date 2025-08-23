import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionFireStore {
  final String? id;
  final String? title;
  final num? amount;
  final String? description;
  final String? type;
  final DateTime? date;
  final String? currency;
  final String? category;
  final String? userId;

  TransactionFireStore({
    this.id,
    this.title,
    this.amount,
    this.description,
    this.type,
    this.date,
    this.currency,
    this.category,
    this.userId,
  });
  //from map

  factory TransactionFireStore.fromMap(Map<String, dynamic> map, String docId) {
    final tmsp = map['date'] as Timestamp;
    final date = tmsp.toDate();
    return TransactionFireStore(
        id: docId,
        title: map['title'],
        amount: map['amount'],
        description: map['description'],
        type: map['type'],
        category: map['category'],
        currency: map['currency'],
        date: date,
        userId: map['userId']);
  }
}
