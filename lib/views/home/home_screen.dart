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
      appBar: AppBar(
        title: Text("Tam Luy"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _controller.fetchTransactions();
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Get.find<LoginController>().signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildListTransactionObx(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.to(() => AddTransactionScreen());
        },
      ),
    );
  }

  Obx _buildListTransactionObx() {
    return Obx(
      () {
        if (_controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (_controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              _controller.errorMessage.value,
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        if (_controller.transactions.isEmpty) {
          return Center(
            child: Text("No transactions found"),
          );
        }
        return Expanded(
          child: ListView.builder(
            itemCount: _controller.transactions.length,
            itemBuilder: (context, index) {
              final transaction = _controller.transactions[index];
              final isIncome = transaction.type == TransactionType.income;
              final color = isIncome ? Colors.green : Colors.red;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(
                    isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                    color: color,
                  ),
                ),
                title: Text(transaction.title ?? ""),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaction.category ?? "Uncategorized"),
                    Text(
                      DateFormat('MMM dd, yyyy').format(transaction.date!),
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                trailing: Text("\$${transaction.amount}"),
                tileColor: color.withOpacity(0.1),
                onLongPress: () {
                  _confirmDeleteTransaction(transaction);
                },
                onTap: () {
                  Get.snackbar(
                    'Transaction Details',
                    'Title: ${transaction.title}\n'
                        'Amount: \$${transaction.amount}\n'
                        'Type: ${transaction.type.toString().split('.').last}\n'
                        'Category: ${transaction.category ?? "Uncategorized"}\n'
                        'Date: ${DateFormat('MMM dd, yyyy').format(transaction.date!)}',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  //confirm delete transaction
  void _confirmDeleteTransaction(TransactionFirestore transaction) {
    Get.defaultDialog(
      title: "Delete Transaction",
      middleText: "Are you sure you want to delete this transaction?",
      onConfirm: () {
        _controller.deleteTransaction(transaction.id!);
        Get.back();
      },
      onCancel: () {
        Get.back();
      },
    );
  }
}
