import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/account_profile_model.dart';
import '../repositories/account_profile_repository.dart';
import '../repositories/authentication_repository.dart';
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

  @override
  Future<void> onInit() async {
    await getAccountProfile();
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
        insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          width: 300,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              SizedBox(height: 8),
              Container(
                height: 300,
                child: Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Colors.purple[600]!,
                    ),
                    textTheme: TextTheme(
                      bodyMedium: TextStyle(fontSize: 12),
                      bodySmall: TextStyle(fontSize: 12),
                      titleSmall: TextStyle(fontSize: 12),
                    ),
                  ),
                  child: CalendarDatePicker(
                    initialDate: initialDate,
                    firstDate: DateTime.now().subtract(Duration(days: 1)),
                    lastDate: DateTime.now().add(Duration(days: 365 * 2)),
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
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size(60, 25),
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
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Success',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Account profile updated successfully!'),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
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
}
