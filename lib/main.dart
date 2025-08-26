import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tam_luy/controllers/login_controller.dart';
import 'package:tam_luy/themes/app_theme.dart';
import 'package:tam_luy/themes/theme_service.dart';
import 'package:tam_luy/views/home/home_screen.dart';
import 'package:tam_luy/views/login_screen.dart';

import 'controllers/auth_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(LoginController());
  runApp(MyApp());
  // Get.put(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _themeService = Get.put(ThemeService(), permanent: true);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: _themeService.getTheme(),
        home: GetBuilder<AuthController>(builder: (logic) {
          if (logic.currentUser != null) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        }));
  }
}
