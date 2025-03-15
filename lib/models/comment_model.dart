// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

List<CommentModel> commentModelFromJson(String str) => List<CommentModel>.from(
    json.decode(str).map((x) => CommentModel.fromJson(x)));

String commentModelToJson(List<CommentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentModel {
  int? id;
  int? postId;
  int? userId;
  String? content;
  String? status;
  DateTime? createdDate;

  CommentModel({
    this.id,
    this.postId,
    this.userId,
    this.content,
    this.status,
    this.createdDate,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"],
        postId: json["postId"],
        userId: json["userId"],
        content: json["content"],
        status: json["status"],
        createdDate: DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "postId": postId,
        "userId": userId,
        "content": content,
        "status": status,
        "createdDate": createdDate?.toIso8601String(),
      };

  Map<String, dynamic> toCreateJson() => {
        "userId": userId,
        "content": content,
      };

  Map<String, dynamic> toUpdateJson() => {
        "userId": userId,
        "content": content,
      };
}
