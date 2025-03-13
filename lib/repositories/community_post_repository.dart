import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/build_server.dart';
import '../config/jwt_interceptor.dart';
import '../models/community_post_model.dart';

class CommunityPostRepository {
  static Future<http.Response> getCommunityPostList() async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient
        .get(
          BuildServer.buildUrl("community-post/listAll"),
          headers: header,
        )
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future<http.Response> getCommunityPostListOfUser() async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient.get(
        BuildServer.buildUrl("community-post/listAllbyUser"),
        headers: header);
    return response;
  }

  static Future<http.Response> createCommunityPost(
      CommunityPostModel communityPostModel) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient.post(
        BuildServer.buildUrl("community-post/createPost"),
        headers: header,
        body: json.encode(communityPostModel.toCreateJson()));
    return response;
  }

  static Future<http.Response> updateCommunityPost(
      CommunityPostModel communityPostModel, int postId) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient.put(
        BuildServer.buildUrl("community-post/updatePost/$postId"),
        headers: header,
        body: json.encode(communityPostModel.toUpdateJson()));
    return response;
  }

  static Future<http.Response> deleteCommunityPost(int postId) async {
    http.Response response;

    Map<String, String> header = {
      "Content-type": "application/json",
    };
    response = await interceptedClient.delete(
        BuildServer.buildUrl("community-post/deletePost/$postId"),
        headers: header);
    return response;
  }
}
