import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tam_luy/views/home/home_screen.dart';
import 'package:tam_luy/views/login_screen.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<User?> user = Rx<User?>(null);

  @override
  onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
    user.listen((User? user) {
      if (user != null) {
        print("User is signed in: ${user.email}");
        print("User ID: ${user.uid}");
        // Get.to(() => HomeScreen());
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      Get.to(() => HomeScreen());

      Get.snackbar('Success', 'Signed in successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  //signOut method to log out the user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.snackbar(
        'Success',
        'Signed out successfully',
        snackPosition: SnackPosition.BOTTOM,
        snackbarStatus: (status) {
          if (status == SnackbarStatus.CLOSED) {
            Get.to(() => LoginScreen()); // Redirect to login screen
          }
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
