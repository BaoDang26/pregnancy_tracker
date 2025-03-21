import 'dart:convert';
import 'dart:async';

import 'package:get/get.dart';
import 'package:pregnancy_tracker/controllers/community_post_controller.dart';
import 'package:pregnancy_tracker/controllers/pregnancy_profile_controller.dart';
import 'package:pregnancy_tracker/controllers/subscription_plan_controller.dart';

import '../models/subscription_plan_model.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/subscription_plan_repository.dart';
import '../routes/app_routes.dart';
import '../util/app_export.dart';

class HomeScreenController extends GetxController {
  var isLoading = false.obs;
  var subscriptionPlanList = <SubscriptionPlanModel>[].obs;
  var subscriptionPlanModel = SubscriptionPlanModel().obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Khởi tạo timer để gọi các controller định kỳ
    // _startPeriodicFetch();
    getSubscriptionPlanList();
  }

  @override
  void onClose() {
    // Hủy timer khi controller bị hủy
    // _timer?.cancel();
    super.onClose();
  }

  void _startPeriodicFetch() {
    // Thiết lập timer gọi mỗi 5 giây
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // Gọi các controller bạn muốn refresh
      _refreshControllers();
    });
  }

  void _refreshControllers() {
    // Lấy các controller từ GetX và gọi các phương thức cần thiết
    if (Get.isRegistered<PregnancyProfileController>()) {
      Get.find<PregnancyProfileController>().getPregnancyProfileList();
    }

    if (Get.isRegistered<CommunityPostController>()) {
      Get.find<CommunityPostController>().getCommunityPostList();
    }

    if (Get.isRegistered<SubscriptionPlanController>()) {
      Get.find<SubscriptionPlanController>().getActiveSubscriptionPlanList();
    }

    // Thêm các controller khác nếu cần

    // Cập nhật UI nếu cần
    update();
  }

  Future<void> getSubscriptionPlanList() async {
    isLoading.value = true;
    var response = await SubscriptionPlanRepository.getSubscriptionPlanList();

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      // Log the JSON result
      print("JSON Result: $jsonResult");

      // Convert JSON to model
      subscriptionPlanList.value = subscriptionPlanModelFromJson(jsonResult);
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }

  void goToSubscriptionPlanDetail(int index) {
    Get.toNamed(AppRoutes.subscriptionplandetail,
        arguments: subscriptionPlanList[index].id);
  }

  void getBack() {
    Get.back();
  }

  Future<void> logout() async {
    // Alert.showLoadingIndicatorDialog(context);
    await AuthenticationRepository.logout();
    PrefUtils.clearPreferencesData();

    Get.offAllNamed(AppRoutes.login);
  }
}
