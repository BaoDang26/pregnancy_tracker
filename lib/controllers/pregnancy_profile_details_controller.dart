import 'package:pregnancy_tracker/models/pregnancy_profile_model.dart';

import '../models/fetal_growth_measurement_model.dart';
import '../util/app_export.dart';

class PregnancyProfileDetailsController extends GetxController {
  var isLoading = false.obs;
  Rx<PregnancyProfileModel> pregnancyProfileModel = PregnancyProfileModel().obs;

  @override
  Future<void> onInit() async {
    pregnancyProfileModel.value = Get.arguments;
    super.onInit();
  }

  void goToFetalGrowthMeasurement() {
    Get.toNamed(AppRoutes.fetalgrowthmeasurement,
        arguments: pregnancyProfileModel.value.id);
  }
}
