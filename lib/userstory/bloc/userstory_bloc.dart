// import 'dart:async';

// import 'package:authentication_repository/authentication_repository.dart';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:project_repository/project_repository.dart';

// part 'userstory_event.dart';
// part 'userstory_state.dart';

// class ProjectBloc extends Bloc<UserstoryEvent, UserstoryState> {
//   ProjectBloc({
//     required ProjectRepository projectRepository,
//     required AuthenticationRepository authenticationRepository,
//   })  : _projectRepository = projectRepository,
//         _authenticationRepository = authenticationRepository,
//         super(const Use.uninitialized()) {
//     on<ProjectStatusChanged>(_onProjectStatusChanged);
//     _projectStatusSubscription = _projectRepository.status.listen(
//       (status) => add(ProjectStatusChanged(status)),
//     );
//   }

//   final AuthenticationRepository _authenticationRepository;
//   final ProjectRepository _projectRepository;
//   late StreamSubscription<ProjectStatus> _projectStatusSubscription;

//   @override
//   Future<void> close() {
//     _projectStatusSubscription.cancel();
//     return super.close();
//   }

//   Future<void> _onProjectStatusChanged(
//     ProjectStatusChanged event,
//     Emitter<ProjectState> emit,
//   ) async {
//     List<Project>? projects = [];
//     print(event.status);
//     switch (event.status) {
//       case ProjectStatus.uninitialized:
//         return emit(ProjectState.uninitialized());

//       case ProjectStatus.loading:
//         return emit(ProjectState.loading(state.projects));

//       case ProjectStatus.retrieving:
//         projects = await _tryGetProject(_authenticationRepository.token);
//         return emit(
//           projects != null
//               ? ProjectState.ready(projects)
//               : ProjectState.error(),
//         );

//       case ProjectStatus.updating:
//         print('event.project');
//         print(event.project);
//         final updatedProject = await _tryUpdateProject(
//             _authenticationRepository.token, event.project);
//         print('updatedProject');
//         print(updatedProject);
//         if (updatedProject != null) {
//           List<Project> projects = state.projects;
//           int updateIndex = projects.indexWhere(
//             (e) => e.id == updatedProject.id,
//           );
//           projects.removeAt(updateIndex);
//           projects.insert(updateIndex, updatedProject);
//           return emit(ProjectState.ready(projects));
//         }
//         return emit(ProjectState.error());

//       case ProjectStatus.error:
//         return emit(ProjectState.error());

//       case ProjectStatus.ready:
//         return emit(ProjectState.ready(state.projects));

//       default:
//         break;
//     }
//   }

//   Future<List<Project>?> _tryGetProject(String token) async {
//     try {
//       final projects = await _projectRepository.getProject(token);
//       return projects;
//     } catch (_) {
//       return null;
//     }
//   }

//   Future<Project?> _tryUpdateProject(String token, Project project) async {
//     try {
//       print('_tryUpdateProject');
//       final updatedProject =
//           await _projectRepository.updateProject(token, project);
//       return updatedProject;
//     } catch (_) {
//       return null;
//     }
//   }
// }
