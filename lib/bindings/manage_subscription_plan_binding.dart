import '../controllers/manage_subscription_plan_controller.dart';
import '../util/app_export.dart';

class ManageSubscriptionPlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ManageSubscriptionPlanController());
  }
}
