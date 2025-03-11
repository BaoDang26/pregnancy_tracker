import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/pregnancy_profile_model.dart';

class UpdatePregnancyProfileController extends GetxController {
  final GlobalKey<FormState> updatePregnancyProfileFormKey =
      GlobalKey<FormState>();
  late TextEditingController nickNameController;
  late TextEditingController notesController;

  late int pregnancyProfileId;

  var nickName = '';
  var notes = '';
  var errorString = ''.obs;
  var isLoading = false.obs;

  Rx<PregnancyProfileModel> pregnancyProfileModel = PregnancyProfileModel().obs;

  @override
  void onInit() {
    nickNameController = TextEditingController();
    notesController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    nickNameController.dispose();
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
}
