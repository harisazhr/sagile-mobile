import 'package:equatable/equatable.dart';
import 'package:project_repository/src/models/models.dart';

class Sprint extends Equatable {
  const Sprint(
    this.id, {
    this.title = '',
  });

  final int id;
  final String title;

  @override
  List<Object> get props => [id, title];

  static const empty = Sprint(-1);
}
