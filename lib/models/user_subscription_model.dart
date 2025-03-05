// To parse this JSON data, do
//
//     final userSubscriptionModel = userSubscriptionModelFromJson(jsonString);

import 'dart:convert';

List<UserSubscriptionModel> userSubscriptionModelFromJson(String str) =>
    List<UserSubscriptionModel>.from(
        json.decode(str).map((x) => UserSubscriptionModel.fromJson(x)));

String userSubscriptionModelToJson(List<UserSubscriptionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserSubscriptionModel {
  int? id;
  String? subscriptionPlanName;
  DateTime? startDate;
  DateTime? endDate;
  int? amount;
  String? subscriptionCode;
  String? bankCode;
  String? transactionNo;
  DateTime? paymentDate;
  String? status;
  DateTime? createdDate;

  UserSubscriptionModel({
    this.id,
    this.subscriptionPlanName,
    this.startDate,
    this.endDate,
    this.amount,
    this.subscriptionCode,
    this.bankCode,
    this.transactionNo,
    this.paymentDate,
    this.status,
    this.createdDate,
  });

  factory UserSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      UserSubscriptionModel(
        id: json["id"],
        subscriptionPlanName: json["subscriptionPlanName"] ?? "",
        startDate: json["startDate"] != null
            ? DateTime.parse(json["startDate"])
            : null,
        endDate:
            json["endDate"] != null ? DateTime.parse(json["endDate"]) : null,
        amount: json["amount"],
        subscriptionCode: json["subscriptionCode"] ?? "",
        bankCode: json["bankCode"] ?? "",
        transactionNo: json["transactionNo"] ?? "",
        paymentDate: json["paymentDate"] != null
            ? DateTime.parse(json["paymentDate"])
            : null,
        status: json["status"] ?? "",
        createdDate: json["createdDate"] != null
            ? DateTime.parse(json["createdDate"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subscriptionPlanName": subscriptionPlanName ?? "",
        "startDate": startDate?.toIso8601String() ?? "",
        "endDate": endDate?.toIso8601String() ?? "",
        "amount": amount,
        "subscriptionCode": subscriptionCode ?? "",
        "bankCode": bankCode ?? "",
        "transactionNo": transactionNo ?? "",
        "paymentDate": paymentDate?.toIso8601String() ?? "",
        "status": status ?? "",
        "createdDate": createdDate?.toIso8601String() ?? "",
      };
}
