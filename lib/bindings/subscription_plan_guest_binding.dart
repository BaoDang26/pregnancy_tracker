import '../controllers/subscription_plan_guest_controller.dart';
import '../util/app_export.dart';

class SubscriptionPlanGuestBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SubscriptionPlanGuestController());
  }
}
