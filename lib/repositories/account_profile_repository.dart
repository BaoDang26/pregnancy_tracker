import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/build_server.dart';
import '../models/account_profile_model.dart';
import '../util/app_export.dart';

class AccountProfileRepository {
  static Future<http.Response> getAccountProfile() async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("users/info"),
          // body: body,
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> updateAccountProfile(
      Map<String, dynamic> accountData, int userId) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .put(
          BuildServer.buildUrl("users/update/$userId"),
          headers: header,
          body: json.encode(accountData),
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }
}
