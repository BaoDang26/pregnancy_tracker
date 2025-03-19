import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pregnancy_tracker/controllers/account_profile_controller.dart';
import 'package:pregnancy_tracker/controllers/community_post_controller.dart';
import '../models/community_post_model.dart';
import '../models/comment_model.dart';
import '../repositories/comment_repository.dart';
import '../repositories/community_post_repository.dart';
import '../util/app_export.dart';

class CommunityPostDetailsController extends GetxController {
  // Observable variables cho post detail
  final communityPost = Rx<CommunityPostModel?>(null);
  final comments = RxList<CommentModel>([]);
  final isLoading = RxBool(false);
  final errorMessage = RxString('');

  // Variables cho thêm comment
  late TextEditingController commentController;
  final isSubmittingComment = RxBool(false);
  final commentFormKey = GlobalKey<FormState>();

  // Variables cho cập nhật comment
  late TextEditingController updateCommentController;
  final isUpdatingComment = RxBool(false);
  final updateCommentFormKey = GlobalKey<FormState>();
  final editingCommentId = RxInt(-1); // Lưu ID của comment đang edit

  // ID của bài viết hiện tại
  late int postId;

  @override
  void onInit() {
    super.onInit();

    // Khởi tạo controllers
    commentController = TextEditingController();
    updateCommentController = TextEditingController();

    // Lấy thông tin bài viết từ arguments
    if (Get.arguments != null) {
      // Lấy CommunityPostModel trực tiếp từ arguments
      if (Get.arguments is CommunityPostModel) {
        // Gán trực tiếp model từ argument
        communityPost.value = Get.arguments as CommunityPostModel;
        postId = communityPost.value!.id!;

        // Luôn fetch lại comments từ API để đảm bảo dữ liệu mới nhất
        fetchPostDetails();
      }
      // Lấy từ map nếu được truyền dưới dạng map
      else if (Get.arguments is Map) {
        final args = Get.arguments as Map;

        // Nếu có postId
        if (args.containsKey('postId')) {
          postId = args['postId'];

          // Nếu có model
          if (args.containsKey('post') && args['post'] is CommunityPostModel) {
            communityPost.value = args['post'] as CommunityPostModel;

            // Luôn fetch lại dữ liệu mới nhất
            fetchPostDetails();
          } else {
            // Không có model, quay về màn hình trước
            errorMessage.value = 'Post data is missing';
            Get.back();
          }
        } else {
          // Không có postId, quay về màn hình trước
          errorMessage.value = 'Post ID is missing';
          Get.back();
        }
      } else {
        // Không đúng định dạng, quay về màn hình trước
        errorMessage.value = 'Invalid arguments format';
        Get.back();
      }
    } else {
      // Không có arguments, quay về màn hình trước
      errorMessage.value = 'No arguments provided';
      Get.back();
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    updateCommentController.dispose();
    super.onClose();
  }

  // Xác thực nội dung comment
  String? validateComment(String value) {
    if (value.isEmpty) {
      return "Comment cannot be empty";
    }
    if (value.length < 3) {
      return "Comment must be at least 3 characters";
    }
    return null;
  }

  // Lấy danh sách comments
  Future<void> fetchComments() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      // comments.clear();
      update();

      final response = await CommentRepository.getCommentList(postId);

      if (response.statusCode == 200) {
        String jsonResult = utf8.decode(response.bodyBytes);
        List<dynamic> decodedData = json.decode(jsonResult);

        comments.value =
            decodedData.map((item) => CommentModel.fromJson(item)).toList();
      } else {
        print('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading comments: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Kiểm tra xem user có quyền bình luận không
  bool canComment() {
    final accountController = Get.find<AccountProfileController>();

    // Nếu là ROLE_USER, không cho phép bình luận
    if (accountController.isRegularUser()) {
      return false;
    }

    // Các role khác được phép bình luận
    return true;
  }

  // Kiểm tra xem user có quyền chỉnh sửa comment không
  @override
  bool canEditComment(CommentModel comment) {
    // Lấy ID người dùng từ session/preferences
    final accountController = Get.find<AccountProfileController>();
    final userId = accountController.accountProfileModel.value.id;

    // Nếu là ROLE_USER, không được phép chỉnh sửa comment
    if (accountController.isRegularUser()) {
      return false;
    }

    // Các role khác được phép chỉnh sửa comment của mình
    return userId != null && comment.userId == userId;
  }

  // Kiểm tra xem user có quyền chỉnh sửa bài viết không
  @override
  bool canEditPost() {
    // Lấy ID người dùng từ session/preferences
    final accountController = Get.find<AccountProfileController>();
    final userId = accountController.accountProfileModel.value.id;

    // Nếu là ROLE_USER, không được phép chỉnh sửa bài viết
    if (accountController.isRegularUser()) {
      return false;
    }

    // Admin và Moderator có thể chỉnh sửa mọi bài viết
    if (accountController.canModerateContent()) {
      return true;
    }

    // Các role khác chỉ được chỉnh sửa bài viết của mình
    return userId != null && communityPost.value?.userId == userId;
  }

  // Tạo comment mới
  Future<bool> createComment() async {
    // Kiểm tra quyền trước khi thực hiện
    if (!canComment()) {
      _showErrorDialog(
          'You do not have permission to add comments. Please contact administrator for more information.');
      return false;
    }

    // Kiểm tra form hợp lệ
    if (!commentFormKey.currentState!.validate()) {
      return false;
    }

    try {
      isSubmittingComment.value = true;
      errorMessage.value = '';

      // Lấy ID người dùng từ session/preferences
      final accountController = Get.find<AccountProfileController>();
      final userId = accountController.accountProfileModel.value.id;

      if (userId == null) {
        errorMessage.value = 'User is not logged in';
        _showErrorDialog('Please login to comment');
        return false;
      }

      // Chuẩn bị dữ liệu
      CommentModel commentData = CommentModel(
        userId: userId,
        content: commentController.text.trim(),
      );

      // Gọi API
      final response =
          await CommentRepository.createComment(commentData, postId);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Xóa nội dung form
        commentController.clear();

        // Cập nhật danh sách comments
        await fetchComments();

        // Tăng số lượng comment trong bài viết
        if (communityPost.value != null) {
          communityPost.value!.commentCount =
              (communityPost.value!.commentCount ?? 0) + 1;
        }

        Get.find<CommunityPostController>().getCommunityPostList();

        // Hiển thị thông báo thành công
        // _showSuccessDialog('Comment posted successfully');

        return true;
      } else {
        // Xử lý lỗi
        String responseMsg = '';
        try {
          final responseBody = json.decode(response.body);
          responseMsg = responseBody['message'] ?? 'Unknown error';
        } catch (_) {
          responseMsg = 'Could not process server response';
        }

        errorMessage.value = 'Error: ${response.statusCode} - $responseMsg';
        _showErrorDialog(errorMessage.value);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
      _showErrorDialog(errorMessage.value);
      return false;
    } finally {
      isSubmittingComment.value = false;
    }
  }

  // Bắt đầu cập nhật comment
  void startEditingComment(CommentModel comment) {
    // Đặt giá trị ID và nội dung
    editingCommentId.value = comment.id ?? -1;
    updateCommentController.text = comment.content ?? '';

    // Đảm bảo UI được cập nhật
    update();
  }

  // Hủy cập nhật comment
  void cancelEditingComment() {
    editingCommentId.value = -1;
    updateCommentController.clear();
  }

  // Cập nhật comment
  Future<bool> updateComment() async {
    // Kiểm tra quyền trước khi thực hiện
    CommentModel? currentComment;
    for (var comment in comments) {
      if (comment.id == editingCommentId.value) {
        currentComment = comment;
        break;
      }
    }

    if (currentComment == null || !canEditComment(currentComment)) {
      _showErrorDialog('You do not have permission to update this comment.');
      return false;
    }

    // Kiểm tra form hợp lệ
    if (!updateCommentFormKey.currentState!.validate() ||
        editingCommentId.value == -1) {
      return false;
    }

    try {
      isUpdatingComment.value = true;
      errorMessage.value = '';

      // Lấy ID người dùng từ session/preferences
      final accountController = Get.find<AccountProfileController>();
      final userId = accountController.accountProfileModel.value.id;

      if (userId == null) {
        errorMessage.value = 'User is not logged in';
        _showErrorDialog('Please login to update comment');
        return false;
      }

      // Chuẩn bị dữ liệu
      CommentModel commentData = CommentModel(
        userId: userId,
        content: updateCommentController.text.trim(),
      );

      // Gọi API
      final response = await CommentRepository.updateComment(
          commentData, editingCommentId.value);

      if (response.statusCode == 200) {
        // Hủy trạng thái edit
        cancelEditingComment();

        // Cập nhật danh sách comments
        await fetchComments();

        // Hiển thị thông báo thành công
        // _showSuccessDialog('Comment updated successfully');

        return true;
      } else {
        // Xử lý lỗi
        String responseMsg = '';
        try {
          final responseBody = json.decode(response.body);
          responseMsg = responseBody['message'] ?? 'Unknown error';
        } catch (_) {
          responseMsg = 'Could not process server response';
        }

        errorMessage.value = 'Error: ${response.statusCode} - $responseMsg';
        _showErrorDialog(errorMessage.value);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
      _showErrorDialog(errorMessage.value);
      return false;
    } finally {
      isUpdatingComment.value = false;
    }
  }

  // Xóa comment
  Future<bool> deleteComment(int commentId) async {
    // Tìm comment cần xóa
    CommentModel? commentToDelete;
    for (var comment in comments) {
      if (comment.id == commentId) {
        commentToDelete = comment;
        break;
      }
    }

    // Kiểm tra quyền trước khi thực hiện
    if (commentToDelete == null || !canEditComment(commentToDelete)) {
      _showErrorDialog('You do not have permission to delete this comment.');
      return false;
    }

    // Hiện dialog xác nhận
    bool confirmDelete = await _showConfirmationDialog(
        'Delete Comment', 'Are you sure you want to delete this comment?');

    if (!confirmDelete) return false;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Gọi API
      final response = await CommentRepository.deleteComment(commentId);

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Cập nhật danh sách comments
        await fetchComments();

        // Giảm số lượng comment trong bài viết
        if (communityPost.value != null) {
          communityPost.value!.commentCount =
              (communityPost.value!.commentCount ?? 1) - 1;
        }

        Get.find<CommunityPostController>().getCommunityPostList();

        // Hiển thị thông báo thành công bằng dialog
        // _showSuccessDialog('Comment deleted successfully');

        return true;
      } else {
        // Xử lý lỗi
        String responseMsg = '';
        try {
          final responseBody = json.decode(response.body);
          responseMsg = responseBody['message'] ?? 'Unknown error';
        } catch (_) {
          responseMsg = 'Could not process server response';
        }

        errorMessage.value = 'Error: ${response.statusCode} - $responseMsg';
        _showErrorDialog(errorMessage.value);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
      _showErrorDialog(errorMessage.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Định dạng ngày tháng
  String formatDate(DateTime? date) {
    if (date == null) return 'Unknown date';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      // Cùng ngày
      if (difference.inHours == 0) {
        // Cùng giờ
        if (difference.inMinutes < 1) {
          return 'Just now';
        }
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      // Trong tuần
      return '${difference.inDays} days ago';
    } else {
      // Lâu hơn
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Hiển thị dialog xác nhận
  Future<bool> _showConfirmationDialog(String title, String message) async {
    Completer<bool> completer = Completer<bool>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFFF9800),
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8E6C88),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                      completer.complete(false);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                      completer.complete(true);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return completer.future;
  }

  // Hiển thị dialog lỗi
  void _showErrorDialog(String errorMessage) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  color: Colors.red[400],
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Error',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[400],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Get.back(); // Đóng dialog
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hiển thị dialog thành công
  void _showSuccessDialog(String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              const SizedBox(height: 20),
              const Text(
                'Success',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Get.back(); // Đóng dialog
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Thêm phương thức để fetch lại toàn bộ thông tin bài viết
  Future<void> fetchPostDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response =
          await CommunityPostRepository.getCommunityPostById(postId);

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

  // Phương thức cập nhật bài viết
  void goToUpdateCommunityPost(int index) {
    // Lấy thông tin userId từ user info hiện tại
    final accountProfileController = Get.find<AccountProfileController>();
    final userId = accountProfileController.accountProfileModel.value.id;

    // Kiểm tra quyền sở hữu bài viết
    //   if (userId == null || userId != communityPost.value?.userId) {
    //     Get.snackbar(
    //       "Permission Denied",
    //       "You can only edit your own posts",
    //       snackPosition: SnackPosition.BOTTOM,
    //       backgroundColor: Colors.red.withOpacity(0.8),
    //       colorText: Colors.white);
    //   );
    //   return;
    // }

    // Chuyển trang và truyền dữ liệu
    Get.toNamed(AppRoutes.updatecommunitypost, arguments: communityPost.value)
        ?.then((value) {
      // Làm mới danh sách khi cập nhật thành công
      if (value != null && value == true) {
        fetchPostDetails();
      }
    });
  }

  // Phương thức xóa bài viết
  Future<void> deletePost() async {
    if (!canEditPost()) {
      _showErrorDialog('You do not have permission to delete this post.');
      return;
    }

    // Hiện dialog xác nhận
    bool confirmDelete = await _showConfirmationDialog('Delete Post',
        'Are you sure you want to delete this post? This action cannot be undone.');

    if (!confirmDelete) return;

    try {
      isLoading.value = true;

      // Gọi API xóa bài viết
      final response =
          await CommunityPostRepository.deleteCommunityPost(postId);

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Hiển thị thông báo thành công
        // _showSuccessDialog('Post deleted successfully');

        // Chờ 1 giây rồi quay về trang danh sách
        await Future.delayed(const Duration(seconds: 1));
        Get.back(result: true); // true để báo hiệu cần refresh danh sách
      } else {
        // Xử lý lỗi
        String responseMsg = '';
        try {
          final responseBody = json.decode(response.body);
          responseMsg = responseBody['message'] ?? 'Unknown error';
        } catch (_) {
          responseMsg = 'Could not process server response';
        }

        errorMessage.value = 'Error: ${response.statusCode} - $responseMsg';
        _showErrorDialog(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
      _showErrorDialog(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
