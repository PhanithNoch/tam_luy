import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tam_luy/views/home/home_screen.dart';

class LoginController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;

  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    // _auth.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //   } else {
    //     print('User is signed in!');
    //     Get.offAll(() => HomeScreen());
    //   }
    // });
    super.onInit();
  }

  void signIn({required String email, required String password}) async {
    try {
      isLoading(true);
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // continue
      Get.offAll(HomeScreen());
    } on FirebaseAuthException catch (e) {
      Get.defaultDialog(
        title: "Error",
        content: Text(e.toString()),
        actions: [
          TextButton(
              onPressed: () {
                Get.back(); // close dialog
              },
              child: Text("Ok"))
        ],
      );
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
