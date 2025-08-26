import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tam_luy/models/transaction.dart';
import 'package:tam_luy/views/home/add_transaction_screen.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/transactions/transaction_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () => _controller.refreshTransactions(),
        child: Column(
          children: [
            _buildDashboardCard(),
            _buildQuickActions(),
            _buildTransactionsList(),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text("Tam Luy"),
      elevation: 0,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      actions: [
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: [
                  Icon(Icons.refresh, size: 20),
                  SizedBox(width: 8),
                  Text('Refresh'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.download, size: 20),
                  SizedBox(width: 8),
                  Text('Export'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 8),
                  Text('Logout'),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'refresh':
                _controller.refreshTransactions();
                break;
              case 'export':
                _showExportDialog();
                break;
              case 'logout':
                Get.find<LoginController>().signOut();
                break;
            }
          },
        ),
      ],
    );
  }

  Widget _buildDashboardCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.blue.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Obx(() => Column(
            children: [
              Text(
                'Current Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${_controller.balance.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildBalanceItem(
                      'Income',
                      _controller.totalIncome,
                      Colors.green.shade300,
                      Icons.arrow_upward,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white30,
                  ),
                  Expanded(
                    child: _buildBalanceItem(
                      'Expense',
                      _controller.totalExpense,
                      Colors.red.shade300,
                      Icons.arrow_downward,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'This Month: Income \$${_controller.monthlyIncome.toStringAsFixed(2)} • Expense \$${_controller.monthlyExpense.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildBalanceItem(
      String label, double amount, Color color, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionButton(
              'Add Income',
              Icons.add_circle,
              Colors.green,
              () => _quickAddTransaction(TransactionType.income),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionButton(
              'Add Expense',
              Icons.remove_circle,
              Colors.red,
              () => _quickAddTransaction(TransactionType.expense),
            ),
          ),
          const SizedBox(width: 12),
          // Expanded(
          //   child: _buildQuickActionButton(
          //     'Filter',
          //     Icons.filter_list,
          //     Colors.orange,
          //         () => Get.to(() => SearchFilterScreen()),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // TextButton(
                //   onPressed: () => Get.to(() => SearchFilterScreen()),
                //   child: const Text('View All'),
                // ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildTransactionObx()),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionObx() {
    return Obx(() {
      if (_controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_controller.errorMessage.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                _controller.errorMessage,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _controller.fetchTransactions(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (_controller.transactions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No transactions yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add your first transaction to get started',
                style: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Get.to(() => AddTransactionScreen()),
                icon: const Icon(Icons.add),
                label: const Text('Add Transaction'),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        itemCount: _controller.transactions.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final transaction = _controller.transactions[index];
          return _buildTransactionTile(transaction);
        },
      );
    });
  }

  Widget _buildTransactionTile(TransactionFirestore transaction) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? Colors.green : Colors.red;
    final amount = transaction.amount ?? 0.0;

    return Dismissible(
      key: Key(transaction.id ?? ''),
      background: Container(
        color: Colors.red.shade100,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => _confirmDeleteTransaction(transaction),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            _getCategoryIcon(transaction.category ?? ''),
            color: color,
            size: 24,
          ),
        ),
        title: Text(
          transaction.title ?? 'Untitled',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction.category ?? 'Uncategorized',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              DateFormat('MMM dd, yyyy • HH:mm')
                  .format(transaction.date ?? DateTime.now()),
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isIncome ? '+' : '-'}\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (transaction.description?.isNotEmpty == true)
              Icon(
                Icons.note,
                size: 12,
                color: Colors.grey.shade400,
              ),
          ],
        ),
        onTap: () => _showTransactionDetails(transaction),
        onLongPress: () => _showTransactionOptions(transaction),
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () => Get.to(() => AddTransactionScreen()),
      label: const Text('Add Transaction'),
      icon: const Icon(Icons.add),
      backgroundColor: Colors.blue,
    );
  }

  // Helper methods
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
      case 'food & dining':
        return Icons.restaurant;
      case 'transportation':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'bills':
      case 'bills & utilities':
        return Icons.receipt;
      case 'healthcare':
        return Icons.medical_services;
      case 'education':
        return Icons.school;
      case 'travel':
        return Icons.flight;
      case 'salary':
        return Icons.work;
      case 'business':
        return Icons.business_center;
      case 'investment':
        return Icons.trending_up;
      default:
        return Icons.category;
    }
  }

  void _quickAddTransaction(TransactionType type) {
    _controller.selectedType.value = type;
    Get.to(() => AddTransactionScreen());
  }

  Future<bool?> _confirmDeleteTransaction(TransactionFirestore transaction) {
    return Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Transaction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to delete this transaction?'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title ?? 'Untitled',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${transaction.type == TransactionType.income ? '+' : '-'}\$${transaction.amount?.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: transaction.type == TransactionType.income
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(result: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    ).then((result) {
      if (result == true) {
        _controller.deleteTransaction(transaction.id!);
      }
      return result;
    });
  }

  void _showTransactionDetails(TransactionFirestore transaction) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (transaction.type == TransactionType.income
                            ? Colors.green
                            : Colors.red)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    _getCategoryIcon(transaction.category ?? ''),
                    color: transaction.type == TransactionType.income
                        ? Colors.green
                        : Colors.red,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title ?? 'Untitled',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${transaction.type == TransactionType.income ? '+' : '-'}\$${transaction.amount?.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: transaction.type == TransactionType.income
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow(
                'Category', transaction.category ?? 'Uncategorized'),
            _buildDetailRow('Type',
                transaction.type.toString().split('.').last.toUpperCase()),
            _buildDetailRow(
                'Date',
                DateFormat('MMMM dd, yyyy • HH:mm')
                    .format(transaction.date ?? DateTime.now())),
            if (transaction.description?.isNotEmpty == true)
              _buildDetailRow('Description', transaction.description!),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.back();
                      _editTransaction(transaction);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      _confirmDeleteTransaction(transaction);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionOptions(TransactionFirestore transaction) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('View Details'),
              onTap: () {
                Get.back();
                _showTransactionDetails(transaction);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Transaction'),
              onTap: () {
                Get.back();
                _editTransaction(transaction);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Duplicate Transaction'),
              onTap: () {
                Get.back();
                _duplicateTransaction(transaction);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Transaction',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                _confirmDeleteTransaction(transaction);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _editTransaction(TransactionFirestore transaction) {
    _controller.populateFormFields(transaction);
    // Get.to(() => AddTransactionScreen(transaction: transaction));
  }

  void _duplicateTransaction(TransactionFirestore transaction) {
    final duplicatedTransaction = TransactionFirestore(
      title: '${transaction.title} (Copy)',
      amount: transaction.amount,
      type: transaction.type,
      category: transaction.category,
      description: transaction.description,
      date: DateTime.now(),
    );

    _controller.populateFormFields(duplicatedTransaction);
    Get.to(() => AddTransactionScreen());
  }

  void _showExportDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Export Transactions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose the date range for export:'),
            const SizedBox(height: 16),
            // Add date range picker here
            Text(
                'This feature will be implemented with CSV export functionality'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement export functionality
              Get.back();
              Get.snackbar(
                'Export',
                'Export functionality will be implemented soon',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }
}
