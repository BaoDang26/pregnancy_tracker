import '../models/community_post_model.dart';
import '../repositories/community_post_repository.dart';
import '../util/app_export.dart';

class CommunityPostGuestController extends GetxController {
  final communityPostList = <CommunityPostModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  Future<void> onInit() async {
    await getCommunityPostGuestList();
    super.onInit();
  }

  Future<void> getCommunityPostGuestList() async {
    isLoading.value = true;
    var response = await CommunityPostRepository.getCommunityPostGuestList();

    if (response.statusCode == 200) {
      communityPostList.value = communityPostModelFromJson(response.body);
    }
    isLoading.value = false;
  }

  void goToCommunityPostDetail(int index) async {
    final result = await Get.toNamed(
      AppRoutes.communitypostguestdetails,
      arguments: {
        'postId': communityPostList[index].id,
        'post': activePostList[index],
      },
    );

    // Nếu result là true (khi xóa bài viết), làm mới danh sách
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

  List<CommunityPostModel> get activePostList => communityPostList
      .where((post) => post.status?.toLowerCase() == 'active')
      .toList();
}
