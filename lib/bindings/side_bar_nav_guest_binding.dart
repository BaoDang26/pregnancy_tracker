import '../controllers/home_screen_guest_controller.dart';
import '../controllers/subscription_plan_guest_controller.dart';
import '../util/app_export.dart';

class SideBarNavGuestBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    // Khởi tạo các controller
    Get.lazyPut(() => SubscriptionPlanGuestController());
    Get.lazyPut(() => HomeScreenGuestController());

    // Khởi tạo dịch vụ Firebase Messaging và đăng ký với GetX
    // final firebaseMessagingService = FirebaseMessagingService();
    // await firebaseMessagingService.init();
    // Get.put(firebaseMessagingService);
  }
}
