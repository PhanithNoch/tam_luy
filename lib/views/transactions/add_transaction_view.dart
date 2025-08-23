import 'package:flutter/material.dart';
import 'package:tam_luy/controllers/transactions/transaction_controller.dart';
import 'package:get/get.dart';

class AddTransactionView extends StatelessWidget {
  AddTransactionView({super.key});
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateTimeController = TextEditingController();
  final _controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Transaction"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // expense or income
            DropdownButtonFormField(
              // value: _controller.selectedType.value,
              items: _controller.lstTypes.value.isEmpty
                  ? null
                  : _controller.lstTypes.value
                      .map(
                        (type) => DropdownMenuItem(
                          child: Text(type),
                          value: type,
                        ),
                      )
                      .toList(),
              onChanged: (selected) {
                _controller.selectedType.value = selected!;
              },
            ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Title",
              ),
            ),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                hintText: "Amount",
              ),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: "Description",
              ),
            ),
            TextFormField(
              controller: _dateTimeController,
              decoration: InputDecoration(
                hintText: "Date Time",
              ),
            ),
            //category
            Obx(() {
              if (_controller.selectedType.value == "income") {
                return DropdownButtonFormField<String>(
                  value: _controller.incomeCategories
                          .contains(_controller.selectedIncome.value)
                      ? _controller.selectedIncome.value
                      : null, // only set if valid
                  items: _controller.incomeCategories
                      .map((cat) => DropdownMenuItem<String>(
                            value: cat,
                            child: Text(cat),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _controller.selectedIncome.value = value;
                    }
                  },
                );
              }

              return DropdownButtonFormField<String>(
                value: _controller.expenseCategories
                        .contains(_controller.selectedExpense.value)
                    ? _controller.selectedExpense.value
                    : null,
                items: _controller.expenseCategories
                    .map((cat) => DropdownMenuItem<String>(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    _controller.selectedExpense.value = value;
                  }
                },
              );
            }),

            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    final title = _titleController.text;
                    final amount = _amountController.text; // string
                    final type = _controller.selectedType.value;
                    final category = _controller.selectedIncome.value.isNotEmpty
                        ? "Income"
                        : "Expense";
                    _controller.addTransaction(
                      title: title,
                      amount: num.parse(amount),
                      type: type,
                      currency: "USD",
                      category: category,
                      date: DateTime.timestamp(),
                    );
                  },
                  child: Text(
                    "Add Transaction",
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
