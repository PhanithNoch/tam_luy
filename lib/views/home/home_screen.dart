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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Transactions"),
          actions: [
            // sigin  out
            IconButton(
              onPressed: _controller.confirmSignOutDialog,
              icon: Icon(Icons.logout),
            ),
          ],
          bottom: TabBar(
              onTap: (index) {
                print("${index}");
                if (index == 0) {
                  _transactionController.filterTransaction = "income";
                  _transactionController.fetchTransactions();
                } else {
                  _transactionController.filterTransaction = "expense";
                  _transactionController.fetchTransactions();
                }
              },
              tabs: [
                Tab(icon: Icon(Icons.attach_money), text: 'Income'),
                Tab(icon: Icon(Icons.money_off), text: 'Expsense'),
              ]),
        ),
        body: TabBarView(
          children: [
            Transaction(),
            Transaction(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            //navigate to other screen or dialog or bottomSheet
            final result = await Get.to(() => AddTransactionView());
            if (result != null) {
              // refresh data
              _transactionController.filterTransaction = "income";

              _transactionController.fetchTransactions();
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class Transaction extends StatelessWidget {
  Transaction({super.key});
  final _transactionController = Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _transactionController.fetchTransactions();
                },
                child: ListView.builder(
                  itemCount: _transactionController.transactions.value.length,
                  itemBuilder: (context, index) {
                    final tn = _transactionController.transactions.value[index];
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
    );
  }
}
