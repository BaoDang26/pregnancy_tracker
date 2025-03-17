// To parse this JSON data, do
//
//     final dashboardTotalUserModel = dashboardTotalUserModelFromJson(jsonString);

import 'dart:convert';

DashboardTotalUserModel dashboardTotalUserModelFromJson(String str) =>
    DashboardTotalUserModel.fromJson(json.decode(str));

String dashboardTotalUserModelToJson(DashboardTotalUserModel data) =>
    json.encode(data.toJson());

class DashboardTotalUserModel {
  int? totalUsers;
  int? premiumUsers;
  int? regularUsers;

  DashboardTotalUserModel({
    this.totalUsers,
    this.premiumUsers,
    this.regularUsers,
  });

  factory DashboardTotalUserModel.fromJson(Map<String, dynamic> json) =>
      DashboardTotalUserModel(
        totalUsers: json["totalUsers"],
        premiumUsers: json["premiumUsers"],
        regularUsers: json["regularUsers"],
      );

  Map<String, dynamic> toJson() => {
        "totalUsers": totalUsers,
        "premiumUsers": premiumUsers,
        "regularUsers": regularUsers,
      };
}
