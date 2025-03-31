import 'package:get/get.dart';

import '../util/app_export.dart';

class PaymentSuccessController extends GetxController {
  RxBool isPaymentSuccess = false.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      print("Get.arguments is not null");
      isPaymentSuccess.value = true;
    }
    print("isPaymentSuccess: $isPaymentSuccess");
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
