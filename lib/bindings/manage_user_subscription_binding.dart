import 'package:get/get.dart';

import '../controllers/manage_user_subscription_controller.dart';

class ManageUserSubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ManageUserSubscriptionController());
  }
}
