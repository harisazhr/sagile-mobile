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
    on<ProjectUpdateRequested>(_onProjectUpdateRequested);
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
    List<Project>? projects = [];
    // print(event.status);
    switch (event.status) {
      case ProjectStatus.uninitialized:
        return emit(ProjectState.uninitialized());

      case ProjectStatus.loading:
        projects = await _tryGetProject(_authenticationRepository.token);
        // print(projects);
        return emit(
          projects != null
              ? ProjectState.loads(projects)
              : ProjectState.error(),
        );

      case ProjectStatus.updating:
        projects = state.projects;
        return emit(ProjectState.updating(projects));

      case ProjectStatus.error:
        return emit(ProjectState.error());

      default:
        break;
    }
  }

  Future<List<Project>?> _tryGetProject(String token) async {
    try {
      final projects = await _projectRepository.getProject(token);
      return projects;
    } catch (_) {
      return null;
    }
  }

  Future<void> _onProjectUpdateRequested(
    ProjectUpdateRequested event,
    Emitter<ProjectState> emit,
  ) async {
    print('_onProjectUpdateRequested');
    Project? updatedProject =
        await _tryUpdateProject(_authenticationRepository.token, event.project);
    // Project? project = event.project;
    print(updatedProject);
    if (updatedProject != null) {
      List<Project> projects = state.projects;
      int updateIndex = projects.indexWhere(
        (e) => e.id == updatedProject.id,
      );
      projects.removeAt(updateIndex);
      projects.insert(updateIndex, updatedProject);
      return emit(ProjectState.loads(projects));
    }
    return emit(ProjectState.error());
  }

  Future<Project?> _tryUpdateProject(String token, Project project) async {
    try {
      print('_tryUpdateProject');
      final updatedProject =
          await _projectRepository.updateProject(token, project);
      return updatedProject;
    } catch (_) {
      return null;
    }
  }
}
