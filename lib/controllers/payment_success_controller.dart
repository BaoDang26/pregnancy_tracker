import 'package:get/get.dart';

import '../util/app_export.dart';

class PaymentSuccessController extends GetxController {
  void onInit() {
    super.onInit();
  }

  void goToHomeScreen() {
    if (PrefUtils.getAccessToken() != null) {
      Get.offAllNamed(AppRoutes.sidebarnar);
      return;
    }

    Get.offAllNamed(AppRoutes.login);
  }
}
