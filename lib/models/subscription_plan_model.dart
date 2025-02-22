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
  int? price;
  int? duration;
  String? description;
  bool? isActive;
  DateTime? createdDate;

  SubscriptionPlanModel({
    this.id,
    this.name,
    this.price,
    this.duration,
    this.description,
    this.isActive,
    this.createdDate,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlanModel(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        duration: json["duration"],
        description: json["description"],
        isActive: json["isActive"],
        createdDate: DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "duration": duration,
        "description": description,
        "isActive": isActive,
        "createdDate": createdDate?.toIso8601String(),
      };
}
