import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tam_luy/views/login_screen.dart';

class HomeController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign out
  void _performSignOut() async {
    await _auth.signOut(); // remove token
    // go back to login by navigate to
    Get.offAll(() => LoginScreen());
  }

  void confirmSignOutDialog() {
    Get.defaultDialog(
        title: "Sign out",
        content: Text("Are you sure you want to sign Out"),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
                _performSignOut(); //
              },
              child: Text('Sign Out')),
          TextButton(
              onPressed: () {
                Get.back(); // close dialog
              },
              child: Text('Cancel'))
        ]);
  }
}
