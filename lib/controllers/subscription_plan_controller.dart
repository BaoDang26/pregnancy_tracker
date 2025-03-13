import 'dart:convert';

import 'package:pregnancy_tracker/util/app_export.dart';

import '../models/subscription_plan_model.dart';
import '../repositories/account_profile_repository.dart';
import '../repositories/subscription_plan_repository.dart';

class SubscriptionPlanController extends GetxController {
  var isLoading = true.obs;
  var subscriptionPlanList = <SubscriptionPlanModel>[].obs;
  var subscriptionPlanModel = SubscriptionPlanModel().obs;
  var userRole = ''.obs;
  var userId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getSubscriptionPlans();
    getUserRole();
  }

  Future<void> getSubscriptionPlans() async {
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

  Future<void> getUserRole() async {
    try {
      var response = await AccountProfileRepository.getAccountProfile();

      if (response.statusCode == 200) {
        var userData = json.decode(response.body);

        if (userData != null && userData['roleName'] != null) {
          userRole.value = userData['roleName'];
        }
      }
    } catch (e) {
      print('Error getting user role: $e');
    }
  }

  Future<void> getUserId() async {
    try {
      var response = await AccountProfileRepository.getAccountProfile();

      if (response.statusCode == 200) {
        var userData = json.decode(response.body);

        if (userData != null && userData['userId'] != null) {
          userId.value = userData['userId'];
        }
      }
    } catch (e) {
      print('Error getting user id: $e');
    }
  }

  void goToSubscriptionPlanDetail(int index) {
    Get.toNamed(AppRoutes.subscriptionplandetail,
        arguments: subscriptionPlanList[index].id);
  }

  void getBack() {
    Get.back();
  }
}
