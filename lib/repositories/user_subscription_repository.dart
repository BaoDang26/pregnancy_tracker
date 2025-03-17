import 'package:http/http.dart' as http;

import '../util/app_export.dart';

class UserSubscriptionRepository {
  static Future<http.Response> getAllUserSubscription() async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("user-subscription/all"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> getUserSubscriptionList() async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("user-subscription/user-subscriptions"),
          // body: body,
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> makePayment(var body) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .post(
          BuildServer.buildUrl("user-subscription/create"),
          body: body,
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> checkPaymentStatus(String txnRef) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl(
              "user-subscription/check-payment-status?subscriptionCode=$txnRef"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }
}
