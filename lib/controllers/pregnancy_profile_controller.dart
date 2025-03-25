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
    await getPregnancyProfileList();

    super.onInit();
  }

  Future<void> getPregnancyProfileList() async {
    isLoading.value = true;
    var response = await PregnancyProfileRepository.getPregnancyProfileList();

    // Log the response status and body

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      // Log the JSON result
      List<PregnancyProfileModel> allPregnancyProfile =
          pregnancyProfileModelFromJson(jsonResult);

      // Lọc chỉ lấy các profile có status = "ACTIVE" (không phân biệt chữ hoa/thường)
      pregnancyProfileList.value = allPregnancyProfile
          .where((plan) => plan.status?.toUpperCase() == 'ACTIVE')
          .toList();
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }

  void goToPregnancyProfileDetail(int index) {
    // PrefUtils.setString('pregnancyId', pregnancyProfileList[index].id.toString());
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

  void goToUpdatePregnancyProfile(int index) {
    var profile = pregnancyProfileList[index];
    Get.toNamed(AppRoutes.updatepregnancyprofile,
        arguments: {'pregnancyId': profile.id});
    print("goToUpdatePregnancyProfile: ${profile.id}");
  }

  Future<void> deletePregnancyProfile(int index) async {
    isLoading.value = true;
    var profile = pregnancyProfileList[index];
    var response =
        await PregnancyProfileRepository.deletePregnancyProfile(profile.id!);
    if (response.statusCode == 200) {
      Get.snackbar("Success", "Pregnancy profile deleted successfully");
      await getPregnancyProfileList();
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
      print("Error server ${response.statusCode}");
      print("Error body ${response.body}");
    }
    isLoading.value = false;
    update();
  }
}
