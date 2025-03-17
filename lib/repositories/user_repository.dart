import 'dart:convert';
import 'dart:html';

import 'package:http/http.dart' as http;

import '../config/build_server.dart';
import '../util/app_export.dart';

class UserRepository {
  static Future<http.Response> getAllUser() async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("users"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> getUserById(int id) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("users/$id"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> updateStatusUser(int id) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .put(
          BuildServer.buildUrl("users/$id/toggle-status"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }
}
