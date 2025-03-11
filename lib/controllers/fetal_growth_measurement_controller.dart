import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../fetal_growth_measurement/fetal_growth_measurement_screen.dart';
import '../models/fetal_growth_measurement_model.dart';
import '../models/height_summary_model.dart';
import '../models/pregnancy_profile_model.dart';
import '../models/weight_summary_model.dart';
import '../repositories/fetal_growth_measurement_repository.dart';
import '../util/app_export.dart';

class FetalGrowthMeasurementController extends GetxController {
  RxList<FetalGrowthMeasurementModel> fetalGrowthMeasurementModel =
      RxList.empty();
  RxList<HeightData> heightData = RxList.empty();
  RxList<WeightData> weightData = RxList.empty();
  Rx<PregnancyProfileModel> pregnancyProfileModel = PregnancyProfileModel().obs;
  final GlobalKey<FormState> fetalGrowthMeasurementFormKey =
      GlobalKey<FormState>();
  late TextEditingController weekNumberController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController heartRateController;
  late TextEditingController bellyCircumferenceController;
  late TextEditingController headCircumferenceController;
  late TextEditingController movementCountController;
  late TextEditingController notesController;
  late TextEditingController measurementDateController;

  late int pregnancyId;
  late int measurementId;

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

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    pregnancyId = Get.arguments;
    // Khởi tạo các controller
    weekNumberController = TextEditingController();
    heightController = TextEditingController();
    weightController = TextEditingController();
    heartRateController = TextEditingController();
    bellyCircumferenceController = TextEditingController();
    headCircumferenceController = TextEditingController();
    movementCountController = TextEditingController();
    notesController = TextEditingController();
    measurementDateController = TextEditingController();

    // Fetch dữ liệu ban đầu
    fetchFetalGrowthMeasurementData();

    // Thiết lập interval để kiểm tra và refresh dữ liệu
    setupRefreshListener();

