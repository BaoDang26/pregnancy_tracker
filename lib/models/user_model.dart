// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  int? id;
  String? email;
  String? fullName;
  String? address;
  DateTime? dateOfBirth;
  String? avatarUrl;
  String? roleName;
  String? status;

  UserModel({
    this.id,
    this.email,
    this.fullName,
    this.address,
    this.dateOfBirth,
    this.avatarUrl,
    this.roleName,
    this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        email: json["email"],
        fullName: json["fullName"],
        address: json["address"],
        dateOfBirth: DateTime.parse(json["dateOfBirth"]),
        avatarUrl: json["avatarUrl"],
        roleName: json["roleName"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "fullName": fullName,
        "address": address,
        "dateOfBirth": dateOfBirth != null
            ? "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}"
            : null,
        "avatarUrl": avatarUrl,
        "roleName": roleName,
        "status": status,
      };
}
