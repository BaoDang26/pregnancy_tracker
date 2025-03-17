import 'package:get/get.dart';
import 'package:pregnancy_tracker/controllers/update_pregnancy_profile_controller.dart';

class UpdatePregnancyProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UpdatePregnancyProfileController());
  }
}
