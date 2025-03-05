import '../controllers/schedule_controller.dart';
import '../util/app_export.dart';

class ScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScheduleController());
  }
}
