import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/build_server.dart';
import '../config/jwt_interceptor.dart';
import '../models/pregnancy_profile_model.dart';

class PregnancyProfileRepository {
  static Future<http.Response> getPregnancyProfileList() async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("pregnancy-profiles/user-get-all"),
          // body: body,
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> getPregnancyProfileById(
      int pregnancyProfileId) async {
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    var response = await interceptedClient.get(
        BuildServer.buildUrl("pregnancy-profiles/$pregnancyProfileId"),
        headers: header);
    return response;
  }

  static Future<http.Response> createPregnancyProfile(
      PregnancyProfileModel pregnancyProfileModel) async {
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    var response = await interceptedClient.post(
        BuildServer.buildUrl("pregnancy-profiles/create"),
        headers: header,
        body: json.encode(pregnancyProfileModel.toCreateJson()));
    return response;
  }

  static Future<http.Response> updatePregnancyProfile(
      PregnancyProfileModel pregnancyProfileModel) async {
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    var response = await interceptedClient.put(
        BuildServer.buildUrl("pregnancy-profiles/update"),
        headers: header,
        body: json.encode(pregnancyProfileModel.toUpdateJson()));
    return response;
  }

  static Future<http.Response> deletePregnancyProfile(
      int pregnancyProfileId) async {
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    var response = await interceptedClient.delete(
        BuildServer.buildUrl("pregnancy-profiles/$pregnancyProfileId"),
        headers: header);
    return response;
  }
}
