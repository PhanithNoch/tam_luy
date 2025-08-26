import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeService extends GetxService {
  final String _themeKey = "isDarkMode";
  var isDarkMode = false.obs;

  @override
  void onInit() {
    loadTheme();
    super.onInit();
  }

  /// void theme from storage
  void changeTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    // StorageService.write(_themeKey, isDarkMode.value);
    // print('isDarkMode.value: ${isDarkMode.value}');
  }

  void loadTheme() {
    // final isDark = StorageService.read(_themeKey);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    // if (isDark != null) {
    //   isDarkMode.value = isDark;
    //   Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    // } else {
    //   Get.changeThemeMode(ThemeMode.light);
    // }
  }

  ThemeMode getTheme() {
    return ThemeMode.light;
    // final darkMode = StorageService.read(_themeKey);
    // if (darkMode == null) return ThemeMode.light;
    // return darkMode ? ThemeMode.dark : ThemeMode.light;
  }
}
