import 'dart:convert';

import 'package:pregnancy_tracker/repositories/user_subscription_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import 'dart:html' as html;
import '../models/user_subscription_model.dart';
import '../util/app_export.dart';

class UserSubscriptionDetailsController extends GetxController {
  var isLoading = false.obs;
  Rx<UserSubscriptionModel> userSubscriptionModel = UserSubscriptionModel().obs;

  @override
  Future<void> onInit() async {
    print('UserSubscriptionDetailsController init');
    // userSubscriptionModel.value = Get.arguments;
    super.onInit();
  }

  Future<void> subscribesPlan() async {
    Map<String, String> userSubscriptionRequest = {
      "subscriptionPlanId": "2",
      "amount": "50000"
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
        await launchUrl(url,webOnlyWindowName: '_self');
      } else {
        // Fallback sử dụng window.open
        html.window.open(paymentUrl, '_self');
      }
    } else {
      Get.snackbar("Error server ${response.statusCode}",
          jsonDecode(response.body)['message']);
    }
  }

// void goToFetalGrowthMeasurement() {
//   Get.toNamed(AppRoutes.fetalgrowthmeasurement,
//       arguments: pregnancyProfileModel.value.id);
// }
}
