import 'dart:async';
import 'dart:convert';

import 'package:pregnancy_tracker/controllers/manage_user_controller.dart';
import 'package:pregnancy_tracker/controllers/manage_user_subscription_controller.dart';

import '../models/dashboard_total_user_model.dart';
import '../models/dashboard_total_user_subscription_model.dart';
import '../repositories/dashboard_repository.dart';
import '../util/app_export.dart';

class DashboardController extends GetxController {
  var isLoading = true.obs;

  var dashboardTotalUser = DashboardTotalUserModel().obs;
  var dashboardTotalUserSubscription =
      DashboardTotalUserSubscriptionModel().obs;
  Timer? _timer;

  @override
  Future<void> onInit() async {
    // Khởi tạo timer để gọi các controller định kỳ
    // _startPeriodicFetch();
    await getDashboardTotalUser();
    await getDashboardTotalUserSubscription();
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
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().getDashboardTotalUser();
    }

    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().getDashboardTotalUserSubscription();
    }

    if (Get.isRegistered<ManageUserController>()) {
      Get.find<ManageUserController>().getListUser();
    }

    if (Get.isRegistered<ManageUserSubscriptionController>()) {
      Get.find<ManageUserSubscriptionController>().getAllUserSubscription();
    }

    // Thêm các controller khác nếu cần

    // Cập nhật UI nếu cần
    update();
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
