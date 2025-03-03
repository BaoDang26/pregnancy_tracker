import 'dart:async';

import 'package:http/http.dart' as http;

import '../config/build_server.dart';
import '../util/app_export.dart';

class SubscriptionPlanRepository {
  static Future<http.Response> getSubscriptionPlanList() async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("subscription-plans/all"),
          // body: body,
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> getSubscriptionPlanDetail(int id) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("subscription-plans/$id"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }
}
