part of 'project_bloc.dart';

abstract class ProjectEvent {
  const ProjectEvent();
}

class ProjectStatusChanged extends ProjectEvent {
  const ProjectStatusChanged(this.status,
      {this.project = Project.empty, this.userstory = Userstory.empty});

  final ProjectStatus status;
  final Project project;
  final Userstory userstory;
}

// class ProjectUpdateRequested extends ProjectEvent {
//   const ProjectUpdateRequested(this.project);

//   final Project project;
// }
