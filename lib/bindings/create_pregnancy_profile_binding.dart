import 'package:get/get.dart';

import '../controllers/create_pregnancy_profile_controller.dart';

class CreatePregnancyProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreatePregnancyProfileController());
  }
}
