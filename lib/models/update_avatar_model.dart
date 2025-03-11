// To parse this JSON data, do
//
//     final updateAvatarModel = updateAvatarModelFromJson(jsonString);

import 'dart:convert';

UpdateAvatarModel updateAvatarModelFromJson(String str) =>
    UpdateAvatarModel.fromJson(json.decode(str));

String updateAvatarModelToJson(UpdateAvatarModel data) =>
    json.encode(data.toJson());

class UpdateAvatarModel {
  String? message;

  UpdateAvatarModel({
    this.message,
  });

  factory UpdateAvatarModel.fromJson(Map<String, dynamic> json) =>
      UpdateAvatarModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
