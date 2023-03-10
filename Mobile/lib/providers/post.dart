import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class Post {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String location;
  final String description;
  final String userPicturePath;
  final String? picturePath;
  final Map<String, bool>? likes;
  final List<String>? comments;

  Post({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.description,
    required this.picturePath,
    required this.userPicturePath,
    this.likes,
    this.comments,
  });
}

class Posts with ChangeNotifier {
  final String _token;
  List<Post> _posts = [];

  Posts(this._token, this._posts);

  List<Post> get posts {
    return [..._posts];
  }

  Future<void> createPost(
      String userId, String description, File? picture, String? picturePath) async {
    try {
      final dio = Dio();
      dio.options.headers["Authorization"] = 'Bearer $_token';
      const url = 'http://localhost:8080/posts';

      var formData = FormData();

      if (picture == null) {
        formData = FormData.fromMap({
          'userId': userId,
          'description': description,
        });
      } else {
        formData = FormData.fromMap({
          'userId': userId,
          'description': description,
          'picturePath': picturePath,
          'picture': await MultipartFile.fromFile(picture.path),
        });
      }

      final response = await dio.post(
        url,
        data: formData,
      );

      final List<Post> loadedPosts = [];

      for (var post in response.data) {
        loadedPosts.add(Post(
          id: post['_id'],
          userId: post['userId'],
          firstName: post['firstName'],
          lastName: post['lastName'],
          location: post['location'],
          description: post['description'],
          picturePath: post['picturePath'],
          userPicturePath: post['userPicturePath'],
          likes: (post['likes'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value.toString().toLowerCase() == 'true')),
          comments: (post['comments'] as List).map((item) => item as String).toList(),
        ));
      }

      _posts = loadedPosts;

      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> fetchPosts({String userId = ''}) async {
    try {
      final url = Uri.parse("http://localhost:8080/posts/$userId");
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $_token'},
      );

      final List<Post> loadedPosts = [];

      final extractedData = json.decode(response.body) as List<dynamic>;

      if (extractedData == null) return;

      for (var post in extractedData) {
        loadedPosts.add(Post(
          id: post['_id'],
          userId: post['userId'],
          firstName: post['firstName'],
          lastName: post['lastName'],
          location: post['location'],
          description: post['description'],
          picturePath: post['picturePath'],
          userPicturePath: post['userPicturePath'],
          likes: (post['likes'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value.toString().toLowerCase() == 'true')),
          comments: (post['comments'] as List).map((item) => item as String).toList(),
        ));
      }

      _posts = loadedPosts;

      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> likePost(String postId, String userId) async {
    try {
      final url = Uri.parse("http://localhost:8080/posts/$postId/like");
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {'userId': userId},
        ),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      final postIndex = _posts.indexWhere((element) => element.id == responseData['_id']);

      _posts[postIndex] = Post(
        id: responseData['_id'],
        userId: responseData['userId'],
        firstName: responseData['firstName'],
        lastName: responseData['lastName'],
        location: responseData['location'],
        description: responseData['description'],
        picturePath: responseData['picturePath'],
        userPicturePath: responseData['userPicturePath'],
        likes: (responseData['likes'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, value.toString().toLowerCase() == 'true')),
        comments: (responseData['comments'] as List).map((item) => item as String).toList(),
      );

      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }
}
