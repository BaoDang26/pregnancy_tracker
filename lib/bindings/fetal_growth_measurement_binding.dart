import 'package:get/get.dart';

import '../controllers/fetal_growth_measurement_controller.dart';

class FetalGrowthMeasurementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FetalGrowthMeasurementController());
  }
}
