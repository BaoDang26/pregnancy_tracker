import 'package:http/http.dart' as http;

import '../util/app_export.dart';

class DashboardRepository {
  static Future<http.Response> getDashboardTotalUser() async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };

    response = await interceptedClient.get(
      BuildServer.buildUrl("admin/dashboard/total-users"),
      headers: header,
    );

    return response;
  }

  static Future<http.Response> getDashboardTotalUserSubscription() async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };

    response = await interceptedClient.get(
      BuildServer.buildUrl("admin/dashboard/total-user-subscriptions"),
      headers: header,
    );

    return response;
  }
}