    isLoading.value = false;
  }

  @override
  void onClose() {
    weekNumberController.dispose();
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

  String? validateWeekNumber(String value) {
    if (value.isEmpty) return "Week number is required";
    if (!RegExp(r'^\d+$').hasMatch(value))
      return "Week number must be a number";
    int? number = int.tryParse(value);
    if (number == null || number < 1 || number > 45)
      return "Week number must be between 1 and 45";
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
    if (!RegExp(r'^\d+$').hasMatch(value)) return "Heart rate must be a number";
    int? number = int.tryParse(value);
    if (number == null || number < 60 || number > 200)
      return "Heart rate must be between 60 and 200";
    return null;
  }

  String? validateBellyCircumference(String value) {
    if (!RegExp(r'^\d*\.?\d+$').hasMatch(value))
      return "Belly circumference must be a number";
    double? number = double.tryParse(value);
    if (number == null || number <= 0)
      return "Belly circumference must be greater than 0";
    return null;
  }

  String? validateHeadCircumference(String value) {
    if (!RegExp(r'^\d*\.?\d+$').hasMatch(value))
      return "Head circumference must be a number";
    double? number = double.tryParse(value);
    if (number == null || number <= 0)
      return "Head circumference must be greater than 0";
    return null;
  }

  String? validateMovementCount(String value) {
    if (!RegExp(r'^\d+$').hasMatch(value))
      return "Movement count must be a number";
    int? number = int.tryParse(value);
    if (number == null || number < 0)
      return "Movement count must be greater than or equal to 0";
    return null;
  }

  // String? validateNotes(String value) {
  //   if (value.isEmpty || value.length < 2) {
  //     return "Notes is not valid";
  //   }
  //   return null;
  // }

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
      pregnancyId = Get.arguments;

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

    print('General measurements response: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      fetalGrowthMeasurementModel.value =
          fetalGrowthMeasurementModelFromJson(response.body);
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock,
                size: 50,
                color: Colors.amber,
              ),
              SizedBox(height: 16),
              Text(
                'This feature is only available for premium members.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                // Get.toNamed(AppRoutes.sidebarnar);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
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
    heightData.clear();
    var response = await FetalGrowthMeasurementRepository
        .getHeightFetalGrowthMeasurementList(pregnancyId);

    print('Height measurements response: ${response.statusCode}');
    print('Height response body: ${response.body}');

    if (response.statusCode == 200) {
      var heightDataList = heightSummaryModelFromJson(response.body);
      print('Height data list: $heightDataList');

      // Update existing measurements with height data
      for (var heightMeasurement in heightDataList) {
        heightData.add(HeightData(heightMeasurement.weekNumber!,
            heightMeasurement.height!.toDouble()));
        print('Height data: $heightData');
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
    weightData.clear();
    var response = await FetalGrowthMeasurementRepository
        .getWeightFetalGrowthMeasurementList(pregnancyId);

    print('Weight measurements response: ${response.statusCode}');
    print('Weight response body: ${response.body}');

    if (response.statusCode == 200) {
      var weightDataList = weightSummaryModelFromJson(response.body);
      print('Weight data list: $weightDataList');

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
      final isValid = fetalGrowthMeasurementFormKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      fetalGrowthMeasurementFormKey.currentState!.save();

      DateTime measurementDate =
          DateFormat('yyyy-MM-dd').parse(measurementDateController.text);

      FetalGrowthMeasurementModel fetalGrowthMeasurement =
          FetalGrowthMeasurementModel(
        pregnancyProfileId: pregnancyId,
        measurementDate: measurementDate,
        weekNumber: int.parse(weekNumberController.text),
        height: double.parse(heightController.text),
        weight: double.parse(weightController.text),
        heartRate: int.parse(heartRateController.text),
        bellyCircumference: double.parse(bellyCircumferenceController.text),
        headCircumference: double.parse(headCircumferenceController.text),
        notes: notesController.text,
      );

      var response =
          await FetalGrowthMeasurementRepository.createFetalGrowthMeasurement(
              fetalGrowthMeasurement);

      if (response.statusCode == 200) {
        // Trigger refresh

        clearFormFields(); // Thêm hàm này để clear form
        Get.back(result: true);
        Get.snackbar('Success', 'Fetal growth measurement added successfully');
        await fetchFetalGrowthMeasurementData();
      } else if (response.statusCode == 401) {
        handleUnauthorized(response as Response<dynamic>);
      } else {
        handleError(response as Response<dynamic>);
      }
    } catch (e) {
      print('Error adding measurement: $e');
      Get.snackbar('Error', 'Failed to add measurement');
    } finally {
      isLoading.value = false;
    }
  }

  // Thêm hàm để qua màn hình update measurement
  void navigateToUpdateMeasurement(int index) {
    var measurement = fetalGrowthMeasurementModel[index];
    Get.toNamed(
      AppRoutes.updatefetalgrowthmeasurement,
      arguments: {
        'measurementId': measurement.id,
        // 'pregnancyId': pregnancyId,
      },
    );
  }

  // Thêm hàm để xóa measurement
  // Future<void> deleteMeasurement(int measurementId) async {
  //   try {
  //     isLoading.value = true;
  //     var response =
  //         await FetalGrowthMeasurementRepository.deleteFetalGrowthMeasurement(
  //             measurementId);

  //     if (response.statusCode == 200) {
  //       // Trigger refresh sau khi xóa
  //       await fetchFetalGrowthMeasurementData();
  //       Get.snackbar('Success', 'Measurement deleted successfully');
  //     } else if (response.statusCode == 401) {
  //       handleUnauthorized(response);
  //     } else {
  //       handleError(response);
  //     }
  //   } catch (e) {
  //     print('Error deleting measurement: $e');
  //     Get.snackbar('Error', 'Failed to delete measurement');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // Hàm để clear form fields
  void clearFormFields() {
    weekNumberController.clear();
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
