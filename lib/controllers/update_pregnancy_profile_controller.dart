import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pregnancy_tracker/controllers/pregnancy_profile_controller.dart';

import '../models/pregnancy_profile_model.dart';
import '../repositories/pregnancy_profile_repository.dart';

class UpdatePregnancyProfileController extends GetxController {
  final GlobalKey<FormState> updatePregnancyProfileFormKey =
      GlobalKey<FormState>();
  late TextEditingController nickNameController;
  late TextEditingController notesController;

  late int pregnancyId;

  var nickName = '';
  var notes = '';
  var errorString = ''.obs;
  var isLoading = false.obs;

  Rx<PregnancyProfileModel> pregnancyProfileModel = PregnancyProfileModel().obs;

  @override
  void onInit() {
    nickNameController = TextEditingController();
    notesController = TextEditingController();

    // More defensive argument handling
    if (Get.arguments != null) {
      // Check if arguments is a map with 'pregnancyId' key
      if (Get.arguments is Map && Get.arguments.containsKey('pregnancyId')) {
        pregnancyId = Get.arguments['pregnancyId'];
        getPregnancyProfile(pregnancyId);
      }
      // Handle direct int argument as fallback
      else if (Get.arguments is int) {
        pregnancyId = Get.arguments;
        getPregnancyProfile(pregnancyId);
      }
    }

    super.onInit();
  }

  @override
  void onClose() {
    nickNameController.dispose();
    notesController.dispose();
    super.onClose();
  }

  // Validate nickname field
  String? validateNickName(String value) {
    if (value.isEmpty) {
      return 'Please enter nick name';
    }
    return null;
  }

  // Get pregnancy profile by ID
  Future<void> getPregnancyProfile(int id) async {
    isLoading.value = true;
    var response = await PregnancyProfileRepository.getPregnancyProfileById(id);

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);

      // Initialize form fields with existing data
      nickNameController.text = pregnancyProfileModel.value.nickName ?? '';
      notesController.text = pregnancyProfileModel.value.notes ?? '';
    } else if (response.statusCode == 401) {
      Get.snackbar("Error", "Unauthorized");
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }

    isLoading.value = false;
    update();
  }

  // Update pregnancy profile
  Future<void> updatePregnancyProfile() async {
    isLoading.value = true;

    final isValid = updatePregnancyProfileFormKey.currentState!.validate();
    if (!isValid) {
      isLoading.value = false;
      return;
    }

    updatePregnancyProfileFormKey.currentState!.save();

    //create request
    var request = PregnancyProfileModel(
      id: pregnancyId,
      nickName: nickNameController.text,
      notes: notesController.text,
    );

    // Call repository to update
    var response =
        await PregnancyProfileRepository.updatePregnancyProfile(request);

    if (response.statusCode == 200) {
      Get.back(result: true);
      Get.snackbar(
        "Success",
        "Pregnancy profile updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.find<PregnancyProfileController>().getPregnancyProfileList();
    } else if (response.statusCode == 401) {
      errorString.value = "Unauthorized";
      Get.snackbar("Error", "Unauthorized");
    } else {
      errorString.value = jsonDecode(response.body)['message'];
      Get.snackbar(
        "Error updating profile",
        errorString.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    isLoading.value = false;
    update();
  }
}
