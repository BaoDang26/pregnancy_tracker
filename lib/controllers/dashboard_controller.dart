import 'dart:convert';

import '../models/dashboard_total_user_model.dart';
import '../models/dashboard_total_user_subscription_model.dart';
import '../repositories/dashboard_repository.dart';
import '../util/app_export.dart';

class DashboardController extends GetxController {
  var isLoading = true.obs;

  var dashboardTotalUser = DashboardTotalUserModel().obs;
  var dashboardTotalUserSubscription =
      DashboardTotalUserSubscriptionModel().obs;

  @override
  Future<void> onInit() async {
    await getDashboardTotalUser();
    await getDashboardTotalUserSubscription();
  }

  Future<void> getDashboardTotalUser() async {
    isLoading.value = true;
    var response = await DashboardRepository.getDashboardTotalUser();
    if (response.statusCode == 200) {
      dashboardTotalUser.value = dashboardTotalUserModelFromJson(response.body);
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }

  Future<void> getDashboardTotalUserSubscription() async {
    isLoading.value = true;
    var response =
        await DashboardRepository.getDashboardTotalUserSubscription();
    if (response.statusCode == 200) {
      dashboardTotalUserSubscription.value =
          dashboardTotalUserSubscriptionModelFromJson(response.body);
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }
}
