import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskService {
  static const String baseUrl =
      'https://69ddbb8f410caa3d47b9e4e6.mockapi.io/tasks';

  Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception('Không tải được danh sách task');
    }
  }

  Future<void> deleteTask(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Xóa task thất bại');
    }
  }
}