import 'package:flutter/material.dart';

import 'package:cau1/models/user.dart';
import 'package:cau1/services/user_service.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> _usersFuture;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _usersFuture = _userService.fetchUsers();
  }

  void _retryFetchUsers() {
    setState(() {
      _usersFuture = _userService.fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List\nNguyễn Bình Minh - 6451071047'),
      ),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Failed to load users.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _retryFetchUsers,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final List<User> users = snapshot.data ?? <User>[];
          if (users.isEmpty) {
            return const Center(
              child: Text('No users found.'),
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final User user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${user.id}'),
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
              );
            },
          );
        },
      ),
    );
  }
}


