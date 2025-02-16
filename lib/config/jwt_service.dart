import 'package:http/http.dart' as http;
import 'dart:convert';

import '../util/app_export.dart';
import 'build_server.dart';

class JwtService {
  static final JwtService _instance = JwtService._internal();

  factory JwtService() => _instance;

  JwtService._internal();

  Future<void> refreshAccessToken() async {
    final client = http.Client();

    String? refreshToken = PrefUtils.getRefreshToken();
    if (refreshToken == null) {
      throw Exception("Refresh token is null");
    }
    var response = await client
        .post(
          BuildServer.buildUrl("auth/refreshtoken"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': refreshToken}),
        )
        .timeout(const Duration(seconds: 30));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String newAccessToken = data['accessToken'];
      String newRefreshToken = data['refreshToken'];
      await PrefUtils.setAccessToken(newAccessToken);
      await PrefUtils.setRefreshToken(newRefreshToken);
    } else {
      throw Exception("Failed to refresh token");
    }
  }
}
