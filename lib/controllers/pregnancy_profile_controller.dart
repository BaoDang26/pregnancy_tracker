import 'dart:convert';

import 'package:get/get.dart';
import 'package:pregnancy_tracker/repositories/pregnancy_profile_repository.dart';

import '../models/pregnancy_profile_model.dart';
import '../routes/app_routes.dart';

class PregnancyProfileController extends GetxController {
  var isLoading = true.obs;
  var pregnancyProfileList = <PregnancyProfileModel>[].obs;
  var pregnancyProfileModel = PregnancyProfileModel().obs;

  @override
  Future<void> onInit() async {
    // Nhận advisor ID từ Argument từ Advisor screen

    await getPregnancyProfileList();

    super.onInit();
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

  void goToPregnancyProfileDetail(int index) {
    Get.toNamed(AppRoutes.pregnancyprofiledetails,
        arguments: pregnancyProfileList[index]);
  }

  void goToCreatePregnancyProfile() {
    Get.toNamed(AppRoutes.createpregnancyprofile)?.then((value) => {
          if (value != null && value) {getPregnancyProfileList()}
        });
  }

  void getBack() {
    Get.back();
  }
}
