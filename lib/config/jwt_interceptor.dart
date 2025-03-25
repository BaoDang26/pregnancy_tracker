import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

import 'package:pregnancy_tracker/config/build_server.dart';
import 'package:pregnancy_tracker/config/jwt_service.dart';
import 'package:pregnancy_tracker/util/app_export.dart';
import 'dart:convert';

import '../repositories/authentication_repository.dart';

class JwtInterceptor implements InterceptorContract {
  final client = http.Client();

  final JwtService _jwtService = JwtService();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    String? accessToken = PrefUtils.getAccessToken();
    if (accessToken != null) {
      data.headers['Authorization'] = 'Bearer $accessToken';
    }
    data.headers['Content-Type'] = 'application/json; charset=utf-8';

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 401) {
      try {
        // gọi jwt service để lấy access token mới
        await _jwtService.refreshAccessToken();
        String? newAccessToken = PrefUtils.getAccessToken();
        if (newAccessToken != null) {
          // Retry the original request with the new access token
          return await retryRequest(data.request!, newAccessToken);
        }
      } catch (e) {
        print('Failed refresh token');
        logout();
      }
    } else if (data.statusCode == 403) {
      print('Account is not active');
      var errorData = jsonDecode(data.body!);
      if (errorData['message'] == 'User account is disabled') {
        logout();
      }
    }
    return data;
  }

  Future<void> checkLoginValidity() async {
    String? accessToken = PrefUtils.getAccessToken();
    if (accessToken != null) {
      try {
        // Perform a sample request to check if the token is valid
        final response = await http.get(
          BuildServer.buildUrl('auth/token/validity'),
          headers: {'Authorization': 'Bearer $accessToken'},
        );

        if (response.statusCode == 200) {
          // Token is valid, navigate to home screen
          Get.offAllNamed(AppRoutes.sidebarnar);
        } else {
          // Token is invalid or expired, clear tokens and navigate to login screen
          Get.offAllNamed(AppRoutes.sidebarnarguest);
        }
      } catch (e) {
        // Handle network errors or other exceptions
        logout();
      }
    } else {
      // No token found, navigate to login screen
      logout();
    }
  }

  Future<ResponseData> retryRequest(
      RequestData requestData, String accessToken) async {
    // Convert Method to String
    String method = _methodToString(requestData.method);

    // Convert URL String to Uri
    Uri url = Uri.parse(requestData.url);

    // Build the new request
    final newRequest = http.Request(method, url)
      ..headers.addAll(requestData.headers)
      ..headers['Authorization'] = 'Bearer $accessToken';

    // Convert body to bytes if it exists
    if (requestData.body != null) {
      newRequest.bodyBytes = utf8.encode(requestData.body!);
    }

    // Add body if it's a PUT or POST request
    if (method == 'PUT' || method == 'POST') {
      if (requestData.body != null) {
        newRequest.bodyBytes = requestData.body!;
      }
    }

    // Send the new request
    final streamResponse = await client.send(newRequest);
    final http.Response response =
        await http.Response.fromStream(streamResponse);

    return ResponseData.fromHttpResponse(response);
  }

  Future<void> logout() async {
    // Alert.showLoadingIndicatorDialog(context);
    // var firebaseMessagingService = Get.find<FirebaseMessagingService>();
    // await firebaseMessagingService.deleteToken();
    await AuthenticationRepository.logout();
    PrefUtils.clearPreferencesData();
    Get.offAllNamed(AppRoutes.sidebarnarguest);
  }

  String _methodToString(Method method) {
    switch (method) {
      case Method.GET:
        return 'GET';
      case Method.POST:
        return 'POST';
      case Method.PUT:
        return 'PUT';
      case Method.DELETE:
        return 'DELETE';
      case Method.PATCH:
        return 'PATCH';
      case Method.HEAD:
        return 'HEAD';
      default:
        return 'GET';
    }
  }
}

final jwtInterceptor = JwtInterceptor();
final interceptedClient =
    InterceptedClient.build(interceptors: [jwtInterceptor]);
