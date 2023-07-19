import 'package:equatable/equatable.dart';
import 'package:project_repository/src/models/status.dart';

class Task extends Equatable {
  const Task(
    this.id, {
    this.order = -1,
    this.title = '',
    this.status = Status.empty,
    this.startDate,
    this.endDate,
  });

  final int id;
  final int order;
  final String title;
  final Status status;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  List<Object?> get props => [id, order, title, status, startDate, endDate];

  static const empty = Task(-1);
}
