import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/transaction.dart';

class TransactionController extends GetxController {
  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable variables
  final RxList<TransactionFirestore> _transactions =
      <TransactionFirestore>[].obs;
  final RxList<TransactionFirestore> _filteredTransactions =
      <TransactionFirestore>[].obs;
  final RxBool _isLoading = true.obs;
  final RxBool _isRefreshing = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _searchQuery = ''.obs;
  final RxString _selectedFilterCategory = 'All'.obs;
  final Rx<TransactionType?> _selectedFilterType = Rx<TransactionType?>(null);
  final Rx<DateTimeRange?> _dateRange = Rx<DateTimeRange?>(null);

  // Computed values
  final RxDouble _totalIncome = 0.0.obs;
  final RxDouble _totalExpense = 0.0.obs;
  final RxDouble _balance = 0.0.obs;
  final RxDouble _monthlyIncome = 0.0.obs;
  final RxDouble _monthlyExpense = 0.0.obs;

  // Form controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final Rx<TransactionType> selectedType = TransactionType.expense.obs;
  final RxString selectedCategory = ''.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<Currency> selectedCurrency = Currency.supportedCurrencies.first.obs;

  // Getters
  List<TransactionFirestore> get transactions => _filteredTransactions;
  bool get isLoading => _isLoading.value;
  bool get isRefreshing => _isRefreshing.value;
  String get errorMessage => _errorMessage.value;
  double get totalIncome => _totalIncome.value;
  double get totalExpense => _totalExpense.value;
  double get balance => _balance.value;
  double get monthlyIncome => _monthlyIncome.value;
  double get monthlyExpense => _monthlyExpense.value;
  String get searchQuery => _searchQuery.value;

  // Categories
  final List<String> incomeCategories = [
    'Salary',
    'Business',
    'Investment',
    'Freelance',
    'Gift',
    'Bonus',
    'Rental Income',
    'Dividend',
    'Other Income'
  ];

  final List<String> expenseCategories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Healthcare',
    'Education',
    'Travel',
    'Insurance',
    'Home & Garden',
    'Personal Care',
    'Subscriptions',
    'Debt Payment',
    'Other Expense'
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  @override
  void onClose() {
    titleController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void _initializeController() {
    fetchTransactions();
    _setupSearchListener();
    _setupFilterListener();
  }

  void _setupSearchListener() {
    debounce(_searchQuery, (_) => _applyFilters(),
        time: const Duration(milliseconds: 500));
  }

  void _setupFilterListener() {
    ever(_selectedFilterCategory, (_) => _applyFilters());
    ever(_selectedFilterType, (_) => _applyFilters());
    ever(_dateRange, (_) => _applyFilters());
  }

  // Enhanced fetch transactions with error handling and performance optimizations
  Future<void> fetchTransactions({bool showLoading = true}) async {
    try {
      if (showLoading) _isLoading.value = true;
      _errorMessage.value = '';

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Use real-time listener for better UX
      _firestore
          .collection('transactions')
          .where('userId', isEqualTo: user.uid)
          .orderBy('date', descending: true)
          .limit(100) // Limit for performance
          .snapshots()
          .listen(
        (snapshot) {
          _transactions.value = snapshot.docs
              .map((doc) => TransactionFirestore.fromMap(doc.data(), doc.id))
              .toList();
          _calculateTotals();
          _applyFilters();
          _isLoading.value = false;
        },
        onError: (error) {
          _errorMessage.value =
              'Failed to load transactions: ${error.toString()}';
          _isLoading.value = false;
        },
      );
    } catch (e) {
      _errorMessage.value = 'Failed to fetch transactions: ${e.toString()}';
      _isLoading.value = false;
      _showErrorSnackbar(e.toString());
    }
  }

  // Refresh transactions
  Future<void> refreshTransactions() async {
    _isRefreshing.value = true;
    await fetchTransactions(showLoading: false);
    _isRefreshing.value = false;
  }

  // Enhanced calculation with monthly totals
  void _calculateTotals() {
    double income = 0.0;
    double expense = 0.0;
    double monthlyIncome = 0.0;
    double monthlyExpense = 0.0;

    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;

    for (var transaction in _transactions) {
      final amount = transaction.amount ?? 0.0;

      if (transaction.type == TransactionType.income) {
        income += amount;
        if (transaction.date?.month == currentMonth &&
            transaction.date?.year == currentYear) {
          monthlyIncome += amount;
        }
      } else {
        expense += amount;
        if (transaction.date?.month == currentMonth &&
            transaction.date?.year == currentYear) {
          monthlyExpense += amount;
        }
      }
    }

    _totalIncome.value = income;
    _totalExpense.value = expense;
    _balance.value = income - expense;
    _monthlyIncome.value = monthlyIncome;
    _monthlyExpense.value = monthlyExpense;
  }

  // Search and filter functionality
  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  void setFilterCategory(String category) {
    _selectedFilterCategory.value = category;
  }

  void setFilterType(TransactionType? type) {
    _selectedFilterType.value = type;
  }

  void setDateRange(DateTimeRange? range) {
    _dateRange.value = range;
  }

  void clearFilters() {
    _searchQuery.value = '';
    _selectedFilterCategory.value = 'All';
    _selectedFilterType.value = null;
    _dateRange.value = null;
  }

  void _applyFilters() {
    var filtered = List<TransactionFirestore>.from(_transactions);

    // Apply search filter
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered.where((transaction) {
        return transaction.title
                    ?.toLowerCase()
                    .contains(_searchQuery.value.toLowerCase()) ==
                true ||
            transaction.category
                    ?.toLowerCase()
                    .contains(_searchQuery.value.toLowerCase()) ==
                true ||
            transaction.description
                    ?.toLowerCase()
                    .contains(_searchQuery.value.toLowerCase()) ==
                true;
      }).toList();
    }

    // Apply category filter
    if (_selectedFilterCategory.value != 'All' &&
        _selectedFilterCategory.value.isNotEmpty) {
      filtered = filtered.where((transaction) {
        return transaction.category == _selectedFilterCategory.value;
      }).toList();
    }

    // Apply type filter
    if (_selectedFilterType.value != null) {
      filtered = filtered.where((transaction) {
        return transaction.type == _selectedFilterType.value;
      }).toList();
    }

    // Apply date range filter
    if (_dateRange.value != null) {
      filtered = filtered.where((transaction) {
        if (transaction.date == null) return false;
        return transaction.date!.isAfter(
                _dateRange.value!.start.subtract(const Duration(days: 1))) &&
            transaction.date!
                .isBefore(_dateRange.value!.end.add(const Duration(days: 1)));
      }).toList();
    }

    _filteredTransactions.value = filtered;
  }

