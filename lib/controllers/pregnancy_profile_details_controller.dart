import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pregnancy_tracker/models/pregnancy_profile_model.dart';

import '../models/fetal_growth_measurement_model.dart';
import '../models/schedule_model.dart';
import '../repositories/fetal_growth_measurement_repository.dart';
import '../repositories/schedule_repository.dart';
import '../util/app_export.dart';

class PregnancyProfileDetailsController extends GetxController {
  var isLoading = false.obs;
  Rx<PregnancyProfileModel> pregnancyProfileModel = PregnancyProfileModel().obs;
  RxList<FetalGrowthMeasurementModel> fetalGrowthMeasurementModel =
      RxList.empty();
  RxList<ScheduleModel> scheduleModel = RxList.empty();
  late int pregnancyId;

  @override
  Future<void> onInit() async {
    pregnancyProfileModel.value = Get.arguments;
    pregnancyId = pregnancyProfileModel.value.id!;
    super.onInit();
  }

  Future<void> goToSchedule() async {
    var response = await ScheduleRepository.getScheduleList();
    if (response.statusCode == 200) {
      scheduleModel.value = scheduleModelFromJson(response.body);
      Get.toNamed(AppRoutes.schedule, arguments: pregnancyId);
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
            // TextButton(
            //   onPressed: () => Get.back(),
            //   child: Text('Cancel'),
            // ),
            ElevatedButton(
              onPressed: () {
                // Chuyển về sidebar và chọn tab subscription plan
                Get.offAllNamed(AppRoutes.sidebarnar,
                    arguments: {'selectedIndex': 3});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Back to Subscription Plans',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else if (response.statusCode == 404) {
      // Get.snackbar(
      //   "Fetal growth measurement not found",
      //   "Please add fetal growth measurement",

      // );
      Get.dialog(
        AlertDialog(
          title: Text(
            'Schedule is not found',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning,
                size: 50,
                color: Colors.amber,
              ),
              SizedBox(height: 16),
              Text(
                'Please add schedule',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(Get.context!).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Get.back();
                // Get.offNamed(AppRoutes.createfetalgrowthmeasurement,
                //     arguments: pregnancyId);
                // Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Add measurement',
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

  Future<void> goToFetalGrowthMeasurement() async {
    pregnancyId = pregnancyProfileModel.value.id!;
    var response =
        await FetalGrowthMeasurementRepository.getFetalGrowthMeasurementList(
            pregnancyId);

    print('General measurements response: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      fetalGrowthMeasurementModel.value =
          fetalGrowthMeasurementModelFromJson(response.body);
      Get.toNamed(AppRoutes.fetalgrowthmeasurement, arguments: pregnancyId);
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
            // TextButton(
            //   onPressed: () => Get.back(),
            //   child: Text('Cancel'),
            // ),
            ElevatedButton(
              onPressed: () {
                // Chuyển về sidebar và chọn tab subscription plan
                Get.offAllNamed(AppRoutes.sidebarnar,
                    arguments: {'selectedIndex': 3});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Back to Subscription Plans',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else if (response.statusCode == 404) {
      // Get.snackbar(
      //   "Fetal growth measurement not found",
      //   "Please add fetal growth measurement",

      // );
      Get.dialog(
        AlertDialog(
          title: Text(
            'Fetal growth measurement not found',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning,
                size: 50,
                color: Colors.amber,
              ),
              SizedBox(height: 16),
              Text(
                'Please add fetal growth measurement',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(Get.context!).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Get.back();
                Get.offNamed(AppRoutes.createfetalgrowthmeasurement,
                    arguments: pregnancyId);
                // Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Add measurement',
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
}
