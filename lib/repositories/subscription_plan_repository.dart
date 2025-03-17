import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/build_server.dart';
import '../models/subscription_plan_model.dart';
import '../util/app_export.dart';

class SubscriptionPlanRepository {
  static Future<http.Response> getSubscriptionPlanList() async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("subscription-plans/all"),
          // body: body,
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> getSubscriptionGuestPlanList() async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("guest/subscription-plans/all"),
          // body: body,
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> getSubscriptionPlanDetail(int id) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("subscription-plans/$id"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> createSubscriptionPlan(
      SubscriptionPlanModel subscriptionPlanModel) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .post(
          BuildServer.buildUrl("subscription-plans/create"),
          body: json.encode(subscriptionPlanModel.toCreateJson()),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> updateSubscriptionPlan(
      int planId, SubscriptionPlanModel subscriptionPlanModel) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .put(
          BuildServer.buildUrl("subscription-plans/$planId"),
          body: json.encode(subscriptionPlanModel.toUpdateJson()),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> deactivateSubscriptionPlan(int planId) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .put(
          BuildServer.buildUrl("subscription-plans/$planId/toggle-status"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }
}
