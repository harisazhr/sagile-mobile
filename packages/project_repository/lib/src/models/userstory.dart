import 'package:equatable/equatable.dart';
import 'package:project_repository/src/models/models.dart';

class Userstory extends Equatable {
  const Userstory(
    this.id, {
    this.title = '',
    this.status = Status.empty,
    // this.sprint = Sprint.empty,
    this.tasks = const [],
  });

  final int id;
  final String title;
  final Status status;
  // final Sprint sprint;
  final List<Task> tasks;

  @override
  // List<Object> get props => [id, title, status, sprint, tasks];
  List<Object> get props => [id, title, status, tasks];

  static const empty = Userstory(-1);
}
