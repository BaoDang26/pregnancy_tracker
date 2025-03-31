import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pregnancy_tracker/models/schedule_model.dart';
import 'dart:async';

import '../util/app_export.dart';

class ScheduleRepository {
  static Future<http.Response> getScheduleList(int pregnancyId) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("schedules/by-pregnancy-profile/$pregnancyId"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> getScheduleById(int scheduleId) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("schedules/$scheduleId"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> createSchedule(
      ScheduleModel scheduleModel) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .post(
          BuildServer.buildUrl("schedules/create"),
          headers: header,
          body: json.encode(scheduleModel.toCreateJson()),
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> updateSchedule(
      Map<String, dynamic> scheduleData, int scheduleId) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .put(
          BuildServer.buildUrl("schedules/update/$scheduleId"),
          headers: header,
          body: json.encode(scheduleData),
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> deleteSchedule(int scheduleId) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .put(
          BuildServer.buildUrl("schedules/$scheduleId/toggle-status"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }
}
