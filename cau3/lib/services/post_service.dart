import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostService {
  static const String url =
      'https://69ddbb8f410caa3d47b9e4e6.mockapi.io/posts';

  Future<Post> createPost(Post post) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Create post failed (${response.statusCode}): ${response.body}',
      );
    }
  }
}
