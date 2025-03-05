import '../controllers/create_schedule_controller.dart';
import '../util/app_export.dart';

class CreateScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateScheduleController());
  }
}
