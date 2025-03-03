import '../controllers/subscription_plan_details_controller.dart';
import '../util/app_export.dart';

class SubscriptionPlanDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SubscriptionPlanDetailsController());
  }
}
