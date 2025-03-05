import 'package:pregnancy_tracker/controllers/pregnancy_profile_controller.dart';

import '../controllers/home_screen_controller.dart';
import '../controllers/subscription_plan_controller.dart';
import '../util/app_export.dart';

class SideBarNavBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    // Khởi tạo các controller
    Get.lazyPut(() => PregnancyProfileController());
    Get.lazyPut(() => SubscriptionPlanController());
    Get.lazyPut(() => HomeScreenController());

    // Khởi tạo dịch vụ Firebase Messaging và đăng ký với GetX
    // final firebaseMessagingService = FirebaseMessagingService();
    // await firebaseMessagingService.init();
    // Get.put(firebaseMessagingService);
  }
}
