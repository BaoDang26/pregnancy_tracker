import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import 'dart:html' as html;
import '../models/subscription_plan_model.dart';
import '../models/user_subscription_model.dart';
import '../repositories/subscription_plan_repository.dart';
import '../repositories/user_subscription_repository.dart';
import '../util/app_export.dart';

class SubscriptionPlanDetailsController extends GetxController {
  var isLoading = false.obs;
  var subscriptionPlan = SubscriptionPlanModel().obs;
  Rx<UserSubscriptionModel> userSubscriptionModel = UserSubscriptionModel().obs;

  @override
  void onInit() {
    // Nhận subscriptionPlanID từ Argument từ SubscriptionPlan screen
    int subscriptionPlanID = Get.arguments;

    getSubscriptionPlanByID(subscriptionPlanID);
    super.onInit();
  }

  Future<void> getSubscriptionPlanByID(int subscriptionPlanID) async {
    // gọi repository lấy thông tin subscription plan
    var response = await SubscriptionPlanRepository.getSubscriptionPlanDetail(
        subscriptionPlanID);
    if (response.statusCode == 200) {
      // chuyển dổi từ json sang subscriptionplan model
      String jsonResult = utf8.decode(response.bodyBytes);
      print("JSON Result: $jsonResult");

      subscriptionPlan.value =
          SubscriptionPlanModel.fromJson(json.decode(jsonResult));
    } else if (response.statusCode == 401) {
      String message = jsonDecode(response.body)['message'];
      if (message.contains("JWT token is expired")) {
        Get.snackbar('Session Expired', 'Please login again');
      }
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
  }

  Future<void> subscribesPlan() async {
    isLoading = true.obs;
    // Tạo UserSubscriptionModel
    Map<String, dynamic> userSubscriptionRequest = {
      "subscriptionPlanId": subscriptionPlan.value.id,
      "amount": subscriptionPlan.value.price
    };

    print('tesst subscribes');
    var response = await UserSubscriptionRepository.makePayment(
        json.encode(userSubscriptionRequest));

    // Log the response status and body
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      String jsonResult = utf8.decode(response.bodyBytes);
      // Log the JSON result
      print("JSON Result: $jsonResult");

      // get payment url
      String paymentUrl = jsonDecode(jsonResult)["paymentUrl"];
      Uri url = Uri.parse(paymentUrl); // Sử dụng url_launcher để mở URL
      if (await canLaunchUrl(url)) {
        await launchUrl(url, webOnlyWindowName: '_blank');
      } else {
        // Fallback cũng sử dụng '_blank' để mở tab mới
        html.window.open(paymentUrl, '_blank');
      }
    } else if (response.statusCode == 401) {
      String message = jsonDecode(response.body)['message'];
      if (message.contains("JWT token is expired")) {
        Get.snackbar('Session Expired', 'Please login again');
      }
    } else if (response.statusCode == 400) {
      String message = jsonDecode(response.body)['message'];

      // Kiểm tra nếu là thông báo "User already have an active subscription"
      if (message.contains("User already has an active subscription.")) {
        Get.dialog(
          AlertDialog(
            title: Text("Notification"),
            content: Text("You already have an active subscription."),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child:
                    Text("Close", style: TextStyle(color: Colors.green[700])),
              ),
            ],
          ),
        );
      } else {
        Get.snackbar("Error server ${response.statusCode}", message);
      }
    } else if (response.statusCode == 403) {
      // String message = jsonDecode(response.body)['message'];
      Get.snackbar('Already subscribed', 'You have already subscribed a plan');
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
    isLoading = false.obs;
  }
}
