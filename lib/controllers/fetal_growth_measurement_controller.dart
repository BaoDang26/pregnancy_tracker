import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/fetal_growth_measurement_model.dart';
import '../models/pregnancy_profile_model.dart';
import '../repositories/fetal_growth_measurement_repository.dart';
import '../util/app_export.dart';

class FetalGrowthMeasurementController extends GetxController {
  RxList<FetalGrowthMeasurementModel> fetalGrowthMeasurementModel =
      RxList.empty();
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

  late int pregnancyId;

  var height = '';
  var weight = '';
  var heartRate = '';
  var bellyCircumference = '';
  var headCircumference = '';
  var movementCount = '';
  var notes = '';
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchFetalGrowthMeasurementData();
    super.onInit();
    isLoading.value = true;

    weekNumberController = TextEditingController();
    heightController = TextEditingController();
    weightController = TextEditingController();
    heartRateController = TextEditingController();
    bellyCircumferenceController = TextEditingController();
    headCircumferenceController = TextEditingController();
    movementCountController = TextEditingController();
    notesController = TextEditingController();
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

  Future<void> fetchFetalGrowthMeasurementData() async {
    try {
      isLoading.value = true;
      pregnancyId = Get.arguments;
      // Get both height and general measurements
      await Future.wait([
        getFetalGrowthMeasurement(pregnancyId),
        getHeightMeasurements(pregnancyId),
      ]);

      // Sort measurements by date if needed
      fetalGrowthMeasurementModel.sort(
        (a, b) => a.measurementDate!.compareTo(b.measurementDate!),
      );
    } catch (e) {
      print('Error fetching measurements: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch measurements',
        snackPosition: SnackPosition.TOP,
      );
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

    print('Height measurements response: ${response.statusCode}');
    print('Height response body: ${response.body}');

    if (response.statusCode == 200) {
      var heightData = fetalGrowthMeasurementModelFromJson(response.body);

      // Update existing measurements with height data
      for (var heightMeasurement in heightData) {
        var existingIndex = fetalGrowthMeasurementModel.indexWhere(
            (element) => element.weekNumber == heightMeasurement.weekNumber);

        if (existingIndex != -1) {
          // Update existing measurement with height data
          fetalGrowthMeasurementModel[existingIndex].height =
              heightMeasurement.height;
        } else {
          // Add new measurement if none exists for this week
          fetalGrowthMeasurementModel.add(heightMeasurement);
        }
      }

      // Trigger UI update
      fetalGrowthMeasurementModel.refresh();
    } else if (response.statusCode == 401) {
      String message = jsonDecode(response.body)['message'];
      if (message.contains("JWT token is expired")) {
        Get.snackbar('Session Expired', 'Please login again');
      }
    }
  }

  Future<void> addFetalGrowthMeasurement() async {
    isLoading.value = true;
    final isValid = fetalGrowthMeasurementFormKey.currentState!.validate();
    if (!isValid) {
      isLoading.value = false;
      return null;
    }
    fetalGrowthMeasurementFormKey.currentState!.save();
    pregnancyId = Get.arguments;
    FetalGrowthMeasurementModel fetalGrowthMeasurement =
        FetalGrowthMeasurementModel(
      pregnancyProfileId: pregnancyId,
      weekNumber: int.parse(weekNumberController.text),
      height: double.parse(heightController.text),
      weight: double.parse(weightController.text),
      heartRate: double.parse(heartRateController.text),
      bellyCircumference: double.parse(bellyCircumferenceController.text),
      headCircumference: double.parse(headCircumferenceController.text),
      // movementCount: int.parse(movementCountController.text),
      notes: notesController.text,
    );

    var response =
        await FetalGrowthMeasurementRepository.postFetalGrowthMeasurement(
            fetalGrowthMeasurement);

    if (response.statusCode == 200) {
      List<FetalGrowthMeasurementModel> fetalGrowthMeasurement =
          fetalGrowthMeasurementModelFromJson(response.body);
      Get.back();
      Get.snackbar('Success', 'Fetal growth measurement added successfully');
    } else if (response.statusCode == 401) {
      String message = jsonDecode(response.body)['message'];
      if (message.contains("JWT token is expired")) {
        Get.snackbar('Session Expired', 'Please login again');
      }
    } else if (response.statusCode == 500) {
      log(jsonDecode(response.body)['message']);
    } else {
      Get.snackbar(
        "Error ${response.statusCode}",
        jsonDecode(response.body)['message'],
      );
    }
  }
}
