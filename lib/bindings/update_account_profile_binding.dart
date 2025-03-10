import 'package:get/get.dart';

import '../controllers/update_account_profile_controller.dart';

class UpdateAccountProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UpdateAccountProfileController());
  }
}
