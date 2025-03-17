// To parse this JSON data, do
//
//     final subscriptionPlanModel = subscriptionPlanModelFromJson(jsonString);

import 'dart:convert';

List<SubscriptionPlanModel> subscriptionPlanModelFromJson(String str) =>
    List<SubscriptionPlanModel>.from(
        json.decode(str).map((x) => SubscriptionPlanModel.fromJson(x)));

String subscriptionPlanModelToJson(List<SubscriptionPlanModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubscriptionPlanModel {
  int? id;
  String? name;
  double? price;
  int? duration;
  String? description;
  String? status;
  DateTime? createdDate;

  SubscriptionPlanModel({
    this.id,
    this.name,
    this.price,
    this.duration,
    this.description,
    this.status,
    this.createdDate,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlanModel(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        duration: json["duration"],
        description: json["description"],
        status: json["status"],
        createdDate: DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "duration": duration,
        "description": description,
        "status": status,
        "createdDate": createdDate?.toIso8601String(),
      };

  Map<String, dynamic> toCreateJson() => {
        "name": name,
        "price": price,
        "duration": duration,
        "description": description,
      };
}
