import 'dart:convert';

import 'package:get/get.dart';

import '../models/community_post_model.dart';
import '../repositories/community_post_repository.dart';

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

  void goToCommunityPostDetail(int index) {
    // Get.toNamed(AppRoutes.communitypostdetails,
    //     arguments: communityPostList[index]);
  }

  void goToCreateCommunityPost() {
    // Get.toNamed(AppRoutes.createcommunitypost)?.then((value) => {
    //       if (value != null && value) {getCommunityPostList()}
    //     });
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
