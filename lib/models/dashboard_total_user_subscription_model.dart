// To parse this JSON data, do
//
//     final dashboardTotalUserSubscriptionModel = dashboardTotalUserSubscriptionModelFromJson(jsonString);

import 'dart:convert';

DashboardTotalUserSubscriptionModel dashboardTotalUserSubscriptionModelFromJson(
        String str) =>
    DashboardTotalUserSubscriptionModel.fromJson(json.decode(str));

String dashboardTotalUserSubscriptionModelToJson(
        DashboardTotalUserSubscriptionModel data) =>
    json.encode(data.toJson());

class DashboardTotalUserSubscriptionModel {
  int? totalSubscriptions;

  DashboardTotalUserSubscriptionModel({
    this.totalSubscriptions,
  });

  factory DashboardTotalUserSubscriptionModel.fromJson(
          Map<String, dynamic> json) =>
      DashboardTotalUserSubscriptionModel(
        totalSubscriptions: json["totalSubscriptions"],
      );

  Map<String, dynamic> toJson() => {
        "totalSubscriptions": totalSubscriptions,
      };
}
