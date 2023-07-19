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
    List<Project>? projects = [];
    print(event.status);
    switch (event.status) {
      case ProjectStatus.uninitialized:
        return emit(ProjectState.uninitialized());

      case ProjectStatus.loading:
        return emit(ProjectState.loading(state.projects));

      case ProjectStatus.retrieving:
        projects = await _tryGetProject(_authenticationRepository.token);
        return emit(
          projects != null
              ? ProjectState.ready(projects)
              : ProjectState.error(),
        );

      case ProjectStatus.updatingProject:
        final updatedProject = await _tryUpdateProject(
            _authenticationRepository.token, event.project);
        if (updatedProject != null) {
          List<Project> projects = state.projects;
          int updateIndex = projects.indexWhere(
            (e) => e.id == updatedProject.id,
          );
          projects.removeAt(updateIndex);
          projects.insert(updateIndex, updatedProject);
          return emit(ProjectState.ready(projects));
        }
        return emit(ProjectState.error());

      case ProjectStatus.updatingUserstory:
        final updatedUserstory = await _tryUpdateUserstory(
            _authenticationRepository.token, event.userstory);
        if (updatedUserstory != null) {
          List<Project> projects = state.projects;
          int projectIndex = projects.indexWhere((project) =>
              project.userstories.firstWhere(
                  (userstory) => userstory.id == updatedUserstory.id,
                  orElse: () => Userstory.empty) !=
              Userstory.empty);
          int updateIndex = projects[projectIndex]
              .userstories
              .indexWhere((userstory) => userstory.id == updatedUserstory.id);
          projects[projectIndex].userstories.removeAt(updateIndex);
          projects[projectIndex]
              .userstories
              .insert(updateIndex, updatedUserstory);
          return emit(ProjectState.ready(projects));
        }
        return emit(ProjectState.error());

      case ProjectStatus.removingUserstory:
        final removedUserstory = await _tryRemoveUserstory(
            _authenticationRepository.token, event.userstory);
        if (removedUserstory != null) {
          print('removedUserstory');
          print(removedUserstory);
          List<Project> projects = state.projects;
          int projectIndex = projects.indexWhere((project) =>
              project.userstories.firstWhere(
                  (userstory) => userstory.id == removedUserstory.id,
                  orElse: () => Userstory.empty) !=
              Userstory.empty);
          int updateIndex = projects[projectIndex]
              .userstories
              .indexWhere((userstory) => userstory.id == removedUserstory.id);
          projects[projectIndex].userstories.removeAt(updateIndex);
          return emit(ProjectState.ready(projects));
        }
        return emit(ProjectState.error());

      case ProjectStatus.error:
        return emit(ProjectState.error());

      case ProjectStatus.ready:
        return emit(ProjectState.ready(state.projects));

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

  Future<Userstory?> _tryUpdateUserstory(
      String token, Userstory userstory) async {
    try {
      print('_tryUpdateProject');
      final updatedUserstory =
          await _projectRepository.updateUserstory(token, userstory);
      return Userstory(
        updatedUserstory!.id,
        title: updatedUserstory.title,
        status: updatedUserstory.status,
        tasks: userstory.tasks,
      );
    } catch (_) {
      return null;
    }
  }

  Future<Userstory?> _tryRemoveUserstory(
      String token, Userstory userstory) async {
    try {
      print('_tryRemoveUserstory');
      final removedUserstory =
          await _projectRepository.removeUserstory(token, userstory);
      return removedUserstory;
    } catch (_) {
      return null;
    }
  }
}
