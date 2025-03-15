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

  @override
  Future<void> onInit() async {
    await getCommunityPostList();
    super.onInit();
  }

  Future<void> getCommunityPostList() async {
    isLoading.value = true;
    var response = await CommunityPostRepository.getCommunityPostList();

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      communityPostList.value = communityPostModelFromJson(jsonResult);
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
    // Lấy thông tin userId từ user info hiện tại
    final accountProfileController = Get.find<AccountProfileController>();
    final userId = accountProfileController.accountProfileModel.value.id;

    // Kiểm tra nếu đã có userId
    if (userId != null) {
      // Chuyển trang và truyền arguments
      Get.toNamed(AppRoutes.createcommunitypost, arguments: {'userId': userId})
          ?.then((value) => {
                if (value != null && value) {getCommunityPostList()}
              });
    } else {
      // Xử lý trường hợp chưa đăng nhập hoặc không có userId
      Get.snackbar("Warning", "Please login to create a post",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xFFAD6E8C).withOpacity(0.8),
          colorText: Colors.white);
    }
  }

  void goToUpdateCommunityPost(int index) {
    // Get.toNamed(AppRoutes.updatecommunitypost,
    //     arguments: communityPostList[index]);
  }

  void getBack() {
    Get.back();
  }

  List<CommunityPostModel> get activePostList => communityPostList
      .where((post) => post.status?.toLowerCase() == 'active')
      .toList();
}
