import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/util/app_export.dart';

import '../models/login_model.dart';
import '../repositories/authentication_repository.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  RxBool passwordVisible = true.obs;

  var email = '';
  var password = '';
  var errorString = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    errorString.obs;
  }

  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.onClose();
  // }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return "email is required";
    } else if (!value.contains('@gmail.com')) {
      return "email is invalid";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "password is required";
    }
    return null;
  }

  Future<void> login(BuildContext context) async {
    // Show loading khi đợi xác thực login
    isLoading.value = true;
    // kiểm tra các field đã hợp lệ chưa
    final isValid = loginFormKey.currentState!.validate();
    if (!isValid) {
      isLoading.value = false;
      return;
    }
    loginFormKey.currentState!.save();

    // tạo login model
    LoginModel loginModel = LoginModel(
        email: emailController.text, password: passwordController.text);

    // gọi api check login
    var response =
        await AuthenticationRepository.postLogin(loginToJson(loginModel));
    // mỗi lần nhấn button login sẽ xóa text trong password
    passwordController.clear();

    // Kiểm tra status code trả về
    if (response.statusCode == 500) {
      errorString.value = 'Timeout error occurred!';
    } else if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      var data = json.decode(jsonResult);

      // Kiểm tra status của user
      String userStatus =
          data["status"] ?? "Active"; // Default to ACTIVE if not present

      if (userStatus == "Deactive") {
        // Hiển thị thông báo nếu tài khoản bị vô hiệu hóa
        errorString.value =
            'Your account has been banned. Please contact administrator for more information.';
        isLoading.value = false;
        return;
      }

      // Save tokens to SharedPreferences
      PrefUtils.setAccessToken(data["accessToken"]);
      PrefUtils.setRefreshToken(data["refreshToken"]);

      // Extract user role from the response
      String userRole = data["roleName"] ?? "";

      // Clear any error messages
      errorString.value = "";

      // Determine navigation based on user role
      if (userRole.toUpperCase() == "ROLE_ADMIN") {
        // Navigate to admin sidebar
        Get.offAllNamed(AppRoutes.sidebarnaradmin);
      } else if (userRole.toUpperCase() == "ROLE_USER" ||
          userRole.toUpperCase() == "ROLE_USER_PREMIUM") {
        // Navigate to user sidebar
        Get.offAllNamed(AppRoutes.sidebarnar);
      } else {
        // Handle unexpected role
        Get.snackbar("Warning",
            "User role not recognized. Please contact administrator.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white);
        // Default to user sidebar
        Get.offAllNamed(AppRoutes.sidebarnar);
      }
      // Save user role to SharedPreferences
      if (userRole.isNotEmpty) {
        try {
          PrefUtils.setUserRole(userRole);
        } catch (e) {
          print('Error saving user role: $e');
          // Xử lý lỗi nhưng không làm gián đoạn quy trình đăng nhập
        }
      }
    } else if (response.statusCode == 403) {
      errorString.value =
          'Your account has been banned. Please contact administrator for more information.';
    } else {
      // Cập nhật errorString khi bắt được lỗi
      errorString.value = 'Your email or password is incorrect!!';
    }
    // ẩn dialog loading
    isLoading.value = false;
  }

  void goToRegisterScreen() {
    Get.toNamed(AppRoutes.register);
  }

  void showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.password_rounded, color: Color(0xFFAD6E8C)),
            SizedBox(width: 10),
            Text('Forgot Password'),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF8E6C88)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Get.back();
                forgotPassword(emailController.text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFAD6E8C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }

  Future<void> forgotPassword(String email) async {
    isLoading.value = true;

    try {
      var response = await AuthenticationRepository.forgotPassword(email);

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Password reset link has been sent to your email',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
          snackPosition: SnackPosition.TOP,
        );
      } else {
        print('response.statusCode: ${response.statusCode}');
        print('response.body: ${response.body}');
        var errorData = json.decode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to send reset link',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
