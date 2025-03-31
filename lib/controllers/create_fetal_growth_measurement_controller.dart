import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pregnancy_tracker/controllers/fetal_growth_measurement_controller.dart';

import '../fetal_growth_measurement/fetal_growth_measurement_screen.dart';
import '../models/fetal_growth_measurement_model.dart';
import '../models/height_summary_model.dart';
import '../models/pregnancy_profile_model.dart';
import '../models/weight_summary_model.dart';
import '../repositories/fetal_growth_measurement_repository.dart';
import '../util/app_export.dart';

class CreateFetalGrowthMeasurementController extends GetxController {
  Rx<PregnancyProfileModel> pregnancyProfileModel = PregnancyProfileModel().obs;
  final GlobalKey<FormState> fetalGrowthMeasurementFormKey =
      GlobalKey<FormState>();
  RxList<FetalGrowthMeasurementModel> fetalGrowthMeasurementModel =
      RxList.empty();
  RxList<HeightData> heightData = RxList.empty();
  RxList<WeightData> weightData = RxList.empty();
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController heartRateController;
  late TextEditingController bellyCircumferenceController;
  late TextEditingController headCircumferenceController;
  late TextEditingController movementCountController;
  late TextEditingController notesController;
  late TextEditingController measurementDateController;

  late int pregnancyId;

  var height = '';
  var weight = '';
  var heartRate = '';
  var bellyCircumference = '';
  var headCircumference = '';
  var movementCount = '';
  var notes = '';
  var isLoading = false.obs;

  // Thêm một RxBool để theo dõi trạng thái refresh
  RxBool needsRefresh = false.obs;

  // Thêm biến để lưu error message
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    pregnancyId = int.parse(Get.parameters['pregnancyId']!);
    // Khởi tạo các controller
    heightController = TextEditingController();
    weightController = TextEditingController();
    heartRateController = TextEditingController();
    bellyCircumferenceController = TextEditingController();
    headCircumferenceController = TextEditingController();
    movementCountController = TextEditingController();
    notesController = TextEditingController();
    measurementDateController = TextEditingController();

    // Fetch dữ liệu ban đầu
    // fetchFetalGrowthMeasurementData();

    // Thiết lập interval để kiểm tra và refresh dữ liệu
    setupRefreshListener();

    isLoading.value = false;
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

  String? validateHeartRate(String value) {
    if (value.isEmpty) return null;
    if (!RegExp(r'^\d*\.?\d+$').hasMatch(value))
      return "Heart rate must be a number";
    return null;
  }

  String? validateBellyCircumference(String value) {
    if (value.isEmpty) return null;
    if (!RegExp(r'^\d*\.?\d+$').hasMatch(value))
      return "Belly circumference must be a number";
    return null;
  }

  String? validateHeadCircumference(String value) {
    if (value.isEmpty) return null;
    if (!RegExp(r'^\d*\.?\d+$').hasMatch(value))
      return "Head circumference must be a number";
    return null;
  }

  String? validateMovementCount(String value) {
    if (value.isEmpty) return null;
    if (!RegExp(r'^\d*\.?\d+$').hasMatch(value))
      return "Movement count must be a number";
    return null;
  }

  // Thêm hàm để setup refresh listener
  void setupRefreshListener() {
    ever(needsRefresh, (bool needsRefresh) {
      if (needsRefresh) {
        fetchFetalGrowthMeasurementData();
        this.needsRefresh.value = false;
      }
    });
  }

