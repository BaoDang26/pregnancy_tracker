import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/util/app_export.dart';

import '../models/subscription_plan_model.dart';
import '../repositories/subscription_plan_repository.dart';

class ManageSubscriptionPlanController extends GetxController {
  var subscriptionPlanList = <SubscriptionPlanModel>[].obs;
  var filteredSubscriptionPlanList = <SubscriptionPlanModel>[].obs;
  var subscriptionPlanModel = SubscriptionPlanModel().obs;
  var isLoading = true.obs;

  // Search and filter controllers
  final searchController = TextEditingController();
  var searchQuery = ''.obs;
  var selectedStatus = 'All'.obs; // New status filter variable

  @override
  void onInit() {
    super.onInit();
    getSubscriptionPlanList();

    // Set up listener for search field
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.onClose();
  }

  void _onSearchChanged() {
    searchQuery.value = searchController.text;
    applyFilters();
  }

  Future<void> getSubscriptionPlanList() async {
    isLoading.value = true;
    var response = await SubscriptionPlanRepository.getSubscriptionPlanList();
    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      subscriptionPlanList.value = subscriptionPlanModelFromJson(jsonResult);

      // Initialize filtered list with all items
      filteredSubscriptionPlanList.value = subscriptionPlanList;
    }
    isLoading.value = false;
    update();
  }

  void goToCreateSubscriptionPlan() {
    Get.toNamed(AppRoutes.createSubscriptionPlan);
  }

  // Set status filter
  void setStatusFilter(String status) {
    selectedStatus.value = status;
    applyFilters();
  }

  // Apply all filters (both search and status)
  void applyFilters() {
    filteredSubscriptionPlanList.value = subscriptionPlanList.where((plan) {
      // Apply text search filter
      bool matchesSearch = true;
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();

        // Search in name
        final nameMatch = plan.name?.toLowerCase().contains(query) ?? false;

        // Search in description
        final descMatch =
            plan.description?.toLowerCase().contains(query) ?? false;

        // Search in price (convert to string first)
        final priceMatch = plan.price.toString().contains(query);

        // Search in duration (convert to string first)
        final durationMatch = plan.duration.toString().contains(query);

        matchesSearch = nameMatch || descMatch || priceMatch || durationMatch;
      }

      // Apply status filter
      bool matchesStatus = true;
      if (selectedStatus.value != 'All') {
        matchesStatus = plan.status == selectedStatus.value;
      }

      // Plan must match both filters
      return matchesSearch && matchesStatus;
    }).toList();
  }

  // Clear all filters
  void clearFilters() {
    searchController.clear();
    selectedStatus.value = 'All';
    // applyFilters() will be called by the searchController listener
  }
}
