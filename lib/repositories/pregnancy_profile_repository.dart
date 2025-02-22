import 'dart:async';

import 'package:http/http.dart' as http;

import '../config/build_server.dart';

class PregnancyProfileRepository {
  static final client = http.Client();

  static Future<http.Response> getPregnancyProfileList() async {
    http.Response response;

    Map<String, String> header = {
      "accept": "*/*",
    };
    response = await client
        .get(
          BuildServer.buildUrl("pregnancy-profiles/user-get-all"),
          // body: body,
          // headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }
}
