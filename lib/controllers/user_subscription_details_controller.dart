import '../models/user_subscription_model.dart';
import '../util/app_export.dart';

class UserSubscriptionDetailsController extends GetxController {
  var isLoading = false.obs;
  Rx<UserSubscriptionModel> userSubscriptionModel = UserSubscriptionModel().obs;

  @override
  Future<void> onInit() async {
    userSubscriptionModel.value = Get.arguments;
    super.onInit();
  }

  // void goToFetalGrowthMeasurement() {
  //   Get.toNamed(AppRoutes.fetalgrowthmeasurement,
  //       arguments: pregnancyProfileModel.value.id);
  // }
}
