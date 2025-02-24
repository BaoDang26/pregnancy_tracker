import '../controllers/user_subscription_controller.dart';
import '../util/app_export.dart';

class UserSubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserSubscriptionController());
  }
}
