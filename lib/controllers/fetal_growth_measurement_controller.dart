import 'dart:convert';

import '../models/fetal_growth_measurement.dart';
import '../repositories/fetal_growth_measurement_repository.dart';
import '../util/app_export.dart';

class FetalGrowthMeasurementController extends GetxController {
  var isLoading = true.obs;
  var fetalGrowthMeasurementList = <FetalGrowthMeasurementModel>[].obs;
  var fetalGrowthMeasurementModel = FetalGrowthMeasurementModel().obs;
  int? pregnancyId;

  @override
  Future<void> onInit() async {
    await getFetalGrowthMeasurementList(pregnancyId!);
    super.onInit();
  }

  Future<void> getFetalGrowthMeasurementList(int pregnancyId) async {
    isLoading.value = true;
    var response =
        await FetalGrowthMeasurementRepository.getFetalGrowthMeasurementList(
            pregnancyId);
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      fetalGrowthMeasurementList.value =
          fetalGrowthMeasurementModelFromJson(response.body);
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }

  void getBack() {
    Get.back();
  }
}
