import 'package:flutter/material.dart';
import 'package:tam_luy/controllers/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:tam_luy/controllers/transactions/transaction_controller.dart';
import 'package:tam_luy/views/transactions/add_transaction_view.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final _controller = Get.put(HomeController());
  final _transactionController = Get.put(TransactionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions"),
        actions: [
          // sigin  out
          IconButton(
            onPressed: _controller.confirmSignOutDialog,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _transactionController.filterTransaction = "expense";
                    _transactionController.fetchTransactions();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Expense",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    _transactionController.filterTransaction = "income";
                    _transactionController.fetchTransactions();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Income",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(() => Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _transactionController.fetchTransactions();
                  },
                  child: ListView.builder(
                    itemCount: _transactionController.transactions.value.length,
                    itemBuilder: (context, index) {
                      final tn =
                          _transactionController.transactions.value[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.category),
                        ),
                        title: Text(tn.title ?? ""),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (tn.description != null)
                              Text(tn.description ?? ""),
                            Text(tn.date.toString() ?? ""),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //navigate to other screen or dialog or bottomSheet
          Get.to(() => AddTransactionView());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
