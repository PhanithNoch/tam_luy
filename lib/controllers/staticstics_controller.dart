import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/transaction.dart';

class StatisticsController extends GetxController {
  int selectedIndex = 0;
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;

  // Computed values
  final RxDouble _totalIncome = 0.0.obs;
  final RxDouble _totalExpense = 0.0.obs;
  final RxDouble _balance = 0.0.obs;

  final RxList<TransactionFirestore> _transactions =
      <TransactionFirestore>[].obs;

  // Stream subscription
  StreamSubscription? _transactionSubscription;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final _collectionName = "transactions";

  // Getters
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  double get totalIncome => _totalIncome.value;
  double get totalExpense => _totalExpense.value;
  double get balance => _balance.value;

  // Filtered lists
  List<TransactionFirestore> get incomeTransactions =>
      _transactions.where((t) => t.type == TransactionType.income).toList();

  List<TransactionFirestore> get expenseTransactions =>
      _transactions.where((t) => t.type == TransactionType.expense).toList();

  @override
  void onInit() {
    // TODO: implement onInit

    _listenToTransactions();
    super.onInit();
  }

  void _listenToTransactions() {
    _transactionSubscription?.cancel();
    _transactionSubscription = FirebaseFirestore.instance
        .collection(_collectionName)
        .orderBy('date', descending: true)
        // .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TransactionFirestore.fromMap(doc.data(), doc.id))
          .toList();
    }).listen(
      (transactions) {
        _transactions.value = transactions;
        print("_transactions : ${_transactions}");
        _calculateTotals();
        _clearError();
      },
      onError: (error) {
        _setError('Failed to load transactions: $error');
      },
    );
  }

  void _calculateTotals() {
    double income = 0.0;
    double expense = 0.0;

    for (var transaction in _transactions) {
      if (transaction.type == TransactionType.income) {
        income += transaction.amount ?? 0.0;
      } else {
        expense += transaction.amount ?? 0.0;
      }
    }

    _totalIncome.value = income;
    _totalExpense.value = expense;
    _balance.value = income - expense;
  }
  // Get transactions by date range
  // Stream<List<TransactionFirestore>> getTransactionsByDateRange(
  //     DateTime startDate, DateTime endDate) {
  //   return firebaseFirestore
  //       .collection(_collectionName)
  //       .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
  //       .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
  //       .orderBy('date', descending: true)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs
  //         .map((doc) => TransactionFirestore.fromMap(doc.data(), doc.id))
  //         .toList();
  //   });
  // }

  // Get transactions by category
  // Stream<List<TransactionFirestore>> getTransactionsByCategory(
  //     String category) {
  //   return firebaseFirestore
  //       .collection(_collectionName)
  //       .where('category', isEqualTo: category)
  //       .orderBy('date', descending: true)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs
  //         .map((doc) => TransactionFirestore.fromMap(doc.data(), doc.id))
  //         .toList();
  //   });
  // }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void _setError(String errorMessage) {
    _error.value = errorMessage;
  }

  void _clearError() {
    _error.value = '';
  }

  // Get expense by category for charts
  Map<String, double> getExpenseByCategory() {
    Map<String, double> categoryExpenses = {};

    for (var transaction in expenseTransactions) {
      categoryExpenses[transaction.category!] =
          (categoryExpenses[transaction.category] ?? 0.0) + transaction.amount!;
    }

    return categoryExpenses;
  }

  // Get income by category for charts
  Map<String, double> getIncomeByCategory() {
    Map<String, double> categoryIncomes = {};

    for (var transaction in incomeTransactions) {
      categoryIncomes[transaction.category!] =
          (categoryIncomes[transaction.category] ?? 0) + transaction.amount!;
    }

    return categoryIncomes;
  }
}
