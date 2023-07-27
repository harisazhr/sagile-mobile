import 'package:equatable/equatable.dart';
import 'package:project_repository/src/models/models.dart';

class Project extends Equatable {
  const Project(
    this.id, {
    this.title = '',
    this.description = '',
    this.startDate,
    this.endDate,
    this.team = '',
    this.statuses = const [],
    this.userstories = const [],
    // this.sprints = const [],
  });

  final int id;
  final String title;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String team;
  final List<Status> statuses;
  final List<Userstory> userstories;
  // final List<Sprint> sprints;

  @override
  List<Object?> get props =>
      [id, title, description, startDate, endDate, team, statuses, userstories];

  static const empty = Project(-1);

  void reorderStatuses() {
    print('reorderStatuses');
    final newStatuses = statuses
        .map(
          (e) => Status(e.id, title: e.title, order: statuses.indexOf(e) + 1),
        )
        .toList();
    statuses
      ..clear()
      ..addAll(newStatuses);
  }

  void updateStatus(Status status) {
    print('addOrUpdateStatus');
    final id = statuses.indexWhere((e) => e.id == status.id);

    if (id >= 0) {
      statuses
        ..removeAt(id)
        ..insert(id, status);
    } else {
      statuses.add(status);
    }
  }

  void removeStatus(int statusId) {
    print('removeStatus');
    final id = statuses.indexWhere((e) => e.id == statusId);
    statuses.removeAt(id);
  }
}
