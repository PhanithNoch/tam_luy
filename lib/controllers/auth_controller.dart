import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  User? currentUser; // Simple state manager
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    // TODO: implement onInit
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        currentUser = user;
        print("is email verified ${_auth.currentUser!.emailVerified}");
        // if (_auth.currentUser!.emailVerified == false) {
        //   currentUser = null;
        //   //alert user
        //   Get.defaultDialog(
        //     title: "Email is not verified. Please verify your email.",
        //     content:
        //         Text("Verification email resent. Please check your inbox."),
        //   );
        // }
        update();
      }
    });
    super.onInit();
  }
}
