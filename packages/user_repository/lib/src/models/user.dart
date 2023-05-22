import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(
    this.id, {
    this.name = '',
    this.username = '',
    this.email = '',
  });

  final String id;
  final String name;
  final String username;
  final String email;

  @override
  List<Object> get props => [id, name, username, email];

  static const empty = User('-');
}
