import 'package:pregnancy_tracker/controllers/user_subscription_details_controller.dart';

import '../util/app_export.dart';

class UserSubscriptionDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserSubscriptionDetailsController());
  }
}
