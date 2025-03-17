import '../controllers/manage_subscription_plan_controller.dart';
import '../controllers/manage_user_controller.dart';
import 'package:get/get.dart';

import '../controllers/manage_user_subscription_controller.dart';

class SideBarNavAdminBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    // Khởi tạo các controller
    Get.lazyPut(() => ManageUserController());
    Get.lazyPut(() => ManageSubscriptionPlanController());
    Get.lazyPut(() => ManageUserSubscriptionController());

    // Khởi tạo dịch vụ Firebase Messaging và đăng ký với GetX
    // final firebaseMessagingService = FirebaseMessagingService();
    // await firebaseMessagingService.init();
    // Get.put(firebaseMessagingService);
  }
}
