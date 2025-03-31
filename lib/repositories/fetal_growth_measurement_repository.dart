import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pregnancy_tracker/models/fetal_growth_measurement_model.dart';

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

  static Future<http.Response> getFetalGrowthMeasurementById(
      int fetalGrowthMeasurementId) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("fetal-growth/$fetalGrowthMeasurementId"),
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

  static Future<http.Response> createFetalGrowthMeasurement(
      FetalGrowthMeasurementModel fetalGrowthMeasurementModel) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient.post(
        BuildServer.buildUrl("fetal-growth/create"),
        headers: header,
        body: json.encode(fetalGrowthMeasurementModel.toCreateJson()));

    return response;
  }

  static Future<http.Response> updateFetalGrowthMeasurement(
      FetalGrowthMeasurementModel fetalGrowthMeasurementModel) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient.put(
        BuildServer.buildUrl("fetal-growth/update"),
        headers: header,
        body: json.encode(fetalGrowthMeasurementModel.toUpdateJson()));

    return response;
  }

  static Future<http.Response> deleteFetalGrowthMeasurement(
      int fetalGrowthMeasurementId) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .delete(
          BuildServer.buildUrl("fetal-growth/$fetalGrowthMeasurementId"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }
}
