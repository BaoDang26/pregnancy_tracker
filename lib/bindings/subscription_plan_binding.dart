import '../controllers/subscription_plan_controller.dart';
import '../util/app_export.dart';

class SubscriptionPlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SubscriptionPlanController());
  }
}
