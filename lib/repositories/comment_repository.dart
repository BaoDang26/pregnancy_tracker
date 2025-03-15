import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/build_server.dart';
import '../config/jwt_interceptor.dart';
import '../models/comment_model.dart';

class CommentRepository {
  static Future<http.Response> getCommentListGuestByPostId(int postId) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl(
              "guest/community-posts/getCommentsByPostId/$postId"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> getCommentList(int postId) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("comment/listAll/$postId"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> createComment(
      CommentModel comment, int postId) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .post(
          BuildServer.buildUrl("comment/createComment/$postId"),
          headers: header,
          body: jsonEncode(comment.toCreateJson()),
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> updateComment(
      CommentModel comment, int commentId) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .put(
          BuildServer.buildUrl("comment/updateComment/$commentId"),
          headers: header,
          body: jsonEncode(comment.toUpdateJson()),
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> deleteComment(int commentId) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .delete(
          BuildServer.buildUrl("comment/deleteComment/$commentId"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }
}
