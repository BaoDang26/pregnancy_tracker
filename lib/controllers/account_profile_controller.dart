import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/account_profile_model.dart';
import '../repositories/account_profile_repository.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/pregnancy_profile_repository.dart';
import '../routes/app_routes.dart';
import '../util/preUtils.dart';

class AccountProfileController extends GetxController {
  final GlobalKey<FormState> accountProfileFormKey = GlobalKey<FormState>();

  late TextEditingController fullNameController;
  late TextEditingController addressController;
  late TextEditingController dateOfBirthController;

  late int userId;

  var isLoading = false.obs;
  RxString errorMessage = ''.obs;
  Rx<AccountProfileModel> accountProfileModel = AccountProfileModel().obs;
  RxList<dynamic> pregnancyProfiles = <dynamic>[].obs;

  // Controllers cho các trường mật khẩu
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Biến để kiểm soát hiển thị mật khẩu
  RxBool hideCurrentPassword = true.obs;
  RxBool hideNewPassword = true.obs;
  RxBool hideConfirmPassword = true.obs;

  @override
  Future<void> onInit() async {
    await getAccountProfile();
    getPregnancyProfiles();
    fullNameController = TextEditingController();
    addressController = TextEditingController();
    dateOfBirthController = TextEditingController();
    super.onInit();

    // Safely check arguments
    try {
      // Handle if arguments is Map
      if (Get.arguments is Map<String, dynamic>) {
        final args = Get.arguments as Map<String, dynamic>;
        // Get scheduleId from arguments with default value 0 if not found
        userId = args['userId'] ?? 0;
      }
      // Handle if arguments is a single value (assuming it's scheduleId)
      else if (Get.arguments != null) {
        userId = Get.arguments is int ? Get.arguments : 0;
      }

      // If we have a valid scheduleId, find the data
      if (userId > 0) {
        findAccountProfileFromId();
      } else {
        print('Warning: Invalid scheduleId: $userId');
        // You could set an error message here
      }
    } catch (e) {
      print('Error in onInit: $e');
      errorMessage.value = 'Failed to initialize data';
    } finally {
      isLoading.value = false;
    }
  }

  void findAccountProfileFromId() {
    try {
      // Check if controller is registered
      if (!Get.isRegistered<AccountProfileController>()) {
        print('AccountProfileController is not registered');
        return;
      }

      // Get controller with user
      final accountProfileController = Get.find<AccountProfileController>();

      // Check if list has been initialized
      if (accountProfileController.accountProfileModel == null) {
        print('AccountProfileModel list is empty');
        return;
      }

      // Find user based on ID, with default value if not found
      final accountProfileId =
          accountProfileController.accountProfileModel.value.id;

      // Check search result
      if (accountProfileId != null) {
        accountProfileModel.value =
            accountProfileController.accountProfileModel.value;
        // Fill data into form
        populateFormFields();
      } else {
        print('AccountProfile not found with ID: $userId');
      }
    } catch (e) {
      print('Error in findAccountProfileFromId: $e');
    }
  }

  void populateFormFields() {
    final accountProfile = accountProfileModel.value;

    // Fill values into controllers
    fullNameController.text = accountProfile.fullName ?? '';
    addressController.text = accountProfile.address ?? '';

    //format date of birth
    if (accountProfile.dateOfBirth != null) {
      dateOfBirthController.text =
          DateFormat('yyyy-MM-dd').format(accountProfile.dateOfBirth!);
    }
  }

  String? validateFullName(String value) {
    if (value.isEmpty) return "Full name is required";
    return null;
  }

  String? validateAddress(String value) {
    if (value.isEmpty) return "Address is required";
    return null;
  }

