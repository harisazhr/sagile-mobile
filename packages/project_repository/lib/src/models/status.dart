import 'package:equatable/equatable.dart';

class Status extends Equatable {
  const Status(
    this.id, {
    this.order = -1,
    this.title = '',
    // this.userstories = const [],
  });

  final int id;
  final int order;
  final String title;

  @override
  List<Object> get props => [id, order, title];

  static const empty = Status(-1);

  static List<Status> sortStatus(List<Status> statuses) {
    final sortedStatuses = statuses;
    final length = sortedStatuses.length;
    var isSorted = false;

    if (statuses.isNotEmpty) {
      while (!isSorted) {
        for (var i = 0; i < length; i++) {
          final status = sortedStatuses[i];
          // print(status);
          if (i != length - 1) {
            if (status.order > sortedStatuses[i + 1].order) {
              // print('sorting');
              sortedStatuses
                ..removeAt(i)
                ..insert(i + 1, status);
              isSorted = false;
              i = length;
            }
          } else {
            isSorted = true;
            // print('sorted');
          }
        }
      }
    }
    return sortedStatuses;
  }
}
