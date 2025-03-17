import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/user_subscription_model.dart';
import '../repositories/user_subscription_repository.dart';
import '../util/app_export.dart';

class ManageUserSubscriptionController extends GetxController {
  var isLoading = true.obs;
  var userSubscriptionList = <UserSubscriptionModel>[].obs;
  var filteredUserSubscriptionList = <UserSubscriptionModel>[].obs;
  var userSubscription = UserSubscriptionModel().obs;

  // Search and filter controllers
  final searchController = TextEditingController();
  var searchQuery = ''.obs;

  // Add to ManageUserSubscriptionController class
  var currentStatusFilter = 'all'.obs;

  @override
  void onInit() async {
    await getAllUserSubscription();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.onClose();
  }

  void onSearchChanged() {
    searchQuery.value = searchController.text;
    applyFilters();
  }

  void setStatusFilter(String status) {
    currentStatusFilter.value = status;
    applyFilters();
  }

  void applyFilters() {
    // First reset to full list
    var tempList = List<UserSubscriptionModel>.from(userSubscriptionList);

    // Apply search filter if any
    if (searchQuery.value.isNotEmpty) {
      tempList = tempList
          .where((subscription) => subscription.subscriptionPlanName!
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Apply status filter if not 'all'
    if (currentStatusFilter.value != 'all') {
      switch (currentStatusFilter.value) {
        case 'payment_pending':
          tempList = tempList
              .where((subscription) =>
                  subscription.status?.toUpperCase() == 'PAYMENT_PENDING')
              .toList();
          break;
        case 'payment_failed':
          tempList = tempList
              .where((subscription) =>
                  subscription.status?.toUpperCase() == 'PAYMENT_FAILED')
              .toList();
          break;
        case 'payment_success':
          tempList = tempList
              .where((subscription) =>
                  subscription.status?.toUpperCase() == 'PAYMENT_SUCCESS')
              .toList();
          break;
        case 'pending':
          tempList = tempList
              .where((subscription) =>
                  subscription.status?.toUpperCase() == 'PENDING')
              .toList();
          break;
        case 'finished':
          tempList = tempList
              .where((subscription) =>
                  subscription.status?.toUpperCase() == 'FINISHED')
              .toList();
          break;
        case 'active':
          tempList = tempList
              .where((subscription) =>
                  subscription.endDate != null &&
                  subscription.endDate!.isAfter(DateTime.now()))
              .toList();
          break;
        case 'expired':
          tempList = tempList
              .where((subscription) =>
                  subscription.endDate != null &&
                  subscription.endDate!.isBefore(DateTime.now()))
              .toList();
          break;
      }
    }

    // Update the filtered list
    filteredUserSubscriptionList.value = tempList;
  }

  Future<void> getAllUserSubscription() async {
    isLoading.value = true;
    var response = await UserSubscriptionRepository.getAllUserSubscription();
    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      userSubscriptionList.value = userSubscriptionModelFromJson(jsonResult);
      filteredUserSubscriptionList.value = userSubscriptionList;
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
      print("Error server ${response.statusCode}");
      print("Error body ${response.body}");
    }
    isLoading.value = false;
    update();
  }
}
