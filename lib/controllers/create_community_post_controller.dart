import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pregnancy_tracker/controllers/community_post_controller.dart';

import '../models/community_post_model.dart';
import '../util/app_export.dart';
import '../repositories/community_post_repository.dart'; // Import repository

class CreateCommunityPostController extends GetxController {
  final GlobalKey<FormState> communityPostFormKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController contentController;

  // Biến lưu trữ ảnh được chọn
  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  RxString imageFileName = RxString('');
  RxBool isImageSelected = false.obs;

  late TextEditingController attachmentUrlController;

  late int userId;

  var isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Thêm các biến mới cho Flutter Web
  Rx<Uint8List?> webImage = Rx<Uint8List?>(null);

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;

    // Lấy userId từ arguments
    userId = Get.arguments['userId'];

    // Khởi tạo các controller
    titleController = TextEditingController();
    contentController = TextEditingController();
    attachmentUrlController = TextEditingController();

    isLoading.value = false;
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    attachmentUrlController.dispose();
    super.onClose();
  }

  // Xác thực tiêu đề
  String? validateTitle(String value) {
    if (value.isEmpty) return "Title is required";
    if (value.length < 3) return "Title must be at least 3 characters";
    return null;
  }

  // Xác thực nội dung
  String? validateContent(String value) {
    if (value.isEmpty) return "Content is required";
    if (value.length < 10) return "Content must be at least 10 characters";
    return null;
  }

  // Chọn ảnh từ thư viện với hỗ trợ cho web
  Future<void> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();

      if (kIsWeb) {
        // Cách xử lý trên web
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );

        if (image != null) {
          // Lưu thông tin file
          selectedImage.value = image;
          imageFileName.value = image.name;
          isImageSelected.value = true;

          // Đọc file dưới dạng bytes cho web
          final bytes = await image.readAsBytes();
          webImage.value = bytes;

          // Chuyển đổi sang base64
          await convertImageToBase64AndAssign();
        }
      } else {
        // Cách xử lý trên mobile (giữ nguyên)
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );

        if (image != null) {
          selectedImage.value = image;
          imageFileName.value = image.name;
          isImageSelected.value = true;

          await convertImageToBase64AndAssign();
        }
      }
    } catch (e) {
      errorMessage.value = 'Error picking image: $e';
      print('Error picking image: $e');
      _showErrorDialog(errorMessage.value);
    }
  }

  // Chuyển đổi ảnh sang base64 và gán vào attachmentUrlController
  Future<void> convertImageToBase64AndAssign() async {
    if (selectedImage.value == null) return;

    try {
      isLoading.value = true;

      // Đọc bytes từ XFile
      final bytes = await selectedImage.value!.readAsBytes();

      // Mã hóa bytes thành chuỗi base64
      final base64String = base64Encode(bytes);

      // Gán chuỗi base64 vào attachmentUrlController
      attachmentUrlController.text = base64String;

      print('Image converted to base64 successfully');
    } catch (e) {
      errorMessage.value = 'Error converting image: $e';
      print('Error converting image to base64: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Xóa ảnh đã chọn
  void clearSelectedImage() {
    selectedImage.value = null;
    imageFileName.value = '';
    isImageSelected.value = false;
    attachmentUrlController.text = '';

    if (kIsWeb) webImage.value = null;
  }

  // Hàm tiện ích để lấy thông tin MIME type từ đường dẫn file
  String getMimeType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      default:
        return 'application/octet-stream'; // Mặc định nếu không xác định được
    }
  }

  //Xóa dữ liệu form
  void clearFormFields() {
    titleController.clear();
    contentController.clear();
    attachmentUrlController.clear();
    clearSelectedImage();
  }

  // Tạo community post
  Future<bool> createCommunityPost() async {
    // Kiểm tra form hợp lệ
    if (!communityPostFormKey.currentState!.validate()) {
      return false;
    }

    try {
      // Hiển thị loading
      isLoading.value = true;
      errorMessage.value = '';

      // Chuẩn bị dữ liệu cho API
      CommunityPostModel postData = CommunityPostModel(
        userId: userId,
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        attachmentUrl:
            attachmentUrlController.text, // Chuỗi base64 đã được gán trước đó
      );

      // Gọi API để tạo bài đăng
      final response =
          await CommunityPostRepository.createCommunityPost(postData);

      // Xử lý kết quả
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Thành công
        clearFormFields(); // Xóa dữ liệu form

        // Hiển thị dialog thông báo thành công
        // _showSuccessDialog();
        Get.back();

        Get.find<CommunityPostController>().getCommunityPostList();
        return true;
      } else {
        // Xử lý lỗi
        String responseMsg = '';
        try {
          final responseBody = json.decode(response.body);
          responseMsg = responseBody['message'] ?? 'Unknown error';
        } catch (e) {
          responseMsg = 'Could not process server response';
        }

        errorMessage.value = 'Error: ${response.statusCode} - $responseMsg';

        // Hiển thị dialog thông báo lỗi
        _showErrorDialog(errorMessage.value);
        return false;
      }
    } catch (e) {
      // Xử lý ngoại lệ
      errorMessage.value = 'An unexpected error occurred: $e';

      // Hiển thị dialog thông báo lỗi
      _showErrorDialog(errorMessage.value);
      return false;
    } finally {
      // Kết thúc loading
      isLoading.value = false;
    }
  }

  // Hiển thị dialog thông báo thành công
  void _showSuccessDialog() {
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
                  color: const Color(0xFFAD6E8C).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFFAD6E8C),
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Success!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8E6C88),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your post has been created successfully.',
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
                  Get.back(
                      result: true); // Quay lại màn hình trước với kết quả true
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFAD6E8C),
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
      barrierDismissible:
          false, // Người dùng không thể đóng dialog bằng cách nhấn bên ngoài
    );
  }

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
}
