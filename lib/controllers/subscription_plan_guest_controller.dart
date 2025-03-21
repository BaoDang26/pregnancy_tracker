import 'dart:convert';

import '../models/subscription_plan_model.dart';
import '../repositories/subscription_plan_repository.dart';
import '../util/app_export.dart';

class SubscriptionPlanGuestController extends GetxController {
  var isLoading = true.obs;
  var subscriptionPlanList = <SubscriptionPlanModel>[].obs;
  var subscriptionPlanModel = SubscriptionPlanModel().obs;

  // Biến theo dõi trang hiện tại
  var currentPage = 0.obs;

  @override
  Future<void> onInit() async {
    await getSubscriptionPlanGuestList();
    super.onInit();
  }

  Future<void> getSubscriptionPlanGuestList() async {
    isLoading.value = true;
    currentPage.value = 0; // Reset về trang đầu tiên khi load lại

    var response =
        await SubscriptionPlanRepository.getSubscriptionGuestPlanList();

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      List<SubscriptionPlanModel> allPlans =
          subscriptionPlanModelFromJson(jsonResult);

      // Lọc chỉ lấy các plan có status = "Active"
      subscriptionPlanList.value =
          allPlans.where((plan) => plan.status == 'Active').toList();
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }

  // Phương thức chuyển sang trang tiếp theo
  void nextPage() {
    int totalPlans = subscriptionPlanList.length;
    int plansPerPage = 3;
    int totalPages = (totalPlans / plansPerPage).ceil();

    if (currentPage.value < totalPages - 1) {
      currentPage.value++;
    }
  }

  // Phương thức quay lại trang trước
  void prevPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  void goToLogin() {
    Get.toNamed(AppRoutes.login);
  }

  void getBack() {
    Get.back();
  }
}
