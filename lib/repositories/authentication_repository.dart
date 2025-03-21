import 'dart:async';

import 'package:http/http.dart' as http;

import '../config/build_server.dart';
import '../config/jwt_interceptor.dart';

class AuthenticationRepository {
  static final client = http.Client();

  static Future<http.Response> postLogin(var body) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient.post(
      BuildServer.buildUrl("auth/login"),
      body: body,
      headers: header,
    );
    return response;
  }

  static Future<http.Response> postRegister(var body) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient.post(
      BuildServer.buildUrl("auth/register"),
      body: body,
      headers: header,
    );
    return response;
  }

  static Future<http.Response> changePassword(var body) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient.put(
      BuildServer.buildUrl("auth/change-password"),
      body: body,
      headers: header,
    );
    return response;
  }

  static Future<http.Response> forgotPassword(String email) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient.post(
      BuildServer.buildUrl("auth/forgot-password?email=$email"),
      headers: header,
    );
    return response;
  }

  static Future<String> logout() async {
    try {
      Map<String, String> header = {
        "Content-type": "application/json",
      };
      var response = await interceptedClient
          .post(
            BuildServer.buildUrl("auth/logout"),
            headers: header,
          )
          .timeout(const Duration(seconds: 30));
      return response.body;
    } on TimeoutException catch (e) {
      return e.toString();
    }
  }
}
