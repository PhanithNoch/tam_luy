import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../controllers/settings/currency_setting_controller.dart';

class CurrencySettingScreen extends StatelessWidget {
  CurrencySettingScreen({super.key});
  final _controller = Get.put(CurrencySettingController());

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
