// To parse this JSON data, do
//
//     final accountProfileModel = accountProfileModelFromJson(jsonString);

import 'dart:convert';

AccountProfileModel accountProfileModelFromJson(String str) =>
    AccountProfileModel.fromJson(json.decode(str));

String accountProfileModelToJson(AccountProfileModel data) =>
    json.encode(data.toJson());

class AccountProfileModel {
  int? id;
  String? email;
  String? fullName;
  String? address;
  DateTime? dateOfBirth;
  String? avatarUrl;
  String? message;
  String? roleName;
  String? status;

  AccountProfileModel({
    this.id,
    this.email,
    this.fullName,
    this.address,
    this.dateOfBirth,
    this.avatarUrl,
    this.message,
    this.roleName,
    this.status,
  });

  factory AccountProfileModel.fromJson(Map<String, dynamic> json) =>
      AccountProfileModel(
        id: json["id"],
        email: json["email"],
        fullName: json["fullName"],
        address: json["address"],
        dateOfBirth: DateTime.parse(json["dateOfBirth"]),
        avatarUrl: json["avatarUrl"],
        message: json["message"],
        roleName: json["roleName"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "fullName": fullName,
        "address": address,
        "dateOfBirth":
            "${dateOfBirth?.year.toString().padLeft(4, '0')}-${dateOfBirth?.month.toString().padLeft(2, '0')}-${dateOfBirth?.day.toString().padLeft(2, '0')}",
        "avatarUrl": avatarUrl,
        "message": message,
        "roleName": roleName,
        "status": status,
      };

  Map<String, dynamic> toUpdateJson() => {
        "fullName": fullName,
        "address": address,
        "dateOfBirth":
            "${dateOfBirth?.year.toString().padLeft(4, '0')}-${dateOfBirth?.month.toString().padLeft(2, '0')}-${dateOfBirth?.day.toString().padLeft(2, '0')}",
        "avatarUrl": avatarUrl,
      };

  Map<String, dynamic> toUpdateAvatarJson() => {
        "message": message,
      };
}
