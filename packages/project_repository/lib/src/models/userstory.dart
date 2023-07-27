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

  void reorderTasks() {
    print('reorderTask');
    final newTasks = tasks
        .map(
          (e) => Task(
            e.id,
            order: tasks.indexOf(e) + 1,
            title: e.title,
            status: e.status,
            startDate: e.startDate,
            endDate: e.endDate,
          ),
        )
        .toList();
    tasks
      ..clear()
      ..addAll(newTasks);
    print('tasks');
    print(tasks);
  }

  Userstory copyWith({
    int? id,
    String? title,
    Status? status,
    List<Task>? tasks,
  }) {
    return Userstory(
      id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
    );
  }
}