  void showDatePicker() {
    DateTime initialDate = DateTime.now();
    if (dateOfBirthController.text.isNotEmpty) {
      try {
        initialDate =
            DateFormat('yyyy-MM-dd').parse(dateOfBirthController.text);
      } catch (_) {
        // Keep default initialDate if parsing fails
      }
    }

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          width: 300,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Date of Birth",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.purple[700],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 300,
                child: Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Colors.purple[600]!,
                    ),
                    textTheme: const TextTheme(
                      bodyMedium: const TextStyle(fontSize: 12),
                      bodySmall: TextStyle(fontSize: 12),
                      titleSmall: TextStyle(fontSize: 12),
                    ),
                  ),
                  child: CalendarDatePicker(
                    initialDate: initialDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                    onDateChanged: (date) {
                      dateOfBirthController.text =
                          DateFormat('yyyy-MM-dd').format(date);
                      Get.back();
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: const Size(60, 25),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.purple[600],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateAccountProfile() async {
    try {
      isLoading.value = true;
      final isValid = accountProfileFormKey.currentState!.validate();
      if (!isValid) {
        isLoading.value = false;
        return;
      }

      // Validate date of birth
      if (dateOfBirthController.text.isEmpty) {
        errorMessage.value = "Date of birth is required";
        isLoading.value = false;
        return;
      }

      // Parse date with error handling
      DateTime dateOfBirth;
      try {
        dateOfBirth =
            DateFormat('yyyy-MM-dd').parse(dateOfBirthController.text);
      } catch (e) {
        errorMessage.value = "Invalid date of birth";
        isLoading.value = false;
        return;
      }

      // Create update request
      var request = {
        'fullName': fullNameController.text,
        'address': addressController.text,
        'dateOfBirth': dateOfBirth.toString(),
      };

      // Show loading indicator

      // Call API to update account profile
      var response =
          await AccountProfileRepository.updateAccountProfile(request);

      // Handle response
      if (response.statusCode == 200) {
        // Update success
        // Show success dialog
        await showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Success',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Account profile updated successfully!'),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        // Refresh account profile
        await getAccountProfile();
      } else if (response.statusCode == 401) {
        String message = jsonDecode(response.body)['message'];
        if (message.contains("JWT token is expired")) {
          Get.snackbar('Session Expired', 'Please login again');
        }
      } else if (response.statusCode == 400) {
        var errorData = jsonDecode(response.body);
        errorMessage.value = errorData['message'] ?? 'Bad Request';
      } else {
        Get.snackbar("Error server ${response.statusCode}",
            jsonDecode(response.body)['message']);
      }
    } catch (e) {
      print('Error in updateAccountProfile: $e');
      errorMessage.value =
          'An error occurred while updating the account profile';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAccountProfile() async {
    isLoading.value = true;
    var response = await AccountProfileRepository.getAccountProfile();
    // Log thông tin response để debug
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      // Log kết quả JSON
      print("JSON Result: $jsonResult");
      //chuyển đổi từ JSON sang model
      accountProfileModel.value = accountProfileModelFromJson(jsonResult);
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }

  void goToUpdateAccountProfile() {
    var userId = accountProfileModel.value.id;

    Get.toNamed(AppRoutes.updateAccountProfile, arguments: userId);
    print("goToUpdateAccountProfile: $userId");
  }

  Future<void> logout() async {
    // Alert.showLoadingIndicatorDialog(context);
    await AuthenticationRepository.logout();
    PrefUtils.clearPreferencesData();

    Get.offAllNamed(AppRoutes.sidebarnarguest);
  }

  Future<void> getPregnancyProfiles() async {
    try {
      isLoading.value = true;
      // Gọi API lấy danh sách pregnancy profile
      var response = await PregnancyProfileRepository.getPregnancyProfileList();

      if (response.statusCode == 200) {
        String jsonResult = utf8.decode(response.bodyBytes);
        var data = json.decode(jsonResult);

        // Giả sử API trả về danh sách profile trong data
        if (data is List) {
          pregnancyProfiles.value = data;
        } else if (data['data'] != null && data['data'] is List) {
          pregnancyProfiles.value = data['data'];
        } else {
          pregnancyProfiles.value = [];
        }
      } else {
        pregnancyProfiles.value = [];
      }
    } catch (e) {
      print('Error getting pregnancy profiles: $e');
      pregnancyProfiles.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // Kiểm tra nếu user có role là ROLE_USER
  bool isRegularUser() {
    return accountProfileModel.value.roleName?.toUpperCase() == 'ROLE_USER';
  }

  //Kiểm tra nếu user có role là ROLE_USER_PREMIUM
  bool isPremiumUser() {
    return accountProfileModel.value.roleName?.toUpperCase() ==
        'ROLE_USER_PREMIUM';
  }

  // Kiểm tra nếu user có thể quản lý nội dung (ROLE_ADMIN hoặc ROLE_MODERATOR)
  bool canModerateContent() {
    final role = accountProfileModel.value.roleName?.toUpperCase();
    return role == 'ROLE_ADMIN';
  }

  void showChangePasswordDialog() {
    // Reset controllers và error message
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    errorMessage.value = '';

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Obx(() => Container(
              width: 400,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dialog header
                  Row(
                    children: [
                      Icon(Icons.lock_reset, color: Colors.blue[700], size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Current Password field
                  _buildPasswordField(
                    controller: currentPasswordController,
                    label: 'Current Password',
                    hide: hideCurrentPassword,
                    toggleVisibility: () =>
                        hideCurrentPassword.value = !hideCurrentPassword.value,
                  ),
                  const SizedBox(height: 16),

                  // New Password field
                  _buildPasswordField(
                    controller: newPasswordController,
                    label: 'New Password',
                    hide: hideNewPassword,
                    toggleVisibility: () =>
                        hideNewPassword.value = !hideNewPassword.value,
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password field
                  _buildPasswordField(
                    controller: confirmPasswordController,
                    label: 'Confirm New Password',
                    hide: hideConfirmPassword,
                    toggleVisibility: () =>
                        hideConfirmPassword.value = !hideConfirmPassword.value,
                  ),

                  // Error message
                  if (errorMessage.value.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red[700], size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorMessage.value,
                              style: TextStyle(
                                  color: Colors.red[700], fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed:
                            isLoading.value ? null : () => changePassword(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ))
                            : const Text('Change Password'),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required RxBool hide,
    required Function toggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: hide.value,
          decoration: InputDecoration(
            hintText: '••••••••',
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.lock_outline, size: 18),
            suffixIcon: IconButton(
              icon: Icon(
                hide.value ? Icons.visibility_off : Icons.visibility,
                size: 18,
              ),
              onPressed: () => toggleVisibility(),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue[100]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue[400]!, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> changePassword() async {
    try {
      // Validate inputs
      if (currentPasswordController.text.isEmpty) {
        errorMessage.value = 'Current password is required';
        return;
      }

      if (newPasswordController.text.isEmpty) {
        errorMessage.value = 'New password is required';
        return;
      }

      // Tăng cường validation cho mật khẩu
      String password = newPasswordController.text;
      if (password.length < 8) {
        errorMessage.value = 'New password must be at least 8 characters';
        return;
      }

      // Kiểm tra có ít nhất 1 chữ in hoa
      if (!RegExp(r'[A-Z]').hasMatch(password)) {
        errorMessage.value =
            'New password must contain at least one uppercase letter';
        return;
      }

      // Kiểm tra có ít nhất 1 chữ thường
      if (!RegExp(r'[a-z]').hasMatch(password)) {
        errorMessage.value =
            'New password must contain at least one lowercase letter';
        return;
      }

      // Kiểm tra có ít nhất 1 chữ số
      if (!RegExp(r'[0-9]').hasMatch(password)) {
        errorMessage.value = 'New password must contain at least one number';
        return;
      }

      // Kiểm tra có ít nhất 1 ký tự đặc biệt
      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
        errorMessage.value =
            'New password must contain at least one special character';
        return;
      }

      if (confirmPasswordController.text != newPasswordController.text) {
        errorMessage.value = 'Passwords do not match';
        return;
      }

      isLoading.value = true;

      // Prepare request body
      Map<String, dynamic> requestBody = {
        'currentPassword': currentPasswordController.text,
        'newPassword': newPasswordController.text,
        'confirmPassword': confirmPasswordController.text
      };

      String jsonBody = json.encode(requestBody);

      // Call API
      var response = await AuthenticationRepository.changePassword(jsonBody);

      if (response.statusCode == 200) {
        // Success - close dialog
        Get.back();

        // Show success message
        Get.snackbar(
          'Success',
          'Password changed successfully',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      } else if (response.statusCode == 401) {
        var errorData = jsonDecode(response.body);
        errorMessage.value =
            errorData['message'] ?? 'Current password is incorrect';
      } else {
        var errorData = jsonDecode(response.body);
        errorMessage.value =
            errorData['message'] ?? 'Failed to change password';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      print('Error changing password: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
