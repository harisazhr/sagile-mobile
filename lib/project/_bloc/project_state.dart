part of 'project_bloc.dart';

enum ProjectStateList { initial, success, failure }

class ProjectState extends Equatable {
  const ProjectState({
    this.status = ProjectStateList.initial,
    this.projects = const <Project>[],
    this.hasReachedMax = false,
  });

  final ProjectStateList status;
  final List<Project> projects;
  final bool hasReachedMax;

  ProjectState copyWith({
    ProjectStateList? status,
    List<Project>? projects,
    bool? hasReachedMax,
  }) {
    return ProjectState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''ProjectState { status: $status, hasReachedMax: $hasReachedMax, projects: ${projects.length} }''';
  }

  @override
  List<Object> get props => [status, projects, hasReachedMax];
}
