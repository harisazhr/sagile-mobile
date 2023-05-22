part of 'project_bloc.dart';

class ProjectState extends Equatable {
  const ProjectState._({
    this.status = ProjectStatus.uninitialized,
    this.projects = const [],
  });

  const ProjectState.uninitialized() : this._();
  // const ProjectState.loaded() : this._(status: ProjectStatus.loaded);
  const ProjectState.loaded(List<Project> projects)
      : this._(projects: projects);
  const ProjectState.error() : this._(status: ProjectStatus.error);

  final ProjectStatus status;
  final List<Project> projects;

  @override
  List<Object> get props => [status, projects];
}
