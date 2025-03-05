import '../controllers/update_fetal_growth_measurement_controller.dart';
import '../util/app_export.dart';

class UpdateFetalGrowthMeasurementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateFetalGrowthMeasurementController());
  }
}
