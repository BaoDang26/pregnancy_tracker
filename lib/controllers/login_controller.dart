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
    if (value.isEmpty || !value.contains('@gmail.com')) {
      return "email is invalid";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "password is invalid";
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
          userRole.toUpperCase() == "ROLE_PREMIUM") {
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
}
