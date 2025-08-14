import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AddTransactionScreen extends StatelessWidget {
  AddTransactionScreen({super.key});
  final _transactionTypes = [
    'Income',
    'Expense',
  ];
  final items = <DropdownMenuItem<String>>[
    DropdownMenuItem(value: 'Income', child: Text('Income')),
    DropdownMenuItem(value: 'Expense', child: Text('Expense')),
  ];
  String? selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Transaction"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "Title"),
            ),
            //type of transaction

            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedType ?? _transactionTypes[0],
              items: items,
              onChanged: (String? newValue) {
                // Logic to handle transaction type change
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Logic to add transaction
                Get.back();
              },
              child: Text("Add Transaction"),
            ),
          ],
        ),
      ),
    );
  }
}
