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

  // Thêm form key để xác thực form khi update
  final GlobalKey<FormState> updateSubscriptionPlanFormKey =
      GlobalKey<FormState>();

  // Controllers cho form update
  late TextEditingController updateNameController;
  late TextEditingController updatePriceController;
  late TextEditingController updateDurationController;
  late TextEditingController updateDescriptionController;

  // Biến để theo dõi trạng thái cập nhật
  var isUpdating = false.obs;
  var updateErrorString = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getSubscriptionPlanList();

    // Khởi tạo controllers
    updateNameController = TextEditingController();
    updatePriceController = TextEditingController();
    updateDurationController = TextEditingController();
    updateDescriptionController = TextEditingController();

    // Set up listener for search field
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();

    // Dispose update controllers
    updateNameController.dispose();
    updatePriceController.dispose();
    updateDurationController.dispose();
    updateDescriptionController.dispose();

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
    applyFilters();
    // applyFilters() will be called by the searchController listener
  }

  Future<void> deactivateSubscriptionPlan(int planId) async {
    var response =
        await SubscriptionPlanRepository.deactivateSubscriptionPlan(planId);
    if (response.statusCode == 200) {
      Get.snackbar(
        'Success',
        'Subscription plan Deactivated successfully',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        snackPosition: SnackPosition.BOTTOM,
      );
      await getSubscriptionPlanList();
    } else {
      //Xử lý lỗi
      updateErrorString.value = jsonDecode(response.body)['message'] ??
          "Error Deactivating subscription plan";
    }
  }

  // Phương thức để điền dữ liệu vào form update
  void prepareUpdateForm(SubscriptionPlanModel plan) {
    updateNameController.text = plan.name ?? '';
    updatePriceController.text = plan.price?.toString() ?? '';
    updateDurationController.text = plan.duration?.toString() ?? '';
    updateDescriptionController.text = plan.description ?? '';
  }

  // Phương thức để update subscription plan
  Future<void> updateSubscriptionPlan(int planId) async {
    isUpdating.value = true;
    updateErrorString.value = '';

    final isValid = updateSubscriptionPlanFormKey.currentState!.validate();
    if (!isValid) {
      isUpdating.value = false;
      return;
    }

    // Lấy dữ liệu từ các controllers
    String name = updateNameController.text;
    double price = double.parse(updatePriceController.text);
    int duration = int.parse(updateDurationController.text);
    String description = updateDescriptionController.text;

    // Tạo SubscriptionPlanModel mới để update
    SubscriptionPlanModel updatedPlan = SubscriptionPlanModel(
      name: name,
      price: price,
      duration: duration,
      description: description,
    );

    try {
      var response = await SubscriptionPlanRepository.updateSubscriptionPlan(
          planId, updatedPlan);

      if (response.statusCode == 200) {
        // Thành công
        Get.back(); // Đóng dialog
        Get.snackbar(
          'Success',
          'Subscription plan updated successfully',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
          snackPosition: SnackPosition.BOTTOM,
        );

        // Refresh danh sách để hiển thị dữ liệu mới
        await getSubscriptionPlanList();
      } else {
        // Xử lý lỗi
        updateErrorString.value = jsonDecode(response.body)['message'] ??
            "Error updating subscription plan";
      }
    } catch (e) {
      updateErrorString.value = "An error occurred: $e";
      print("Error in updateSubscriptionPlan: $e");
    } finally {
      isUpdating.value = false;
    }
  }

  // Các phương thức validation
  String? validateName(String value) {
    if (value.isEmpty) {
      return 'Please enter subscription plan name';
    }
    return null;
  }

  String? validatePrice(String value) {
    if (value.isEmpty) {
      return 'Please enter subscription plan price';
    }

    // Check if the input is a valid number
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number for the price';
    }

    return null;
  }

  String? validateDuration(String value) {
    if (value.isEmpty) {
      return 'Please enter subscription plan duration';
    }

    // Check if the input is a valid number
    if (int.tryParse(value) == null) {
      return 'Please enter a valid number for the duration';
    }

    return null;
  }

  String? validateDescription(String value) {
    if (value.isEmpty) {
      return 'Please enter subscription plan description';
    }
    return null;
  }
}
