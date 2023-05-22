import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:network_repository/network_repository.dart';
import 'package:user_repository/src/models/models.dart';

class UserRepository {
  User? _user = User.empty;

  Future<User?> getUser(String token) async {
    print('token $token');
    print('_user $_user');
    if (_user == User.empty) {
      final res = await requestUser(token: token);
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final data = json['data'] as Map<String, dynamic>;
      final user = data['user'] as Map<String, dynamic>;

      final id = user['id'].toString();
      final name = user['name'].toString();
      final username = user['username'].toString();
      final email = user['email'].toString();

      _user = User(id, name: name, username: username, email: email);
    }
    return _user;
    // return Future.delayed(
    //   const Duration(milliseconds: 300),
    //   () => _user = User(const Uuid().v4()),
    // );
  }
}

Future<http.Response> requestUser({
  required String token,
}) {
  return http.get(
    Uri.parse(NetworkRepository.userURL),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'ngrok-skip-browser-warning': '69420',
      'Authorization': 'Bearer $token'
    },
  );
}
