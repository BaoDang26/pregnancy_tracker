import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/comment_model.dart';
import '../models/community_post_model.dart';
import '../repositories/comment_repository.dart';
import '../repositories/community_post_repository.dart';
import '../routes/app_routes.dart';
import '../util/app_export.dart';

class CommunityPostGuestDetailsController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  Rx<CommunityPostModel> communityPost = CommunityPostModel().obs;
  RxList<CommentModel> comments = RxList<CommentModel>([]);
  late int postId;

  @override
  void onInit() {
    super.onInit();

    postId = int.parse(Get.parameters['postId']!);

    fetchPostDetails();
  }

  // Thêm phương thức để fetch lại toàn bộ thông tin bài viết
  Future<void> fetchPostDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response =
          await CommunityPostRepository.getCommunityPostGuestById(postId);
      print(response.body);
      if (response.statusCode == 200) {
        String jsonResult = utf8.decode(response.bodyBytes);
        final decodedData = json.decode(jsonResult);

        communityPost.value = CommunityPostModel.fromJson(decodedData);

        // Cập nhật danh sách comments từ API riêng
        await fetchComments();
      } else {
        String message = 'Failed to load post details';
        try {
          final decodedData = json.decode(response.body);
          message = decodedData['message'] ?? message;
        } catch (_) {}

        errorMessage.value = 'Error: ${response.statusCode} - $message';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      print('Error fetching post details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Lấy danh sách comments
  Future<void> fetchComments() async {
    try {
      isLoading.value = true;
      var response =
          await CommentRepository.getCommentListGuestByPostId(postId);

      if (response.statusCode == 200) {
        String jsonResult = utf8.decode(response.bodyBytes);
        comments.value = commentModelFromJson(jsonResult);
      } else {
        errorMessage.value = "Failed to load comments. Please try again later.";
      }
    } catch (e) {
      errorMessage.value = "Network error. Please check your connection.";
    } finally {
      isLoading.value = false;
    }
  }

  // Chuyển hướng đến trang đăng nhập
  void navigateToLogin() {
    Get.offNamed(AppRoutes.login);
  }

  // Chuyển hướng đến trang đăng ký
  void navigateToSignUp() {
    Get.offNamed(AppRoutes.register);
  }

  // Định dạng ngày tháng
  String formatDate(DateTime? date) {
    if (date == null) return 'Unknown date';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      if (difference.inHours < 1) {
        return '${difference.inMinutes} minute${difference.inMinutes != 1 ? 's' : ''} ago';
      }
      return '${difference.inHours} hour${difference.inHours != 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays != 1 ? 's' : ''} ago';
    } else {
      return DateFormat('MMM d, yyyy • h:mm a').format(date);
    }
  }

  // Hiển thị dialog khuyến khích đăng nhập khi người dùng khách muốn tương tác
  void showLoginPromptDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.forum_outlined,
                size: 60,
                color: Color(0xFFAD6E8C),
              ),
              const SizedBox(height: 20),
              const Text(
                'Join Our Community',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF614051),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Sign in or create an account to comment on posts and connect with other parents!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back(); // Đóng dialog
                        navigateToLogin();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF8E6C88),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Sign In'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // Đóng dialog
                        navigateToSignUp();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAD6E8C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Phương thức để hiển thị khi người dùng muốn thêm comment
  void promptToAddComment() {
    showLoginPromptDialog();
  }

  void navigateToHome() {
    // Giữ lại trạng thái tìm kiếm nếu cần
    Get.offAllNamed(AppRoutes.sidebarnarguest, arguments: {'selectedIndex': 1});
  }
}