  // Enhanced add transaction with validation
  Future<bool> addTransaction(TransactionFirestore transaction) async {
    if (!_validateTransaction(transaction)) {
      return false;
    }

    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      transaction.userId = user.uid;

      await _firestore.collection('transactions').add(transaction.toMap());

      _clearFormFields();
      _showSuccessSnackbar('Transaction added successfully');
      Get.back();
      return true;
    } catch (e) {
      _errorMessage.value = e.toString();
      _showErrorSnackbar('Failed to add transaction: ${e.toString()}');
      return false;
    }
  }

  // Enhanced update transaction
  Future<bool> updateTransaction(TransactionFirestore transaction) async {
    if (!_validateTransaction(transaction)) {
      return false;
    }

    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      transaction.userId = user.uid;

      await _firestore
          .collection('transactions')
          .doc(transaction.id)
          .update(transaction.toMap());

      _showSuccessSnackbar('Transaction updated successfully');
      Get.back();
      return true;
    } catch (e) {
      _errorMessage.value = e.toString();
      _showErrorSnackbar('Failed to update transaction: ${e.toString()}');
      return false;
    }
  }

  // Enhanced delete transaction with confirmation
  Future<bool> deleteTransaction(String id) async {
    try {
      await _firestore.collection('transactions').doc(id).delete();
      _showSuccessSnackbar('Transaction deleted successfully');
      return true;
    } catch (e) {
      _errorMessage.value = e.toString();
      _showErrorSnackbar('Failed to delete transaction: ${e.toString()}');
      return false;
    }
  }

  // Bulk operations
  Future<bool> deleteMultipleTransactions(List<String> ids) async {
    try {
      final batch = _firestore.batch();
      for (String id in ids) {
        batch.delete(_firestore.collection('transactions').doc(id));
      }
      await batch.commit();
      _showSuccessSnackbar('${ids.length} transactions deleted successfully');
      return true;
    } catch (e) {
      _showErrorSnackbar('Failed to delete transactions: ${e.toString()}');
      return false;
    }
  }

  // Export transactions (you can implement CSV export here)
  List<TransactionFirestore> getTransactionsForExport({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    var exportTransactions = List<TransactionFirestore>.from(_transactions);

    if (startDate != null && endDate != null) {
      exportTransactions = exportTransactions.where((transaction) {
        if (transaction.date == null) return false;
        return transaction.date!
                .isAfter(startDate.subtract(const Duration(days: 1))) &&
            transaction.date!.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
    }

    return exportTransactions;
  }

  // Get category statistics
  Map<String, double> getCategoryExpenses() {
    final Map<String, double> categoryTotals = {};

    for (var transaction in _transactions) {
      if (transaction.type == TransactionType.expense) {
        final category = transaction.category ?? 'Uncategorized';
        categoryTotals[category] =
            (categoryTotals[category] ?? 0.0) + (transaction.amount ?? 0.0);
      }
    }

    return categoryTotals;
  }

  // Form management
  void _clearFormFields() {
    titleController.clear();
    amountController.clear();
    descriptionController.clear();
    selectedType.value = TransactionType.expense;
    selectedCategory.value = '';
    selectedDate.value = DateTime.now();
  }

  void populateFormFields(TransactionFirestore transaction) {
    titleController.text = transaction.title ?? '';
    amountController.text = transaction.amount?.toString() ?? '';
    descriptionController.text = transaction.description ?? '';
    selectedType.value = transaction.type ?? TransactionType.expense;
    selectedCategory.value = transaction.category ?? '';
    selectedDate.value = transaction.date ?? DateTime.now();
  }

  // Validation
  bool _validateTransaction(TransactionFirestore transaction) {
    if (transaction.title?.isEmpty == true) {
      _showErrorSnackbar('Please enter a title');
      return false;
    }

    if (transaction.amount == null || transaction.amount! <= 0) {
      _showErrorSnackbar('Please enter a valid amount');
      return false;
    }

    if (transaction.category?.isEmpty == true) {
      _showErrorSnackbar('Please select a category');
      return false;
    }

    return true;
  }

  // Helper methods
  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }

  // Analytics methods
  List<TransactionFirestore> getRecentTransactions({int limit = 5}) {
    return _transactions.take(limit).toList();
  }

  double getSpendingByCategory(String category) {
    return _transactions
        .where(
            (t) => t.type == TransactionType.expense && t.category == category)
        .fold(0.0, (sum, t) => sum + (t.amount ?? 0.0));
  }

  double getIncomeByCategory(String category) {
    return _transactions
        .where(
            (t) => t.type == TransactionType.income && t.category == category)
        .fold(0.0, (sum, t) => sum + (t.amount ?? 0.0));
  }
}
