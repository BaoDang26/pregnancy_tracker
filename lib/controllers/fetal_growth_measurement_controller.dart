import 'dart:convert';

import '../models/fetal_growth_measurement_model.dart';
import '../models/pregnancy_profile_model.dart';
import '../repositories/fetal_growth_measurement_repository.dart';
import '../util/app_export.dart';

class FetalGrowthMeasurementController extends GetxController {
  RxList<FetalGrowthMeasurementModel> fetalGrowthMeasurementModel =
      RxList.empty();

  Rx<PregnancyProfileModel> pregnancyProfileModel = PregnancyProfileModel().obs;

  // RxString goalWeight = "0".obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    fetchFetalGrowthMeasurementData();
    super.onInit();
  }

  Future<void> fetchFetalGrowthMeasurementData() async {
    isLoading.value = true;
    int pregnancyId = Get.arguments;
    // int id = Get.arguments;
    // int pregnancyId = pregnancyProfileModel.value.id!;
    DateTime date = DateTime.now();
    await getFetalGrowthMeasurement(pregnancyId);
    isLoading.value = false;
  }

  Future<void> getFetalGrowthMeasurement(int pregnancyId) async {
    // gọi API deactivate workout
    var response =
        await FetalGrowthMeasurementRepository.getFetalGrowthMeasurementList(
            pregnancyId);
    // kiểm tra kết quả
    print('response:${response.statusCode}');
    print('response:${response.body}');
    if (response.statusCode == 200) {
      fetalGrowthMeasurementModel.value =
          fetalGrowthMeasurementModelFromJson(response.body);
      // fetalGrowthMeasurementModel.sort(
      //   (a, b) => a.measurementDate!.compareTo(b.measurementDate!),
      // );
    } else if (response.statusCode == 401) {
      String message = jsonDecode(response.body)['message'];
      if (message.contains("JWT token is expired")) {
        Get.snackbar('Session Expired', 'Please login again');
      }
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
  }
}
