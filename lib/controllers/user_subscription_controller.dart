import 'dart:convert';

import 'package:get/get.dart';

import '../models/user_subscription_model.dart';
import '../repositories/user_subscription_repository.dart';

class UserSubscriptionController extends GetxController {
  var isLoading = true.obs;
  var userSubscriptionList = <UserSubscriptionModel>[].obs;
  var userSubscriptionModel = UserSubscriptionModel().obs;

  @override
  Future<void> onInit() async {
    await getUserSubscriptionList();
    super.onInit();
  }

  Future<void> getUserSubscriptionList() async {
    isLoading.value = true;
    var response = await UserSubscriptionRepository.getUserSubscriptionList();

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      // Log the JSON result
      print("JSON Result: $jsonResult");
      //convert json to model
      userSubscriptionList.value = userSubscriptionModelFromJson(jsonResult);
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading.value = false;
    update();
  }

  // void goToUserSubscriptionDetail(int index) {
  //   Get.toNamed(AppRoutes.userSubscriptionDetail,
  //       arguments: userSubscriptionList[index]);
  // }

  void getBack() {
    Get.back();
  }
}
