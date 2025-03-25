import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dvhcvn/dvhcvn.dart' as dvhcvn;

import '../models/account_model.dart';
import '../repositories/authentication_repository.dart';
import '../util/app_export.dart';

class RegisterController extends GetxController {
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController fullNameController;
  late TextEditingController addressController;
  late TextEditingController streetAddressController;
  late TextEditingController rePasswordController;
  late TextEditingController dateOfBirthController;

  RxBool passwordVisible = true.obs;
  RxBool confirmPasswordVisible = true.obs;

  // Biến cho địa chỉ
  var selectedLevel1 = Rxn<dvhcvn.Level1>();
  var selectedLevel2 = Rxn<dvhcvn.Level2>();
  var selectedLevel3 = Rxn<dvhcvn.Level3>();
  var streetAddress = ''.obs;

  var level2List = <dvhcvn.Level2>[].obs;
  var level3List = <dvhcvn.Level3>[].obs;

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
    streetAddressController = TextEditingController();
    dateOfBirthController = TextEditingController(text: dateOfBirth.value);

    // Kết nối dateOfBirth với dateOfBirthController
    ever(dateOfBirth, (value) {
      dateOfBirthController.text = value;
    });

    // Khởi tạo địa chỉ
    ever(selectedLevel1, (level1) {
      if (level1 != null) {
        // Sắp xếp A-Z
        var sortedLevel2 = level1.children.toList();
        sortedLevel2.sort((a, b) => a.name.compareTo(b.name));
        level2List.value = sortedLevel2;

        selectedLevel2.value = null;
        selectedLevel3.value = null;
        level3List.clear();
        updateFullAddress();
      }
    });

    ever(selectedLevel2, (level2) {
      if (level2 != null) {
        // Sắp xếp A-Z
        var sortedLevel3 = level2.children.toList();
        sortedLevel3.sort((a, b) => a.name.compareTo(b.name));
        level3List.value = sortedLevel3;

        selectedLevel3.value = null;
        updateFullAddress();
      }
    });

    ever(selectedLevel3, (_) => updateFullAddress());
    ever(streetAddress, (_) => updateFullAddress());

    isLoading.value = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    fullNameController.dispose();
    addressController.dispose();
    streetAddressController.dispose();
    dateOfBirthController.dispose();
    super.onClose();
  }

  // Cập nhật địa chỉ đầy đủ
  void updateFullAddress() {
    List<String> addressParts = [];

    if (streetAddress.value.isNotEmpty) {
      addressParts.add(streetAddress.value);
    }

    if (selectedLevel3.value != null) {
      addressParts.add(selectedLevel3.value!.name);
    }

    if (selectedLevel2.value != null) {
      addressParts.add(selectedLevel2.value!.name);
    }

    if (selectedLevel1.value != null) {
      addressParts.add(selectedLevel1.value!.name);
    }

    address = addressParts.join(', ');
    addressController.text = address;
  }

  // Validate địa chỉ
  String? validateAddress(String? value) {
    if (selectedLevel1.value == null) {
      return "Please select province/city";
    }
    if (selectedLevel2.value == null) {
      return "Please select district/county";
    }
    if (selectedLevel3.value == null) {
      return "Please select ward/commune";
    }

    // Kiểm tra trực tiếp giá trị của streetAddressController
    if (streetAddressController.text.isEmpty) {
      return "Please enter house number, street name";
    }
    return null;
  }

  // Các phương thức khác giữ nguyên
  String? validateFullName(String value) {
    if (value.isEmpty || value.length < 5) {
      return "Full name must have more than 5 characters";
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
    // Đảm bảo địa chỉ được cập nhật mới nhất
    updateFullAddress();

    if (registerFormKey.currentState!.validate()) {
      registerFormKey.currentState!.save();
      try {
        final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
        AccountModel registerAccount = AccountModel(
          fullName: fullName,
          email: email,
          password: password,
          dateOfBirth: dateFormat.parse(dateOfBirth.value),
          address: address,
        );

        var response = await AuthenticationRepository.postRegister(
            accountModelToJson(registerAccount));

        // kiểm tra kết quả
        if (response.statusCode == 200) {
          String jsonResult = utf8.decode(response.bodyBytes);
          var data = json.decode(jsonResult);
          errorString.value = ''; // Xóa lỗi nếu thành công
          Get.snackbar("Success", "Please verify your email");
          Get.toNamed(AppRoutes.login);
        } else if (response.statusCode == 400) {
          print('register failed!!!!');
          errorString.value =
              "Registration failed. Please check your information.";
        } else if (response.statusCode == 500) {
          log(jsonDecode(response.body)['message']);
          errorString.value =
              jsonDecode(response.body)['message'] ?? "Server error occurred";
        } else {
          log(jsonDecode(response.body)['message']);
          errorString.value =
              jsonDecode(response.body)['message'] ?? "Error occurred";
          Get.snackbar("Error server ${response.statusCode}",
              jsonDecode(response.body)['message']);
        }

        return null;
      } catch (e) {
        errorString.value = e.toString();
        return null;
      }
    }
    return null;
  }
}
