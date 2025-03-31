import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/controllers/account_profile_controller.dart';

import '../models/community_post_model.dart';
import '../repositories/community_post_repository.dart';
import '../routes/app_routes.dart';
import '../util/app_export.dart';

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
    communityPostList.clear();
    var response = await CommunityPostRepository.getCommunityPostList();

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      List<CommunityPostModel> allPosts =
          communityPostModelFromJson(jsonResult);
      communityPostList.value =
          allPosts.where((post) => post.status == 'active').toList();

      // Apply filters after loading
      applyFilters();
      searchController.addListener(_onSearchChanged);
    } else if (response.statusCode == 401) {
      String message = jsonDecode(response.body)['message'];
      if (message.contains("JWT token is expired")) {
        Get.snackbar('Session Expired', 'Please login again');
      }
    } else if (response.statusCode == 403) {
      var errorData = jsonDecode(response.body);
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }

  void goToCommunityPostDetail(int index) async {
    final result = await Get.toNamed(
      AppRoutes.communitypostdetails,
      parameters: {
        'postId': activePostList[index].id.toString(),
        'post': activePostList[index].toString(),
      },
      // arguments: {
      //   'postId': activePostList[index].id,
      //   'post': activePostList[index],
      // },
    );

    // Nếu result là true (khi xóa bài viết), làm mới danh sách
    if (result == true) {
      await getCommunityPostList();
    }
  }

  void goToCreateCommunityPost() async {
    final accountProfile = Get.find<AccountProfileController>();
    final userId = accountProfile.accountProfileModel.value.id;
    // Kiểm tra role - chặn ROLE_USER không cho tạo post
    if (PrefUtils.getUserRole() == 'ROLE_USER') {
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
    final result = await Get.toNamed(
      AppRoutes.createcommunitypost,
      parameters: {
        'userId': userId.toString(),
      },
    );
    if (result == true) {
      await getCommunityPostList();
    }
  }

  void goToUpdateCommunityPost(CommunityPostModel post) async {
    final accountProfile = Get.find<AccountProfileController>();
    final userId = accountProfile.accountProfileModel.value.id;

    // Kiểm tra nếu người dùng hiện tại là tác giả của bài viết
    if (post.userId != userId) {
      Get.dialog(
        AlertDialog(
          title: const Text("Permission Denied"),
          content: const Text("You can only edit your own posts."),
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

    // Chuyển đến màn hình cập nhật bài viết
    final result =
        await Get.toNamed(AppRoutes.updatecommunitypost, parameters: {
      'postId': post.id.toString(),
      'post': post.toString(),
      'userId': userId.toString(),
    });
    if (result == true) {
      await getCommunityPostList();
    }
  }

  void showDeleteConfirmation(int postId) {
    // Lấy thông tin từ user info hiện tại
    final accountProfile = Get.find<AccountProfileController>();
    final userId = accountProfile.accountProfileModel.value.id;

    // Tìm bài viết với ID tương ứng
    final post = filteredPostList.firstWhere((post) => post.id == postId);

    // Kiểm tra nếu người dùng hiện tại là tác giả của bài viết
    if (post.userId != userId) {
      Get.dialog(
        AlertDialog(
          title: const Text("Permission Denied"),
          content: const Text("You can only delete your own posts."),
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

    // Hiển thị dialog xác nhận xóa
    Get.dialog(
      AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text(
            "Are you sure you want to delete this post? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              deleteCommunityPost(postId);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Future<void> deleteCommunityPost(int postId) async {
    isLoading.value = true;

    try {
      var response = await CommunityPostRepository.deleteCommunityPost(postId);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Post has been deleted successfully",
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
          snackPosition: SnackPosition.TOP,
        );

        Get.offAllNamed(AppRoutes.sidebarnar, arguments: {'selectedIndex': 1});
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete post: ${jsonDecode(response.body)['message'] ?? 'Unknown error'}",
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void getBack() {
    Get.back();
  }

  List<CommunityPostModel> get activePostList => filteredPostList;
}
