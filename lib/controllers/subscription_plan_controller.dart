import 'dart:convert';

import 'package:pregnancy_tracker/util/app_export.dart';

import '../models/subscription_plan_model.dart';
import '../repositories/subscription_plan_repository.dart';

class SubscriptionPlanController extends GetxController {
  var isLoading = true.obs;
  var subscriptionPlanList = <SubscriptionPlanModel>[].obs;
  var subscriptionPlanModel = SubscriptionPlanModel().obs;

  @override
  Future<void> onInit() async {
    await getSubscriptionPlanList();
    super.onInit();
  }

  Future<void> getSubscriptionPlanList() async {
    isLoading.value = true;
    var response = await SubscriptionPlanRepository.getSubscriptionPlanList();

    // Log the response status and body
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      // Log the JSON result
      print("JSON Result: $jsonResult");

      // Convert JSON to model
      subscriptionPlanList.value = subscriptionPlanModelFromJson(jsonResult);
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }

  void goToSubscriptionPlanDetail(int index) {
    Get.toNamed(AppRoutes.subscriptionplandetail,
        arguments: subscriptionPlanList[index].id);
  }

  void getBack() {
    Get.back();
  }
}
