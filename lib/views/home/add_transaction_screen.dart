import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tam_luy/models/transaction.dart';

import '../../controllers/transactions/transaction_controller.dart';

class AddTransactionScreen extends StatelessWidget {
  AddTransactionScreen({super.key});

  final items = <DropdownMenuItem<String>>[
    DropdownMenuItem(value: 'Income', child: Text('Income')),
    DropdownMenuItem(value: 'Expense', child: Text('Expense')),
  ];
  final _controller = Get.put(TransactionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Transaction"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return Row(
                children: [
                  Expanded(
                    child: RadioListTile<TransactionType>(
                      title: const Text("Income"),
                      value: TransactionType.income,
                      groupValue: _controller.selectedType.value,
                      onChanged: (TransactionType? value) {
                        _controller.selectedType.value = value!;
                        _controller.selectedCategory.value =
                            _controller.incomeCategories[0];
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<TransactionType>(
                      title: const Text("Expense"),
                      value: TransactionType.expense,
                      groupValue: _controller.selectedType.value,
                      onChanged: (TransactionType? value) {
                        _controller.selectedType.value = value!;
                        _controller.selectedCategory.value =
                            _controller.expenseCategories[0];
                      },
                    ),
                  ),
                ],
              );
            }),
            SizedBox(height: 16),
            TextFormField(
              controller: _controller.titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            //type of transaction

            SizedBox(height: 16),
            TextFormField(
              controller: _controller.amountController,
              decoration: InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Obx(() {
              final isIncomeSelected =
                  _controller.selectedType.value == TransactionType.income;
              final categories = isIncomeSelected
                  ? _controller.incomeCategories
                  : _controller.expenseCategories;
              return DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                items: categories
                    .map(
                      (category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                value: _controller.selectedCategory.value == ''
                    ? categories[0]
                    : _controller.selectedCategory.value,
                onChanged: (value) {
                  _controller.selectedCategory.value = value as String;
                },
              );
            }),
            SizedBox(height: 16),

            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: "Currency",
                border: OutlineInputBorder(),
              ),
              value: _controller.selectedCurrency.value,
              items: Currency.supportedCurrencies
                  .map(
                    (currency) => DropdownMenuItem<Currency>(
                      value: currency,
                      child: Text(currency.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                _controller.selectedCurrency.value = value as Currency;
              },
            ),
            SizedBox(height: 16),
            Obx(() {
              return InkWell(
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Date",
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    "${_controller.selectedDate.value.day}/${_controller.selectedDate.value.month}/${_controller.selectedDate.value.year}",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: _controller.selectedDate.value,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  ).then((date) {
                    if (date != null) {
                      _controller.selectedDate.value = date;
                    }
                  });
                },
              );
            }),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: "Description (Optional)"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Logic to add transaction
                final transaction = TransactionFirestore(
                  title: _controller
                      .titleController.text, // Replace with actual input
                  amount:
                      double.tryParse(_controller.amountController.text) ?? 0.0,
                  type: _controller.selectedType.value,
                  category: _controller.selectedCategory.value,
                  date: _controller.selectedDate.value,
                  currency: _controller.selectedCurrency.value.code,
                );
                _controller.addTransaction(transaction);
              },
              child: Text("Add Transaction"),
            ),
          ],
        ),
      ),
    );
  }
}
