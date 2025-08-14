import 'package:get/get.dart';

class CurrencySettingController extends GetxController {
  // convert amount between currencies

  double convertAmount(double amount, double fromRate, double toRate) {
    if (fromRate <= 0 || toRate <= 0) {
      throw ArgumentError('Exchange rates must be greater than zero');
    }
    return (amount / fromRate) * toRate;
  }
}
