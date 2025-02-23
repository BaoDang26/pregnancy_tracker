import '../controllers/pregnancy_profile_details_controller.dart';
import '../util/app_export.dart';

class PregnancyProfileDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PregnancyProfileDetailsController());
  }
}
