import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_repository/project_repository.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc({
    required ProjectRepository projectRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _projectRepository = projectRepository,
        _authenticationRepository = authenticationRepository,
        super(const ProjectState.uninitialized()) {
    on<ProjectStatusChanged>(_onProjectStatusChanged);
    _projectStatusSubscription = _projectRepository.status.listen(
      (status) => add(ProjectStatusChanged(status)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final ProjectRepository _projectRepository;
  late StreamSubscription<ProjectStatus> _projectStatusSubscription;

  @override
  Future<void> close() {
    _projectStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onProjectStatusChanged(
    ProjectStatusChanged event,
    Emitter<ProjectState> emit,
  ) async {
    switch (event.status) {
      case ProjectStatus.uninitialized:
        return emit(const ProjectState.uninitialized());

      // case ProjectStatus.loading:
      // return emit(const ProjectState.loaded());
      // final user = await _tryGetUser(_authenticationRepository.token);
      // print('user $user');
      // return emit(
      //   user != null
      //       ? ProjectState.authenticated(user)
      //       : const ProjectState.unauthenticated(),
      // );

      case ProjectStatus.loaded:
        final projects = await _tryGetProject(_authenticationRepository.token);
        return emit(
          projects != null
              ? ProjectState.loaded(projects)
              : ProjectState.error(),
        );

      case ProjectStatus.error:
        return emit(const ProjectState.error());
    }
  }

  Future<List<Project>?> _tryGetProject(token) async {
    try {
      final projects = await _projectRepository.getProject(token);
      return projects;
    } catch (_) {
      return null;
    }
  }
}
