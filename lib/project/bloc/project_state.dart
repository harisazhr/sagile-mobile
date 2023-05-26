part of 'project_bloc.dart';

class ProjectState extends Equatable {
  const ProjectState._({
    this.status = ProjectStatus.uninitialized,
    this.projects = const [],
  });

  const ProjectState.uninitialized() : this._();

  const ProjectState.loading() : this._(status: ProjectStatus.loading);
  const ProjectState.loads(List<Project> projects)
      : this._(projects: projects, status: ProjectStatus.loaded);

  const ProjectState.updating(List<Project> projects)
      : this._(projects: projects, status: ProjectStatus.updating);

  const ProjectState.error() : this._(status: ProjectStatus.error);

  final ProjectStatus status;
  final List<Project> projects;

  @override
  List<Object> get props => [status, projects];
}
