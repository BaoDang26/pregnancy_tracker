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
  double? amount;
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
        subscriptionPlanName: json["subscriptionPlanName"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        amount: json["amount"],
        subscriptionCode: json["subscriptionCode"],
        bankCode: json["bankCode"],
        transactionNo: json["transactionNo"],
        paymentDate: DateTime.parse(json["paymentDate"]),
        status: json["status"],
        createdDate: DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subscriptionPlanName": subscriptionPlanName,
        "startDate":
            "${startDate?.year.toString().padLeft(4, '0')}-${startDate?.month.toString().padLeft(2, '0')}-${startDate?.day.toString().padLeft(2, '0')}",
        "endDate":
            "${endDate?.year.toString().padLeft(4, '0')}-${endDate?.month.toString().padLeft(2, '0')}-${endDate?.day.toString().padLeft(2, '0')}",
        "amount": amount,
        "subscriptionCode": subscriptionCode,
        "bankCode": bankCode,
        "transactionNo": transactionNo,
        "paymentDate": paymentDate?.toIso8601String(),
        "status": status,
        "createdDate": createdDate?.toIso8601String(),
      };
}
