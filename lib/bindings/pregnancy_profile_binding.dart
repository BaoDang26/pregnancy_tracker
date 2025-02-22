import '../controllers/pregnancy_profile_controller.dart';
import '../util/app_export.dart';

class PregnancyProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PregnancyProfileController());
  }
}
