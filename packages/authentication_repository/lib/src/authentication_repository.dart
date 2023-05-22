import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:network_repository/network_repository.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  String token = '';

  // dunno
  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    // _controller.add(AuthenticationStatus.authenticated); // DEVENV
    final res = await requestAuth(password: password, username: username);
    final json = jsonDecode(res.body) as Map<String, dynamic>;

    final success = json['success'] as bool;
    print(success);

    if (success == true) {
      final data = json['data'] as Map<String, dynamic>;
      // print(data);

      final token = data['token'] as String;
      this.token = token;
      // print(token);

      _controller.add(AuthenticationStatus.authenticated);
    } else {
      _controller.add(AuthenticationStatus.unauthenticated);
    }
  }

  void logOut() {
    token = '';
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();

  Future<http.Response> requestAuth({
    required String username,
    required String password,
  }) {
    return http.post(
      Uri.parse(NetworkRepository.loginURL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'ngrok-skip-browser-warning': '69420',
      },
      body: jsonEncode(<String, String>{
        'email': username,
        'password': password,
      }),
    );
  }

  Future<http.Response> requestAuthLogOut() {
    return http.get(Uri.parse(NetworkRepository.logoutURL));
  }
}
