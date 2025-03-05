import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/controllers/schedule_controller.dart';

import '../models/schedule_model.dart';
import '../repositories/schedule_repository.dart';
import '../util/app_export.dart';

class CreateScheduleController extends GetxController {
  final GlobalKey<FormState> scheduleFormKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController eventDateController;

  late int pregnancyProfileId;

  var isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;

    // Lấy pregnancyProfileId từ arguments
    // pregnancyProfileId = Get.arguments;

    // Khởi tạo các controller
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    eventDateController = TextEditingController();

    isLoading.value = false;
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    eventDateController.dispose();
    super.onClose();
  }

  // Xác thực tiêu đề
  String? validateTitle(String value) {
    if (value.isEmpty) return "Title is required";
    if (value.length < 3) return "Title must be at least 3 characters";
    return null;
  }

  // Xác thực ngày hẹn
  String? validateEventDate(String value) {
    if (value.isEmpty) return "Appointment date is required";
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value))
      return "Invalid date format. Please use YYYY-MM-DD";

    try {
      final date = DateFormat('yyyy-MM-dd').parse(value);
      final now = DateTime.now();
      if (date.isBefore(now.subtract(Duration(days: 1)))) {
        return "Appointment date cannot be in the past";
      }
    } catch (e) {
      return "Invalid date";
    }

    return null;
  }

  // Thêm lịch hẹn mới
  Future<void> addSchedule() async {
    try {
      isLoading.value = true;
      // Lấy pregnancyProfileId từ arguments
      pregnancyProfileId = Get.arguments;
      print("pregnancyProfileId: $pregnancyProfileId");

      // Xác thực form
      final isValid = scheduleFormKey.currentState!.validate();
      if (!isValid) {
        isLoading.value = false;
        return;
      }

      // Xác thực ngày hẹn
      if (eventDateController.text.isEmpty) {
        errorMessage.value = "Appointment date is required";
        isLoading.value = false;
        return;
      }

      // Parse ngày với xử lý lỗi
      DateTime eventDate;
      try {
        eventDate = DateFormat('yyyy-MM-dd').parse(eventDateController.text);
      } catch (e) {
        errorMessage.value = "Invalid date format. Please use YYYY-MM-DD";
        isLoading.value = false;
        return;
      }

      // Tạo model với dữ liệu đã xác thực
      ScheduleModel schedule = ScheduleModel(
        pregnancyProfileId: pregnancyProfileId,
        title: titleController.text,
        description: descriptionController.text,
        eventDate: eventDate,
      );

      // Gọi API
      var response = await ScheduleRepository.createSchedule(schedule);

      if (response.statusCode == 200) {
        clearFormFields();

        // Hiển thị dialog thành công
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
                    Text('Appointment scheduled successfully!'),
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

        // Refresh danh sách ở màn hình chính
        if (Get.isRegistered<ScheduleController>()) {
          Get.find<ScheduleController>().getScheduleList();
        }

        // Quay lại màn hình danh sách
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
        Get.snackbar(
          "Error ${response.statusCode}",
          jsonDecode(response.body)['message'],
        );
      }
    } catch (e) {
      print('Error in addSchedule: $e');
      errorMessage.value = 'An error occurred while saving the appointment';
    } finally {
      isLoading.value = false;
    }
  }

  // Xóa dữ liệu form
  void clearFormFields() {
    titleController.clear();
    descriptionController.clear();
    eventDateController.clear();
  }

  // Xử lý lỗi unauthorized
  // void handleUnauthorized(Response response) {
  //   String message = jsonDecode(response.body)['message'];
  //   if (message.contains("JWT token is expired")) {
  //     Get.snackbar('Session Expired', 'Please login again');
  //   }
  // }

  // // Xử lý lỗi chung
  // void handleError(Response response) {
  //   Get.snackbar(
  //     "Error ${response.statusCode}",
  //     jsonDecode(response.body)['message'],
  //   );
  // }

  // Helper function để hiển thị date picker
  void showDatePicker() {
    DateTime initialDate = DateTime.now();
    if (eventDateController.text.isNotEmpty) {
      try {
        initialDate = DateFormat('yyyy-MM-dd').parse(eventDateController.text);
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
                "Pick a date",
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
                      eventDateController.text =
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
}
