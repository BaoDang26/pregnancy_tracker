import 'dart:async';

import 'package:http/http.dart' as http;

import '../config/build_server.dart';

class FetalGrowthMeasurementRepository {
  static final client = http.Client();

  static Future<http.Response> getFetalGrowthMeasurementList(
      int pregnancyId) async {
    http.Response response;

    Map<String, String> header = {
      "accept": "*/*",
    };
    response = await client
        .get(
          BuildServer.buildUrl("fetal-growth/pregnancy/$pregnancyId"),
          // body: body,
          // headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }
}
