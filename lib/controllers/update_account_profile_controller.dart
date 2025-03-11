import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/controllers/account_profile_controller.dart';

import '../models/account_profile_model.dart';
import '../repositories/account_profile_repository.dart';

class UpdateAccountProfileController extends GetxController {
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
    // Thiết lập ngày mặc định là 20 năm trước (thay vì ngày hiện tại)
    DateTime defaultDate = DateTime.now().subtract(Duration(days: 365 * 20));
    DateTime initialDate;

    // Nếu đã có ngày sinh được lưu, sử dụng ngày đó
    if (dateOfBirthController.text.isNotEmpty) {
      try {
        initialDate =
            DateFormat('yyyy-MM-dd').parse(dateOfBirthController.text);
      } catch (_) {
        // Nếu parse lỗi, sử dụng ngày mặc định
        initialDate = defaultDate;
      }
    } else {
      // Nếu chưa có ngày sinh, sử dụng ngày mặc định
      initialDate = defaultDate;
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
                    // Cho phép chọn ngày từ 100 năm trước
                    firstDate: DateTime(DateTime.now().year - 100),
                    // Chỉ cho phép chọn đến ngày hiện tại (không cho phép chọn ngày sinh trong tương lai)
                    lastDate: DateTime.now(),
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

  // Hàm để chọn ảnh từ thư viện
  Future<XFile?> pickImage() async {
    final ImagePicker picker = ImagePicker(); // Khởi tạo ImagePicker
    final XFile? image = await picker.pickImage(
        source: ImageSource.gallery); // Chọn ảnh từ thư viện

    return image; // Trả về ảnh đã chọn
  }

  // Hàm để chọn ảnh từ camera
  Future<XFile?> captureImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85); // Chọn ảnh từ camera với chất lượng 85%

    return image;
  }

  // Hàm xử lý ảnh đã chọn và cập nhật avatar
  Future<void> processAndUpdateAvatar(XFile imageFile) async {
    try {
      isLoading.value = true;

      // Đọc file ảnh thành bytes - Sửa cách đọc file
      final bytes = await imageFile.readAsBytes();

      // Convert bytes thành base64
      final String base64Image = base64Encode(bytes);

      // Hiển thị loading indicator
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.purple[700]!),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Uploading image...',
                    style: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // THAY ĐỔI Ở ĐÂY: Chuẩn bị request data đúng cách
      Map<String, dynamic> requestData = {
        "decodedImage": base64Image,
      };

      // Gọi API, truyền vào Map đã được encode thành JSON
      final response = await AccountProfileRepository.updateAvatar(requestData);
      print(
          'response: ${response.body} \n status code: ${response.statusCode}');

      // Đóng dialog loading
      Get.back();

      // Xử lý response
      if (response.statusCode == 200) {
        // Parse response để lấy avatarUrl mới
        final responseData = json.decode(response.body);
        final String newAvatarUrl = responseData['avatarUrl'];
        print('newAvatarUrl: $newAvatarUrl');

        // Cập nhật avatarUrl trong model
        accountProfileModel.value.avatarUrl = newAvatarUrl;

        // Thông báo thành công
        Get.snackbar(
          'Success',
          'Profile picture updated successfully',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16),
        );

        // Cập nhật AccountProfileController
        Get.find<AccountProfileController>().getAccountProfile();
      } else if (response.statusCode == 401) {
        // Xử lý lỗi xác thực
        Get.snackbar(
          'Authentication Error',
          'Your session has expired. Please login again.',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16),
        );
      } else {
        // Xử lý các lỗi khác
        print('Error in processAndUpdateAvatar: ${response.body}');
        Get.snackbar(
          'Error',
          'Failed to update profile picture: ${json.decode(response.body)['message'] ?? 'Unknown error'}',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16),
        );
      }
    } catch (e) {
      // Đóng dialog loading nếu có lỗi
      if (Get.isDialogOpen!) {
        Get.back();
      }

      // Xử lý lỗi
      print('Error in processAndUpdateAvatar: $e');
      Get.snackbar(
        'Error',
        'Failed to process image: ${e.toString()}',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // // Hàm xử lý xóa avatar
  // Future<void> removeAvatar() async {
  //   try {
  //     isLoading.value = true;

  //     // Chuẩn bị request data
  //     final Map<String, dynamic> requestData = {
  //       'userId': userId,
  //       'removeAvatar': true,
  //     };

  //     // Hiển thị loading indicator
  //     Get.dialog(
  //       Dialog(
  //         backgroundColor: Colors.transparent,
  //         elevation: 0,
  //         child: Center(
  //           child: Container(
  //             padding: EdgeInsets.all(20),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 CircularProgressIndicator(
  //                   valueColor:
  //                       AlwaysStoppedAnimation<Color>(Colors.purple[700]!),
  //                 ),
  //                 SizedBox(height: 16),
  //                 Text(
  //                   'Removing image...',
  //                   style: TextStyle(
  //                     color: Colors.grey[800],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //       barrierDismissible: false,
  //     );

  //     // Gọi API để xóa avatar
  //     // final response = await AccountProfileRepository.removeAvatar(requestData);

  //     // Đóng dialog loading
  //     Get.back();

  //     // Xử lý response
  //     if (response.statusCode == 200) {
  //       // Cập nhật avatarUrl về null hoặc URL mặc định
  //       final defaultAvatarUrl =
  //           'https://res.cloudinary.com/dlipvbdwi/image/upload/v1705123226/Capstone/avatar_default_zhjqey.jpg';

  //       // Cập nhật avatarUrl trong model
  //       accountProfileModel.value = accountProfileModel.value.copyWith(
  //         avatarUrl: defaultAvatarUrl,
  //       );

  //       // Thông báo thành công
  //       Get.snackbar(
  //         'Success',
  //         'Profile picture removed successfully',
  //         backgroundColor: Colors.green[100],
  //         colorText: Colors.green[800],
  //         snackPosition: SnackPosition.BOTTOM,
  //         margin: EdgeInsets.all(16),
  //       );

  //       // Cập nhật AccountProfileController
  //       Get.find<AccountProfileController>().getAccountProfile();
  //     } else {
  //       // Xử lý lỗi
  //       Get.snackbar(
  //         'Error',
  //         'Failed to remove profile picture: ${json.decode(response.body)['message'] ?? 'Unknown error'}',
  //         backgroundColor: Colors.red[100],
  //         colorText: Colors.red[800],
  //         snackPosition: SnackPosition.BOTTOM,
  //         margin: EdgeInsets.all(16),
  //       );
  //     }
  //   } catch (e) {
  //     // Đóng dialog loading nếu có lỗi
  //     if (Get.isDialogOpen!) {
  //       Get.back();
  //     }

  //     // Xử lý lỗi
  //     print('Error in removeAvatar: $e');
  //     Get.snackbar(
  //       'Error',
  //       'Failed to remove avatar: ${e.toString()}',
  //       backgroundColor: Colors.red[100],
  //       colorText: Colors.red[800],
  //       snackPosition: SnackPosition.BOTTOM,
  //       margin: EdgeInsets.all(16),
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

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
        'dateOfBirth': dateOfBirthController.text,
        'avatarUrl': accountProfileModel.value.avatarUrl,
      };

      // Show loading indicator

      // Call API to update account profile
      var response =
          await AccountProfileRepository.updateAccountProfile(request);

      // Handle response
      if (response.statusCode == 200) {
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
        Get.find<AccountProfileController>().getAccountProfile();
        // Navigate back with success result
        Get.back(result: true);
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
}
