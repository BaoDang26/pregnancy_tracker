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
  String? accountPhoto;
  String? avatarUrl;

  AccountProfileModel({
    this.id,
    this.email,
    this.fullName,
    this.address,
    this.dateOfBirth,
    this.accountPhoto,
    this.avatarUrl,
  });

  factory AccountProfileModel.fromJson(Map<String, dynamic> json) =>
      AccountProfileModel(
        id: json["id"],
        email: json["email"],
        fullName: json["fullName"],
        address: json["address"],
        dateOfBirth: DateTime.parse(json["dateOfBirth"]),
        accountPhoto: json["accountPhoto"],
        avatarUrl: json["avatarUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "fullName": fullName,
        "address": address,
        "dateOfBirth":
            "${dateOfBirth?.year.toString().padLeft(4, '0')}-${dateOfBirth?.month.toString().padLeft(2, '0')}-${dateOfBirth?.day.toString().padLeft(2, '0')}",
        "accountPhoto": accountPhoto,
        "avatarUrl": avatarUrl,
      };

  Map<String, dynamic> toUpdateJson() => {
        "fullName": fullName,
        "address": address,
        "dateOfBirth":
            "${dateOfBirth?.year.toString().padLeft(4, '0')}-${dateOfBirth?.month.toString().padLeft(2, '0')}-${dateOfBirth?.day.toString().padLeft(2, '0')}",
        "avatarUrl": avatarUrl,
      };
}
