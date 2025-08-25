import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tam_luy/models/transaction.dart';

class TransactionController extends GetxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String filterTransaction = "expense";
  final String _collectionName = "transactions";
  var isLoading = false.obs;
  var selectedIncome = RxString("");
  var selectedExpense = RxString("");
  var selectedType = RxString("income");
  FirebaseAuth _auth = FirebaseAuth.instance;

  RxList<TransactionFireStore> transactions = RxList();

  //category
  var incomeCategories = [
    'Salary',
    'Freelance',
    'Gift',
    'Business',
  ].obs;
  var expenseCategories = [
    'Shopping',
    'Food',
    'Entertainment',
    'Travel',
  ].obs;
  // income/expense
  var lstTypes = ['income', 'expense'].obs;
  void fetchTransactions() async {
    final snapshot = await _firestore
        .collection(_collectionName)
        .where('type', isEqualTo: filterTransaction)
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .get();
    transactions.value = snapshot.docs
        .map((doc) => TransactionFireStore.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  void onInit() {
    //init
    fetchTransactions();
    print("transaction ${transactions.value}");

    super.onInit();
  }

  void addTransaction({
    required String title,
    required num amount,
    String? description,
    required String type,
    required String currency,
    required String category,
    required DateTime date,
  }) async {
    try {
      // imp add transaction to firestore
      Map<String, dynamic> transaction = {
        'title': title,
        "description": description,
        "amount": amount,
        "type": type,
        "category": category,
        "date": date,
        "userId": _auth.currentUser!.uid ?? "",
      };

      await _firestore.collection(_collectionName).add(transaction);
      Get.snackbar("Success", "Add transaction Success");

      Get.defaultDialog(
          title: "Success",
          content: Text('Transaction Added'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // close dialog
                Get.back(result: true);
              },
              child: Text("Ok"),
            )
          ]);
    } on FirebaseAuthException catch (e) {
      Get.defaultDialog(
        title: "Error",
        content: Text(e.toString()),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // close dialog
            },
            child: Text("Ok"),
          )
        ],
      );
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
