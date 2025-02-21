// To parse this JSON data, do
//
//     final accountModel = accountModelFromJson(jsonString);

import 'dart:convert';

import '../util/app_export.dart';

AccountModel accountModelFromJson(String str) =>
    AccountModel.fromJson(json.decode(str));

String accountModelToJson(AccountModel data) => json.encode(data.toJson());

class AccountModel {
  int? userId;
  String? email;
  String? password;
  String? accountPhoto;
  String? fullName;
  DateTime? dateOfBirth;

  AccountModel({
    this.userId,
    this.email,
    this.password,
    this.accountPhoto,
    this.fullName,
    this.dateOfBirth,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        userId: json["userID"],
        email: json["email"],
        password: json["password"],
        accountPhoto: json["accountPhoto"] ??
            "https://res.cloudinary.com/dlipvbdwi/image/upload/v1700192116/avatar_snfpmg.jpg",
        fullName: json["fullName"],
        dateOfBirth: DateTimeExtension.parseWithFormat(json["dateOfBirth"],
            format: "yyyy-MM-dd"),
      );

  Map<String, dynamic> toJson() => {
        "userID": userId,
        "email": email,
        "password": password,
        "accountPhoto": accountPhoto,
        "fullName": fullName,
        "dateOfBirth":
            "${dateOfBirth?.year.toString().padLeft(4, '0')}-${dateOfBirth?.month.toString().padLeft(2, '0')}-${dateOfBirth?.day.toString().padLeft(2, '0')}",
      };
}
