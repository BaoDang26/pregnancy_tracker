import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/util/app_export.dart';

import '../models/subscription_plan_model.dart';
import '../repositories/account_profile_repository.dart';
import '../repositories/subscription_plan_repository.dart';

class SubscriptionPlanController extends GetxController {
  var isLoading = true.obs;
  var subscriptionPlanModel = SubscriptionPlanModel().obs;
  var userRole = ''.obs;
  var userId = 0.obs;
  var activeSubscriptionPlanList = <SubscriptionPlanModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // getSubscriptionPlans();
    getUserRole();
    getActiveSubscriptionPlanList();
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

  Future<void> getActiveSubscriptionPlanList() async {
    isLoading.value = true;
    var response = await SubscriptionPlanRepository.getSubscriptionPlanList();

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      List<SubscriptionPlanModel> allPlans =
          subscriptionPlanModelFromJson(jsonResult);

      // Lọc chỉ lấy các plan có status = "Active"
      activeSubscriptionPlanList.value =
          allPlans.where((plan) => plan.status == 'Active').toList();

      print("Total plans: ${allPlans.length}");
      print("Active plans: ${activeSubscriptionPlanList.length}");
    } else {
      Get.snackbar(
        "Error",
        "Failed to load subscription plans",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }

    isLoading.value = false;
    update();
  }

  void goToSubscriptionPlanDetail(int index) {
    Get.toNamed(AppRoutes.subscriptionplandetail,
        arguments: activeSubscriptionPlanList[index].id);
  }

  void getBack() {
    Get.back();
  }
}
