import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:sagile_mobile/project/project.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

part 'project_event.dart';
part 'project_state.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc({required this.httpClient}) : super(const ProjectState()) {
    on<ProjectFetched>(
      _onProjectFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onProjectFetched(
    ProjectFetched event,
    Emitter<ProjectState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == ProjectStateList.initial) {
        final projects = await _fetchProjects();
        return emit(
          state.copyWith(
            status: ProjectStateList.success,
            projects: projects,
            hasReachedMax: false,
          ),
        );
      }
      final projects = await _fetchProjects(state.projects.length);
      projects.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: ProjectStateList.success,
                projects: List.of(state.projects)..addAll(projects),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: ProjectStateList.failure));
    }
  }

  Future<List<Project>> _fetchProjects([int startIndex = 0]) async {
    final response = await httpClient.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        <String, String>{'_start': '$startIndex', '_limit': '$_postLimit'},
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Project(
          id: map['id'] as int,
          title: map['title'] as String,
          body: map['body'] as String,
        );
      }).toList();
    }
    throw Exception('error fetching posts');
  }
}
