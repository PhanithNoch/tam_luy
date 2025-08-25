import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/transaction.dart';
import '../login_controller.dart';

class TransactionController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  RxList<TransactionFirestore> transactions = <TransactionFirestore>[].obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;
  final _authController = Get.find<LoginController>();
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;

  // Computed values
  final RxDouble _totalIncome = 0.0.obs;
  final RxDouble _totalExpense = 0.0.obs;
  final RxDouble _balance = 0.0.obs;

  void _calculateTotals() {
    double income = 0.0;
    double expense = 0.0;

    for (var transaction in transactions) {
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

  // Categories for income and expenses
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final Rx<TransactionType> selectedType = TransactionType.expense.obs;

  final RxString selectedCategory = ''.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<Currency> selectedCurrency = Currency.supportedCurrencies.first.obs;

  final List<String> incomeCategories = [
    'Salary',
    'Business',
    'Investment',
    'Freelance',
    'Gift',
    'Other Income'
  ];

  final List<String> expenseCategories = [
    'Food',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills',
    'Healthcare',
    'Education',
    'Travel',
    'Other Expense'
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    fetchTransactions();
    super.onInit();
  }

  // Fetch transactions from Firestore
  void fetchTransactions() async {
    isLoading.value = true;
    try {
      final user = auth.currentUser;
      if (user == null) {
        errorMessage.value = 'User not authenticated';
        return;
      }
      final snapshot = await firestore
          .collection('transactions')
          .orderBy('date', descending: true)
          .where('userId', isEqualTo: _authController.user.value!.uid)
          .get();
      transactions.value = snapshot.docs
          .map((doc) => TransactionFirestore.fromMap(doc.data(), doc.id))
          .toList();
      _calculateTotals();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Add a new transaction
  Future<void> addTransaction(TransactionFirestore transaction) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      transaction.userId = user.uid;
      await firestore.collection('transactions').add(transaction.toMap());
      // Clear input fields after adding
      Get.back();
      fetchTransactions(); // Refresh the list after adding
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  // Update an existing transaction
  Future<void> updateTransaction(TransactionFirestore transaction) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      transaction.userId = user.uid;
      await firestore
          .collection('transactions')
          .doc(transaction.id)
          .update(transaction.toMap());
      fetchTransactions(); // Refresh the list after updating
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  //delete transaction
  Future<void> deleteTransaction(String id) async {
    try {
      await firestore.collection('transactions').doc(id).delete();
      fetchTransactions(); // Refresh the list after deleting
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }
}
