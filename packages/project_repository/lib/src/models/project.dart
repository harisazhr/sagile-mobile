import 'package:equatable/equatable.dart';

class Project extends Equatable {
  const Project(
    this.id, {
    this.title = '',
    this.statuses = const [],
    this.userstories = const [],
  });

  final String id;
  final String title;
  final List<String> statuses;
  final List<String> userstories;

  @override
  List<Object> get props => [id, title, statuses, userstories];

  static const empty = Project('-');
}
