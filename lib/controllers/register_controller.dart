import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;

  // register an account

  void register({required String email, required String password}) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.sendEmailVerification();
      Get.defaultDialog(
        title: "Success",
        content: Text("User register successful"),
        actions: [
          TextButton(
              onPressed: () {
                Get.back(); // close dialog
                Get.back(); // login screen
              },
              child: Text("Ok"))
        ],
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        errorMessage = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        errorMessage = "The account already exists for that email.";
      }
      Get.defaultDialog(
        title: "Error",
        content: Text(errorMessage),
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
    }
  }
}
