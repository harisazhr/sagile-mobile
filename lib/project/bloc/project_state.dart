part of 'project_bloc.dart';

class ProjectState extends Equatable {
  const ProjectState._({
    this.status = ProjectStatus.uninitialized,
    this.projects = const [],
  });

  const ProjectState.uninitialized() : this._();
  const ProjectState.ready(List<Project> projects)
      : this._(status: ProjectStatus.ready, projects: projects);

  const ProjectState.loading(projects)
      : this._(status: ProjectStatus.loading, projects: projects);

  const ProjectState.updates(List<Project> projects)
      : this._(projects: projects, status: ProjectStatus.updatingProject);

  const ProjectState.error() : this._(status: ProjectStatus.error);

  final ProjectStatus status;
  final List<Project> projects;

  @override
  List<Object> get props => [status, projects];
}
