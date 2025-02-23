import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/account_model.dart';
import '../repositories/authentication_repository.dart';
import '../util/app_export.dart';

class RegisterController extends GetxController {
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController fullNameController;
  late TextEditingController addressController;
  late TextEditingController rePasswordController;

  RxBool passwordVisible = true.obs;
  RxBool confirmPasswordVisible = true.obs;

  var fullName = '';
  var email = '';
  var address = '';
  late RxString dateOfBirth = 'yyyy-MM-dd'.obs;

  var password = '';
  var rePassword = '';
  var errorString = ''.obs;
  var isLoading = false.obs;
  var registeredAccount = AccountModel().obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    emailController = TextEditingController();
    passwordController = TextEditingController();
    rePasswordController = TextEditingController();
    fullNameController = TextEditingController();
    addressController = TextEditingController();
    isLoading.value = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    fullNameController.dispose();
    addressController.dispose();
    super.onClose();
  }

  String? validateFullName(String value) {
    if (value.isEmpty || value.length < 5) {
      return "Full name must have more than 5 characters";
    }
    return null;
  }

  String? validateAddress(String value) {
    if (value.isEmpty || value.length < 5) {
      return "Address must have more than 5 characters";
    }
    return null;
  }

  String? validateEmail(String value) {
    if (value.isEmpty ||
        (!value.contains('@gmail.com') && !value.contains('@fpt.edu.vn'))) {
      return "email is invalid";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    } else if (value.length < 6) {
      return "Password have at least 6 words.";
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Password must contain at least one special character";
    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Password must contain at least one lowercase letter";
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Password must contain at least one uppercase letter";
    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain at least one number";
    }
    return null;
  }

  String? validateRePassword(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    } else if (value != passwordController.text) {
      return "Password does not match";
    }
    return null;
  }

  Future<String?> registerEmail(BuildContext context) async {
    isLoading.value = true;
    final isValid = registerFormKey.currentState!.validate();
    if (!isValid) {
      isLoading.value = false;
      return null;
    }
    registerFormKey.currentState!.save();

    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    AccountModel registerAccount = AccountModel(
      fullName: fullName,
      email: email,
      password: password,
      dateOfBirth: dateFormat.parse(dateOfBirth.value),
      address: address,
    );

    var response = await AuthenticationRepository.postRegister(registerAccount);
    // kiểm tra kết quả
    if (response.statusCode == 200) {
      Get.toNamed(AppRoutes.login);
    } else if (response.statusCode == 400) {
      print('register failed!!!!');
    } else if (response.statusCode == 500) {
      log(jsonDecode(response.body)['message']);
    } else {
      log(jsonDecode(response.body)['message']);
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }

    errorString.value = '';

    isLoading.value = false;
    return null;
  }
}
