import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../util/app_export.dart';

class ManageUserController extends GetxController {
  var isLoading = true.obs;
  var userList = <UserModel>[].obs;
  var filteredUserList = <UserModel>[].obs;
  var user = UserModel().obs;

  // Search and filter controllers
  final searchController = TextEditingController();
  var searchQuery = ''.obs;
  var selectedRole = 'All Roles'.obs;
  var selectedStatus = 'All Statuses'.obs;

  @override
  void onInit() async {
    await getListUser();
    // Set up listeners for search field
    searchController.addListener(_onSearchChanged);
    super.onInit();
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

  Future<void> getListUser() async {
    isLoading.value = true;
    var response = await UserRepository.getAllUser();
    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      userList.value = userModelFromJson(jsonResult);
      applyFilters(); // Apply filters after loading users
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }

  Future<void> updateStatusUser(int id) async {
    isLoading.value = true;
    var response = await UserRepository.updateStatusUser(id);
    if (response.statusCode == 200) {
      Get.snackbar("Success", "Update status user success");
      await getListUser();
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }

  // Set role filter
  void setRoleFilter(String role) {
    selectedRole.value = role;
    applyFilters();
  }

  // Set status filter
  void setStatusFilter(String status) {
    selectedStatus.value = status;
    applyFilters();
  }

  // Apply all filters to the user list
  void applyFilters() {
    filteredUserList.value = userList.where((user) {
      // Text search filter (case insensitive)
      bool matchesSearch = searchQuery.isEmpty ||
          (user.fullName
                  ?.toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ??
              false) ||
          (user.email
                  ?.toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ??
              false);

      // Role filter
      bool matchesRole = selectedRole.value == 'All Roles' ||
          user.roleName == selectedRole.value;

      // Status filter
      bool matchesStatus = selectedStatus.value == 'All Statuses' ||
          user.status == selectedStatus.value;

      // User must match all active filters
      return matchesSearch && matchesRole && matchesStatus;
    }).toList();
  }

  // Clear all filters
  void clearFilters() {
    searchController.clear();
    selectedRole.value = 'All Roles';
    selectedStatus.value = 'All Statuses';
    applyFilters();
  }

  void logOut() {
    PrefUtils.setAccessToken('');
    PrefUtils.setRefreshToken('');
    Get.offAllNamed(AppRoutes.login);
  }
}
