import 'dart:convert';
import 'dart:html';

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
      Map<String, dynamic> accountData) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .put(
          BuildServer.buildUrl("users/update"),
          headers: header,
          body: json.encode(accountData),
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> updateAvatar(Map<String, dynamic> data) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };

    response = await interceptedClient
        .post(
          BuildServer.buildUrl("users/update-avatar"),
          headers: header,
          body: json.encode(data),
        )
        .timeout(const Duration(seconds: 30));

    return response;
  }
}
