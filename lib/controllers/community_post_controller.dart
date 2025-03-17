import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/controllers/account_profile_controller.dart';

import '../models/community_post_model.dart';
import '../repositories/community_post_repository.dart';
import '../routes/app_routes.dart';

class CommunityPostController extends GetxController {
  var isLoading = true.obs;
  var communityPostList = <CommunityPostModel>[].obs;
  var communityPostModel = CommunityPostModel().obs;

  // Add search properties
  final TextEditingController searchController = TextEditingController();
  var searchQuery = ''.obs;

  // Add filter property
  var selectedFilter = 'Recent'.obs;

  // Add filtered list
  var filteredPostList = <CommunityPostModel>[].obs;

  @override
  Future<void> onInit() async {
    // Set up search controller listener
    searchController.addListener(_onSearchChanged);
    await getCommunityPostList();
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

  void setFilter(String filter) {
    selectedFilter.value = filter;
    applyFilters();
    update();
  }

  void applyFilters() {
    // Start with all active posts
    var result = communityPostList
        .where((post) => post.status?.toLowerCase() == 'active')
        .toList();

    // Apply search filter if there's a query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((post) {
        final titleMatch = post.title?.toLowerCase().contains(query) ?? false;
        final contentMatch =
            post.content?.toLowerCase().contains(query) ?? false;
        return titleMatch || contentMatch;
      }).toList();
    }

    // Apply sorting based on selected filter
    switch (selectedFilter.value) {
      case 'Recent':
        result.sort((a, b) => b.createdDate!.compareTo(a.createdDate!));
        break;
      case 'Oldest':
        result.sort((a, b) => a.createdDate!.compareTo(b.createdDate!));
        break;
      case 'Most Comments':
        result.sort(
            (a, b) => (b.commentCount ?? 0).compareTo(a.commentCount ?? 0));
        break;
    }

    // Update filtered list
    filteredPostList.value = result;
    update();
  }

  Future<void> getCommunityPostList() async {
    isLoading.value = true;
    var response = await CommunityPostRepository.getCommunityPostList();

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      List<CommunityPostModel> allPosts =
          communityPostModelFromJson(jsonResult);
      communityPostList.value =
          allPosts.where((post) => post.status == 'active').toList();

      // Apply filters after loading
      applyFilters();
    } else if (response.statusCode == 401) {
      Get.snackbar("Error", "Unauthorized");
    } else if (response.statusCode == 403) {
      Get.snackbar("Not found", "No post found");
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }

  void goToCommunityPostOfUser() {
    // Get.toNamed(AppRoutes.communitypostofuser);
  }

  void goToCommunityPostDetail(int index) async {
    final result = await Get.toNamed(
      AppRoutes.communitypostdetails,
      arguments: {
        'postId': activePostList[index].id,
        'post': activePostList[index],
      },
    );

    // Nếu result là true (khi xóa bài viết), làm mới danh sách
    if (result == true) {
      await getCommunityPostList();
    }
  }

  void goToCreateCommunityPost() {
    // Lấy thông tin từ user info hiện tại
    final accountProfileController = Get.find<AccountProfileController>();
    final userId = accountProfileController.accountProfileModel.value.id;

    // Kiểm tra nếu đã đăng nhập
    if (userId == null) {
      Get.dialog(
        AlertDialog(
          title: const Text("Warning"),
          content: const Text("Please login to create a post"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Kiểm tra role - chặn ROLE_USER không cho tạo post
    if (accountProfileController.isRegularUser()) {
      Get.dialog(
        AlertDialog(
          title: const Text("Permission Denied"),
          content: const Text(
              "Regular users cannot create posts. Please subscribe to Premium to create posts."),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Nếu không phải ROLE_USER, cho phép tạo post
    Get.toNamed(AppRoutes.createcommunitypost, arguments: {'userId': userId})
        ?.then((value) => {
              if (value != null && value) {getCommunityPostList()}
            });
  }

  void goToUpdateCommunityPost(int index) {
    // Get.toNamed(AppRoutes.updatecommunitypost,
    //     arguments: communityPostList[index]);
  }

  void getBack() {
    Get.back();
  }

  List<CommunityPostModel> get activePostList => filteredPostList;
}
