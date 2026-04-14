import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cau1/models/user.dart';

class UserService {
  static const String _usersUrl = 'https://jsonplaceholder.typicode.com/users';

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(_usersUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to load users. Status: ${response.statusCode}');
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((dynamic item) => User.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}


