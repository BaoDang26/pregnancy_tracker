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
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

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
      // có lỗi từ server
      // Get.snackbar(
      //   "Error Server ${response.statusCode}",
      //   jsonDecode(response.body)["message"],
      //   duration: 5.seconds,
      //   snackPosition: SnackPosition.BOTTOM,
      //   showProgressIndicator: true,
      //   isDismissible: true,
      // );
    } else if (response.statusCode == 200) {
      // String jsonResult = utf8.decode(response.bodyBytes);
      // var data = json.decode(jsonResult);
      // print('data:$data');

      errorString.value = "";

      Get.offAllNamed(AppRoutes.home);
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
