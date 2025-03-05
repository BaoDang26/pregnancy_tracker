import '../controllers/create_fetal_growth_measurement_controller.dart';
import '../util/app_export.dart';

class CreateFetalGrowthMeasurementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateFetalGrowthMeasurementController());
  }
}
