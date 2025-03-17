import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/controllers/schedule_controller.dart';

import '../models/schedule_model.dart';
import '../repositories/schedule_repository.dart';
import '../util/app_export.dart';

class UpdateScheduleController extends GetxController {
  final GlobalKey<FormState> scheduleFormKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController eventDateController;

  late int scheduleId;
  late int pregnancyProfileId;

  var isLoading = false.obs;
  RxString errorMessage = ''.obs;
  Rx<ScheduleModel> scheduleModel = ScheduleModel().obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;

    // Initialize controllers immediately
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    eventDateController = TextEditingController();

    // Safely check arguments
    try {
      // Handle if arguments is Map
      if (Get.arguments is Map<String, dynamic>) {
        final args = Get.arguments as Map<String, dynamic>;
        // Get scheduleId from arguments with default value 0 if not found
        scheduleId = args['scheduleId'] ?? 0;
        pregnancyProfileId = args['pregnancyProfileId'] ?? 0;
      }
      // Handle if arguments is a single value (assuming it's scheduleId)
      else if (Get.arguments != null) {
        scheduleId = Get.arguments is int ? Get.arguments : 0;
        pregnancyProfileId = Get.arguments['pregnancyId'] ?? 0;
      }

      // If we have a valid scheduleId, find the data
      if (scheduleId > 0) {
        findScheduleFromId();
      } else {
        print('Warning: Invalid scheduleId: $scheduleId');
        // You could set an error message here
      }
    } catch (e) {
      print('Error in onInit: $e');
      errorMessage.value = 'Failed to initialize data';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    eventDateController.dispose();
    super.onClose();
  }

  void findScheduleFromId() {
    try {
      // Check if controller is registered
      if (!Get.isRegistered<ScheduleController>()) {
        print('ScheduleController is not registered');
        return;
      }

      // Get controller with schedule list
      final scheduleController = Get.find<ScheduleController>();

      // Check if list has been initialized
      if (scheduleController.scheduleList == null ||
          scheduleController.scheduleList.isEmpty) {
        print('Schedule list is empty');
        return;
      }

      // Find schedule based on ID, with default value if not found
      final schedule = scheduleController.scheduleList
          .firstWhere((s) => s.id == scheduleId, orElse: () => ScheduleModel());

      // Check search result
      if (schedule.id != null) {
        scheduleModel.value = schedule;
        pregnancyProfileId = schedule.pregnancyProfileId ?? 0;
        // Fill data into form
        populateFormFields();
      } else {
        print('Schedule not found with ID: $scheduleId');
      }
    } catch (e) {
      print('Error in findScheduleFromId: $e');
    }
  }

  void populateFormFields() {
    final schedule = scheduleModel.value;

    // Fill values into controllers
    titleController.text = schedule.title ?? '';
    descriptionController.text = schedule.description ?? '';

    // Format event date
    if (schedule.eventDate != null) {
      eventDateController.text =
          DateFormat('yyyy-MM-dd').format(schedule.eventDate!);
    }
  }

  String? validateTitle(String value) {
    if (value.isEmpty) return "Title is required";
    return null;
  }

  String? validateEventDate(String value) {
    if (value.isEmpty) return "Event date is required";
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value))
      return "Invalid date format. Please use YYYY-MM-DD";
    return null;
  }

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
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          width: 300,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Appointment Date",
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
                      bodyMedium: TextStyle(fontSize: 12),
                      bodySmall: TextStyle(fontSize: 12),
                      titleSmall: TextStyle(fontSize: 12),
                    ),
                  ),
                  child: CalendarDatePicker(
                    initialDate: initialDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
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

  Future<void> updateSchedule() async {
    try {
      isLoading.value = true;
      pregnancyProfileId = Get.arguments['pregnancyId'];
      // Validate form
      final isValid = scheduleFormKey.currentState!.validate();
      if (!isValid) {
        isLoading.value = false;
        return;
      }

      // Validate event date
      if (eventDateController.text.isEmpty) {
        errorMessage.value = "Event date is required";
        isLoading.value = false;
        return;
      }

      // Parse date with error handling
      DateTime eventDate;
      try {
        eventDate = DateFormat('yyyy-MM-dd').parse(eventDateController.text);
      } catch (e) {
        errorMessage.value = "Invalid date format. Please use YYYY-MM-DD";
        isLoading.value = false;
        return;
      }

      // Create data for update to avoid DateTime serialization issues
      Map<String, dynamic> scheduleData = {
        // 'id': scheduleId,
        'title': titleController.text,
        'description': descriptionController.text,
        'eventDate': eventDateController
            .text, // Send as string to avoid JSON encoding issues
        'pregnancyProfileId': Get.arguments['pregnancyId'],
      };

      print('Updating schedule with data: $scheduleData');

      // Call API to update data
      var response =
          await ScheduleRepository.updateSchedule(scheduleData, scheduleId);

      if (response.statusCode == 200) {
        // Navigate back with success result
        Get.back(result: true);

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
                    const Text('Schedule updated successfully!'),
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

        // Refresh schedule list
        Get.find<ScheduleController>().getScheduleList();
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
      print('Error in updateSchedule: $e');
      errorMessage.value = 'An error occurred while updating the schedule';
    } finally {
      isLoading.value = false;
    }
  }

  void showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Delete Schedule?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete this schedule?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[800])),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // deleteSchedule();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> deleteSchedule() async {
  //   try {
  //     isLoading.value = true;

  //     var response = await ScheduleRepository.deleteSchedule(scheduleId);

  //     if (response.statusCode == 200) {
  //       // Navigate back with success result
  //       Get.back(result: true);

  //       // Show success message
  //       Get.snackbar(
  //         'Success',
  //         'Schedule deleted successfully',
  //         backgroundColor: Colors.green[100],
  //         colorText: Colors.green[800],
  //         snackPosition: SnackPosition.BOTTOM,
  //       );

  //       // Refresh schedule list
  //       Get.find<ScheduleController>().getScheduleList();
  //     } else if (response.statusCode == 401) {
  //       String message = jsonDecode(response.body)['message'];
  //       if (message.contains("JWT token is expired")) {
  //         Get.snackbar('Session Expired', 'Please login again');
  //       }
  //     } else {
  //       Get.snackbar("Error server ${response.statusCode}",
  //           jsonDecode(response.body)['message']);
  //     }
  //   } catch (e) {
  //     print('Error in deleteSchedule: $e');
  //     errorMessage.value = 'An error occurred while deleting the schedule';
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
