import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/pregnancy_profile_model.dart';
import '../repositories/pregnancy_profile_repository.dart';
import '../util/app_export.dart';

class CreatePregnancyProfileController extends GetxController {
  final GlobalKey<FormState> pregnancyProfileFormKey = GlobalKey<FormState>();
  late TextEditingController nickNameController;
  late TextEditingController dueDateController;
  late TextEditingController lastPeriodDateController;
  // late TextEditingController pregnancyWeekController;
  late TextEditingController notesController;

  var pregnancyProfileList = <PregnancyProfileModel>[].obs;
  var nickName = '';
  var dueDate = '';

  var lastPeriodDate = '';
  var pregnancyWeek = '';
  var notes = '';
  var errorString = ''.obs;
  var isLoading = false.obs;

  Rx<PregnancyProfileModel> pregnancyProfileModel = PregnancyProfileModel().obs;

  @override
  void onInit() {
    nickNameController = TextEditingController();
    dueDateController = TextEditingController();
    lastPeriodDateController = TextEditingController();
    // pregnancyWeekController = TextEditingController();
    notesController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    nickNameController.dispose();
    dueDateController.dispose();
    lastPeriodDateController.dispose();
    // pregnancyWeekController.dispose();
    notesController.dispose();
    super.onClose();
  }

  String? validateNickName(String value) {
    if (value.isEmpty) {
      return 'Please enter nick name';
    }
    return null;
  }

  String? validateLastPeriodDate(String value) {
    if (value.isEmpty) {
      return 'Please select last period date';
    }
    return null;
  }

  String validatePregnancyWeek(String value) {
    if (value.isEmpty) {
      return 'Please enter week of pregnancy';
    }
    int? week = int.tryParse(value);
    if (week == null) {
      return 'Please enter a valid number';
    }
    if (week < 1 || week > 42) {
      return 'Week must be between 1 and 42';
    }
    return '';
  }

  Future<void> getPregnancyProfileList() async {
    isLoading.value = true;
    var response = await PregnancyProfileRepository.getPregnancyProfileList();

    // Log the response status and body
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      // Log the JSON result
      print("JSON Result: $jsonResult");

      // Convert JSON to model
      pregnancyProfileList.value = pregnancyProfileModelFromJson(jsonResult);
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }

  Future<void> createPregnancyProfile() async {
    isLoading = true.obs;

    final isValid = pregnancyProfileFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    pregnancyProfileFormKey.currentState!.save();

    // Tạo PregnancyProfileModel với DateTime được parse trực tiếp
    PregnancyProfileModel pregnancyProfileModel = PregnancyProfileModel(
      nickName: nickName,
      dueDate: DateTime.parse(
          dueDateController.text), // Sử dụng DateTime.parse trực tiếp
      lastPeriodDate: DateTime.parse(
          lastPeriodDateController.text), // Sử dụng DateTime.parse trực tiếp
      notes: notes,
    );

    var response = await PregnancyProfileRepository.createPregnancyProfile(
        pregnancyProfileModel);

    //kiểm tra kết quả
    if (response.statusCode == 200) {
      // convert list exercises from json
      await getPregnancyProfileList();
      Get.back(result: true);
      showDialog(
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
                  Text('Pregnancy profile created successfully!'),
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
      // Get.snackbar("Success", jsonDecode(response.body)["message"]);
    } else if (response.statusCode == 400) {
      // thông báo lỗi
      Get.snackbar("Create failed!", jsonDecode(response.body)["message"]);
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }

    isLoading = false.obs;
  }
}
