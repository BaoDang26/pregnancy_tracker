import 'dart:convert';

import 'package:get/get.dart';

import '../models/subscription_plan_model.dart';
import '../repositories/subscription_plan_repository.dart';
import '../routes/app_routes.dart';
import '../util/preUtils.dart';

class HomeScreenGuestController extends GetxController {
  var isLoading = false.obs;
  var subscriptionPlanList = <SubscriptionPlanModel>[].obs;
  var subscriptionPlanModel = SubscriptionPlanModel().obs;
  @override
  Future<void> onInit() async {
    await getSubscriptionPlanGuestList();
    goToSideBarNavOrSideBarNavAdmin();
    super.onInit();
  }

  void goToSideBarNavOrSideBarNavAdmin() {
    if (PrefUtils.getAccessToken() != null) {
      // Lấy role người dùng từ SharedPreferences
      String? userRole = PrefUtils.getUserRole();

      // Kiểm tra role và điều hướng tương ứng
      if (userRole?.toUpperCase() == "ROLE_ADMIN") {
        // Nếu là admin thì vào giao diện admin
        Get.offAllNamed(AppRoutes.sidebarnaradmin);
      } else {
        // Nếu là user thường hoặc user premium thì vào giao diện user
        Get.offAllNamed(AppRoutes.sidebarnar);
      }
      return;
    }
    // Không có token, user chưa đăng nhập nên ở lại màn hình hiện tại
  }

  Future<void> getSubscriptionPlanGuestList() async {
    isLoading.value = true;
    var response =
        await SubscriptionPlanRepository.getSubscriptionGuestPlanList();

    // Log the response status and body

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      // Log the JSON result

      // Convert JSON to model
      subscriptionPlanList.value = subscriptionPlanModelFromJson(jsonResult);
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }

  void goToLogin() {
    Get.toNamed(AppRoutes.login);
  }

  void getBack() {
    Get.back();
  }
}
