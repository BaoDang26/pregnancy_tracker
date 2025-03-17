import 'dart:convert';

import '../models/subscription_plan_model.dart';
import '../repositories/subscription_plan_repository.dart';
import '../util/app_export.dart';

class SubscriptionPlanGuestController extends GetxController {
  var isLoading = true.obs;
  var subscriptionPlanList = <SubscriptionPlanModel>[].obs;
  var subscriptionPlanModel = SubscriptionPlanModel().obs;

  @override
  Future<void> onInit() async {
    await getSubscriptionPlanGuestList();
    super.onInit();
  }

  Future<void> getSubscriptionPlanGuestList() async {
    isLoading.value = true;
    var response =
        await SubscriptionPlanRepository.getSubscriptionGuestPlanList();

    // Log the response status and body
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      List<SubscriptionPlanModel> allPlans =
          subscriptionPlanModelFromJson(jsonResult);

      // Lọc chỉ lấy các plan có status = "Active"
      subscriptionPlanList.value =
          allPlans.where((plan) => plan.status == 'Active').toList();
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }

  void goToLogin() {
    Get.toNamed(AppRoutes.login);
  }

  void getBack() {
    Get.back();
  }
}
