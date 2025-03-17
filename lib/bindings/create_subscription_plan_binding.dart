import '../controllers/create_subscription_plan_controller.dart';
import '../util/app_export.dart';

class CreateSubscriptionPlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateSubscriptionPlanController());
  }
}