  Future<void> fetchFetalGrowthMeasurementData() async {
    try {
      isLoading.value = true;
      pregnancyId = int.parse(Get.parameters['pregnancyId']!);

      // Fetch tất cả dữ liệu cần thiết
      await Future.wait([
        getFetalGrowthMeasurement(pregnancyId),
        getHeightMeasurements(pregnancyId),
        getWeightMeasurements(pregnancyId),
      ]);

      // Sort measurements by date
      fetalGrowthMeasurementModel.sort(
        (a, b) => b.measurementDate!
            .compareTo(a.measurementDate!), // Sắp xếp mới nhất lên đầu
      );

      // Refresh các RxList
      fetalGrowthMeasurementModel.refresh();
      heightData.refresh();
      weightData.refresh();
    } catch (e) {
      print('Error fetching measurements: $e');
      Get.snackbar('Error', 'Failed to fetch measurements');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getFetalGrowthMeasurement(int pregnancyId) async {
    var response =
        await FetalGrowthMeasurementRepository.getFetalGrowthMeasurementList(
            pregnancyId);

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      fetalGrowthMeasurementModel.value =
          fetalGrowthMeasurementModelFromJson(jsonResult);
    } else if (response.statusCode == 401) {
      String message = jsonDecode(response.body)['message'];
      if (message.contains("JWT token is expired")) {
        Get.snackbar('Session Expired', 'Please login again');
      }
    } else if (response.statusCode == 403) {
      Get.dialog(
        AlertDialog(
          title: Text(
            'Premium Feature',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock,
                size: 50,
                color: Colors.amber,
              ),
              SizedBox(height: 16),
              const Text(
                'This feature is only available for premium members.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                // Get.toNamed(AppRoutes.sidebarnar);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else {
      Get.snackbar(
        "Error ${response.statusCode}",
        jsonDecode(response.body)['message'],
      );
    }
  }

  Future<void> getHeightMeasurements(int pregnancyId) async {
    var response = await FetalGrowthMeasurementRepository
        .getHeightFetalGrowthMeasurementList(pregnancyId);

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      var heightDataList = heightSummaryModelFromJson(jsonResult);

      // Update existing measurements with height data
      for (var heightMeasurement in heightDataList) {
        heightData.add(HeightData(heightMeasurement.weekNumber!,
            heightMeasurement.height!.toDouble()));
      }

      print('Height data: $heightData');
      heightData.refresh();

      // for (var measurement in fetalGrowthMeasurementModel) {
      //   if (measurement.weekNumber != null && measurement.height != null) {
      //     heightData
      //         .add(HeightData(measurement.weekNumber!, measurement.height!));
      //   }
      // }

      // Trigger UI update
      fetalGrowthMeasurementModel.refresh();
    } else if (response.statusCode == 401) {
      String message = jsonDecode(response.body)['message'];
      if (message.contains("JWT token is expired")) {
        Get.snackbar('Session Expired', 'Please login again');
      }
    }
  }

  Future<void> getWeightMeasurements(int pregnancyId) async {
    var response = await FetalGrowthMeasurementRepository
        .getWeightFetalGrowthMeasurementList(pregnancyId);

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      var weightDataList = weightSummaryModelFromJson(jsonResult);

      // Update existing measurements with weight data
      for (var weightMeasurement in weightDataList) {
        weightData.add(WeightData(weightMeasurement.weekNumber!,
            weightMeasurement.weight!.toDouble()));
        print('Weight data: $weightData');
        weightData.refresh();

        // for (var measurement in fetalGrowthMeasurementModel) {
        //   if (measurement.weekNumber != null && measurement.height != null) {
        //     heightData
        //         .add(HeightData(measurement.weekNumber!, measurement.height!));
        //   }
        // }

        // Trigger UI update
        fetalGrowthMeasurementModel.refresh();
      }
    } else if (response.statusCode == 401) {
      String message = jsonDecode(response.body)['message'];
      if (message.contains("JWT token is expired")) {
        Get.snackbar('Session Expired', 'Please login again');
      }
    }
  }

  Future<void> addFetalGrowthMeasurement() async {
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

      // Create model with validated data
      FetalGrowthMeasurementModel fetalGrowthMeasurement =
          FetalGrowthMeasurementModel(
        pregnancyProfileId: pregnancyId,
        measurementDate: measurementDate,
        height: height,
        weight: weight,
        heartRate: heartRate ?? 0, // Use default value if null
        bellyCircumference: bellyCircumference ?? 0,
        headCircumference: headCircumference ?? 0,
        movementCount: movementCount ?? 0,
        notes: notesController.text,
      );

      // Call API
      var response =
          await FetalGrowthMeasurementRepository.createFetalGrowthMeasurement(
              fetalGrowthMeasurement);

      if (response.statusCode == 200) {
        clearFormFields();

        // Đưa result về true để màn hình trước biết là đã tạo thành công
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
                    const Text('Fetal growth measurement added successfully!'),
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

        Get.offAllNamed(AppRoutes.fetalgrowthmeasurement, parameters: {
          'pregnancyId': pregnancyId.toString(),
        });
      } else if (response.statusCode == 401) {
        handleUnauthorized(response as Response<dynamic>);
      } else if (response.statusCode == 400) {
        var errorData = jsonDecode(response.body);
        errorMessage.value = errorData['message'] ?? 'Bad Request';
      } else {
        handleError(response as Response<dynamic>);
      }
    } catch (e) {
      print('Error in addFetalGrowthMeasurement: $e');
      errorMessage.value = 'An error occurred while saving the measurement';
    } finally {
      isLoading.value = false;
    }
  }

  // Hàm để clear form fields
  void clearFormFields() {
    heightController.clear();
    weightController.clear();
    heartRateController.clear();
    bellyCircumferenceController.clear();
    headCircumferenceController.clear();
    movementCountController.clear();
    notesController.clear();
    measurementDateController.clear();
  }

  // Hàm xử lý lỗi unauthorized
  void handleUnauthorized(Response response) {
    String message = jsonDecode(response.body)['message'];
    if (message.contains("JWT token is expired")) {
      Get.snackbar('Session Expired', 'Please login again');
    }
  }

  // Hàm xử lý lỗi chung
  void handleError(Response response) {
    Get.snackbar(
      "Error ${response.statusCode}",
      jsonDecode(response.body)['message'],
    );
  }
}
