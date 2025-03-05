import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/controllers/fetal_growth_measurement_controller.dart';

import '../models/fetal_growth_measurement_model.dart';
import '../repositories/fetal_growth_measurement_repository.dart';
import '../util/app_export.dart';

class UpdateFetalGrowthMeasurementController extends GetxController {
  final GlobalKey<FormState> fetalGrowthMeasurementFormKey =
      GlobalKey<FormState>();

  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController heartRateController;
  late TextEditingController bellyCircumferenceController;
  late TextEditingController headCircumferenceController;
  late TextEditingController movementCountController;
  late TextEditingController notesController;
  late TextEditingController measurementDateController;

  late int measurementId;
  late int pregnancyId;

  var isLoading = false.obs;
  RxString errorMessage = ''.obs;
  Rx<FetalGrowthMeasurementModel> measurementModel =
      FetalGrowthMeasurementModel().obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;

    // Khởi tạo các controller ngay lập tức
    heightController = TextEditingController();
    weightController = TextEditingController();
    heartRateController = TextEditingController();
    bellyCircumferenceController = TextEditingController();
    headCircumferenceController = TextEditingController();
    movementCountController = TextEditingController();
    notesController = TextEditingController();
    measurementDateController = TextEditingController();

    // Kiểm tra arguments một cách an toàn
    try {
      // Xử lý nếu arguments là Map
      if (Get.arguments is Map<String, dynamic>) {
        final args = Get.arguments as Map<String, dynamic>;
        // Lấy measurementId từ arguments với giá trị mặc định 0 nếu không tìm thấy
        measurementId = args['measurementId'] ?? 0;
        pregnancyId = args['pregnancyId'] ?? 0;
      }
      // Xử lý nếu arguments là một giá trị đơn (giả sử là measurementId)
      else if (Get.arguments != null) {
        measurementId = Get.arguments is int ? Get.arguments : 0;
        pregnancyId = Get.arguments is int ? Get.arguments : 0;
      }

      // Nếu có measurementId hợp lệ, tìm dữ liệu
      if (measurementId > 0) {
        findMeasurementFromId();
      } else {
        print('Warning: Invalid measurementId: $measurementId');
        // Có thể đặt thông báo lỗi ở đây
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
    heightController.dispose();
    weightController.dispose();
    heartRateController.dispose();
    bellyCircumferenceController.dispose();
    headCircumferenceController.dispose();
    movementCountController.dispose();
    notesController.dispose();
    measurementDateController.dispose();
    super.onClose();
  }

  void findMeasurementFromId() {
    try {
      // Kiểm tra xem controller đã được đăng ký chưa
      if (!Get.isRegistered<FetalGrowthMeasurementController>()) {
        print('FetalGrowthMeasurementController is not registered');
        return;
      }

      // Lấy controller chứa danh sách measurements
      final fetalController = Get.find<FetalGrowthMeasurementController>();

      // Kiểm tra danh sách đã được khởi tạo chưa
      if (fetalController.fetalGrowthMeasurementModel == null ||
          fetalController.fetalGrowthMeasurementModel.isEmpty) {
        print('Measurement list is empty');
        return;
      }

      // Tìm measurement dựa trên ID, với giá trị mặc định nếu không tìm thấy
      final measurement = fetalController.fetalGrowthMeasurementModel
          .firstWhere((m) => m.id == measurementId,
              orElse: () => FetalGrowthMeasurementModel());

      // Kiểm tra kết quả tìm kiếm
      if (measurement.id != null) {
        measurementModel.value = measurement;

        // Điền dữ liệu vào form
        populateFormFields();
      } else {
        print('Measurement not found with ID: $measurementId');
      }
    } catch (e) {
      print('Error in findMeasurementFromId: $e');
    }
  }

  void populateFormFields() {
    final measurement = measurementModel.value;

    // Điền các giá trị vào controller
    heightController.text = measurement.height?.toString() ?? '';
    weightController.text = measurement.weight?.toString() ?? '';
    heartRateController.text = measurement.heartRate?.toString() ?? '';
    bellyCircumferenceController.text =
        measurement.bellyCircumference?.toString() ?? '';
    headCircumferenceController.text =
        measurement.headCircumference?.toString() ?? '';
    movementCountController.text = measurement.movementCount?.toString() ?? '';
    notesController.text = measurement.notes ?? '';

    // Format ngày đo lường
    if (measurement.measurementDate != null) {
      measurementDateController.text =
          DateFormat('yyyy-MM-dd').format(measurement.measurementDate!);
    }
  }

  String? validateMeasurementDate(String value) {
    if (value.isEmpty) return "Measurement date is required";
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value))
      return "Invalid date format. Please use YYYY-MM-DD";
    return null;
  }

  String? validateHeight(String value) {
    if (value.isEmpty) return "Height is required";
    if (!RegExp(r'^\d*\.?\d+$').hasMatch(value))
      return "Height must be a number";
    double? number = double.tryParse(value);
    if (number == null || number <= 0) return "Height must be greater than 0";
    return null;
  }

  String? validateWeight(String value) {
    if (value.isEmpty) return "Weight is required";
    if (!RegExp(r'^\d*\.?\d+$').hasMatch(value))
      return "Weight must be a number";
    double? number = double.tryParse(value);
    if (number == null || number <= 0) return "Weight must be greater than 0";
    return null;
  }

  Future<void> updateFetalGrowthMeasurement() async {
    try {
      isLoading.value = true;

      // Validate form
      final isValid = fetalGrowthMeasurementFormKey.currentState!.validate();
      if (!isValid) {
        isLoading.value = false;
        return;
      }

      // Validate measurement date
      if (measurementDateController.text.isEmpty) {
        errorMessage.value = "Measurement date is required";
        isLoading.value = false;
        return;
      }

      // Parse date with error handling
      DateTime measurementDate;
      try {
        measurementDate =
            DateFormat('yyyy-MM-dd').parse(measurementDateController.text);
      } catch (e) {
        errorMessage.value = "Invalid date format. Please use YYYY-MM-DD";
        isLoading.value = false;
        return;
      }

      // Parse other values with null checks and error handling
      double? height = double.tryParse(heightController.text);
      double? weight = double.tryParse(weightController.text);
      int? heartRate = int.tryParse(heartRateController.text);
      double? bellyCircumference =
          double.tryParse(bellyCircumferenceController.text);
      double? headCircumference =
          double.tryParse(headCircumferenceController.text);
      int? movementCount = int.tryParse(movementCountController.text ?? '0');

      // Validate required fields
      if (height == null || weight == null) {
        errorMessage.value = "Height and weight must be valid numbers";
        isLoading.value = false;
        return;
      }

      // Update model with validated data
      FetalGrowthMeasurementModel fetalGrowthMeasurement =
          FetalGrowthMeasurementModel(
        id: measurementId,
        measurementDate: measurementDate,
        height: height,
        weight: weight,
        heartRate: heartRate ?? 0, // Use default value if null
        bellyCircumference: bellyCircumference ?? 0,
        headCircumference: headCircumference ?? 0,
        movementCount: movementCount ?? 0,
        notes: notesController.text,
      );

      // Gọi API để cập nhật dữ liệu
      var response =
          await FetalGrowthMeasurementRepository.updateFetalGrowthMeasurement(
              fetalGrowthMeasurement);

      if (response.statusCode == 200) {
        // Cập nhật dữ liệu ở màn hình danh sách
        // Get.find<FetalGrowthMeasurementController>()
        //     .fetchFetalGrowthMeasurementData();
        Get.back(result: true);
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
                    Text('Fetal growth measurement updated successfully!'),
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
        Get.find<FetalGrowthMeasurementController>()
            .fetchFetalGrowthMeasurementData();
        // Quay lại màn hình danh sách
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
      print('Error in updateFetalGrowthMeasurement: $e');
      errorMessage.value = 'An error occurred while updating the measurement';
    } finally {
      isLoading.value = false;
    }
  }

  // Hàm xử lý lỗi unauthorized
  // void handleUnauthorized(Response response) {
  //   String message = jsonDecode(response.body)['message'];
  //   if (message.contains("JWT token is expired")) {
  //     Get.snackbar('Session Expired', 'Please login again');
  //   }
  // }

  // // Hàm xử lý lỗi chung
  // void handleError(Response response) {
  //   Get.snackbar(
  //     "Error ${response.statusCode}",
  //     jsonDecode(response.body)['message'],
  //   );
  // }
}
