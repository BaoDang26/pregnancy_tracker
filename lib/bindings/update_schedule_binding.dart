import '../controllers/update_schedule_controller.dart';
import '../util/app_export.dart';

class UpdateScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateScheduleController());
  }
}
