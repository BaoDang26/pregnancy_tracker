import 'dart:async';

import 'package:http/http.dart' as http;

import '../config/build_server.dart';
import '../util/app_export.dart';

class FetalGrowthMeasurementRepository {
  static Future<http.Response> getFetalGrowthMeasurementList(
      int pregnancyId) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("fetal-growth/pregnancy/$pregnancyId"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> getWeightFetalGrowthMeasurementList(
      int pregnancyId) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("fetal-growth/weight-summary/$pregnancyId"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> getHeightFetalGrowthMeasurementList(
      int pregnancyId) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("fetal-growth/height-summary/$pregnancyId"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }
}
