import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/community_post_model.dart';
import '../repositories/community_post_repository.dart';
import '../util/app_export.dart';

class CommunityPostGuestController extends GetxController {
  final communityPostList = <CommunityPostModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Thêm thuộc tính cho search và filter
  final searchController = TextEditingController();
  var searchQuery = ''.obs;
  var selectedFilter = 'Recent'.obs;
  var filteredPostList = <CommunityPostModel>[].obs;

  @override
  Future<void> onInit() async {
    // Thêm listener cho search controller
    searchController.addListener(_onSearchChanged);

    await getCommunityPostGuestList();
    super.onInit();
  }

  @override
  void onClose() {
    // Dọn dẹp resources
    searchController.removeListener(_onSearchChanged);

    super.onClose();
  }

  // Xử lý khi nội dung search thay đổi
  void _onSearchChanged() {
    searchQuery.value = searchController.text;
    applyFilters();
  }

  // Thiết lập bộ lọc
  void setFilter(String filter) {
    selectedFilter.value = filter;
    applyFilters();
  }

  // Áp dụng tất cả các bộ lọc
  void applyFilters() {
    // Bắt đầu với tất cả bài viết active
    var result = communityPostList
        .where((post) => post.status?.toLowerCase() == 'active')
        .toList();

    // Đảm bảo searchQuery được cập nhật từ controller
    final currentQuery = searchController.text.toLowerCase();

    // Áp dụng bộ lọc tìm kiếm nếu có
    if (currentQuery.isNotEmpty) {
      result = result.where((post) {
        final titleMatch =
            post.title?.toLowerCase().contains(currentQuery) ?? false;
        final contentMatch =
            post.content?.toLowerCase().contains(currentQuery) ?? false;
        return titleMatch || contentMatch;
      }).toList();
    }

    // Áp dụng sắp xếp dựa trên bộ lọc đã chọn
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

    // Đảm bảo cập nhật searchQuery
    searchQuery.value = currentQuery;

    // Cập nhật danh sách đã lọc
    filteredPostList.value = result;
    update();
  }

  Future<void> getCommunityPostGuestList() async {
    isLoading.value = true;
    var response = await CommunityPostRepository.getCommunityPostGuestList();

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      List<CommunityPostModel> allPosts =
          communityPostModelFromJson(jsonResult);
      communityPostList.value =
          allPosts.where((post) => post.status == 'active').toList();

      // Áp dụng bộ lọc sau khi lấy dữ liệu
      applyFilters();
      searchController.addListener(_onSearchChanged);
    }
    isLoading.value = false;
  }

  void goToCommunityPostDetail(int index) async {
    final result = await Get.toNamed(
      AppRoutes.communitypostguestdetails,
      parameters: {
        'postId': filteredPostList[index].id.toString(),
      },
    );

    if (result == true) {
      await getCommunityPostGuestList();
    }
  }

  void navigateToLogin() {
    Get.toNamed(AppRoutes.login);
  }

  void navigateToSignUp() {
    Get.toNamed(AppRoutes.register);
  }

  void navigateToHome() {
    // Lưu trạng thái tìm kiếm hiện tại vào arguments
    Get.offAllNamed(
      AppRoutes.sidebarnarguest,
      arguments: {
        'selectedIndex': 1,
        'searchQuery': searchController.text,
      },
    );
  }

  List<CommunityPostModel> get activePostList => filteredPostList;
}
