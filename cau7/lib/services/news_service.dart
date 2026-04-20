import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news.dart';

class NewsService {
  static const String baseUrl =
      'https://69ddbb8f410caa3d47b9e4e6.mockapi.io/news';

  Future<List<News>> getNews() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => News.fromJson(e)).toList();
    } else {
      throw Exception('Không tải được danh sách news');
    }
  }
}