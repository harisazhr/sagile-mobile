import 'package:equatable/equatable.dart';

class Project extends Equatable {
  const Project(
    this.id, {
    this.title = '',
    this.description = '',
    this.team = '',
    this.statuses = const [],
    // this.userstories = const [],
  });

  final int id;
  final String title;
  final String description;
  final String team;
  final List<String> statuses;

  @override
  List<Object> get props => [id, title, description, team, statuses];

  static const empty = Project(0);
}
