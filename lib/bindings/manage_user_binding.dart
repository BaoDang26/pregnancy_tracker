import 'package:get/get.dart';

import '../controllers/manage_user_controller.dart';

class ManageUserBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    Get.lazyPut(() => ManageUserController());
  }
}
