import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:network_repository/network_repository.dart';
import 'package:project_repository/src/models/models.dart';

enum ProjectStatus {
  error,
  uninitialized,
  loading,
  ready,
  retrieving,
  updatingProject,
  updatingUserstory,
  removingUserstory
}
// enum ProjectStatus { error, uninitialized, loading, loaded }

class ProjectRepository {
  final _controller = StreamController<ProjectStatus>();

  Stream<ProjectStatus> get status async* {
    yield* _controller.stream;
  }

  Future<List<Project>?> getProject(String token) async {
    print('getProject');

    try {
      final res = await requestGetProject(token: token);
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      // print('json');
      // print(json);
      final success = json['success'] as bool;
      if (success) {
        final projects = <Project>[];
        final data = json['data'] as List;

        for (final projectJsonString in data) {
          final projectJsonObject = projectJsonString as Map<String, dynamic>;

          final statuses = <Status>[];
          final statusesList = projectJsonObject['statuses'] as List;
          if (statusesList.isNotEmpty) {
            for (final statusJsonString in statusesList) {
              final statusJsonObject = statusJsonString as Map<String, dynamic>;
              final status = Status(
                int.parse(
                  statusJsonObject['id']!.toString(),
                ),
                order: int.parse(
                  statusJsonObject['order']!.toString(),
                ),
                title: statusJsonObject['title']!.toString(),
              );
              statuses.add(status);
            }
          }

          final userstories = <Userstory>[];
          final userstoriesList = projectJsonObject['userstories'] as List;
          if (userstoriesList.isNotEmpty) {
            for (final userstoryJsonString in userstoriesList) {
              final userstoryJsonObject =
                  userstoryJsonString as Map<String, dynamic>;

              final tasks = <Task>[];
              final tasksList = userstoryJsonString['tasks'] as List;
              if (tasksList.isNotEmpty) {
                for (final taskJsonString in tasksList) {
                  final taskJsonObject = taskJsonString as Map<String, dynamic>;
                  // print('taskJsonObject');
                  // print(taskJsonObject);
                  final task = Task(
                    int.parse(
                      taskJsonObject['id']!.toString(),
                    ),
                    order: int.parse(
                      taskJsonObject['order']!.toString(),
                    ),
                    title: taskJsonObject['title']!.toString(),
                    status: statuses.firstWhere(
                      (status) =>
                          status.id ==
                          int.parse(taskJsonObject['status_id']!.toString()),
                      orElse: () => Status.empty,
                    ),
                    startDate: DateTime.tryParse(
                      taskJsonObject['start_date']!.toString(),
                    ),
                    endDate: DateTime.tryParse(
                      taskJsonObject['end_date']!.toString(),
                    ),
                  );

                  tasks.add(task);
                }
              }
              // print('tasks');
              // print(tasks);

              // print('userstoryJsonObject');
              // print(userstoryJsonObject);
              final userstory = Userstory(
                int.parse(
                  userstoryJsonObject['u_id']!.toString(),
                ),
                title: userstoryJsonObject['user_story']!.toString(),
                // sprint: userstorySprint.isNotEmpty
                //     ? userstorySprint.first
                //     : Sprint.empty,
                status: statuses.firstWhere(
                  (status) =>
                      status.id ==
                      int.parse(userstoryJsonObject['status_id']!.toString()),
                  orElse: () => Status.empty,
                ),
                tasks: tasks,
              );
              userstories.add(userstory);
            }
          }
          // print('userstories');
          // print(userstories);

          final project = Project(
            int.parse(projectJsonObject['id']!.toString()),
            title: projectJsonObject['title']!.toString(),
            description: projectJsonObject['description']!.toString(),
            startDate:
                DateTime.tryParse(projectJsonObject['start_date']!.toString()),
            endDate:
                DateTime.tryParse(projectJsonObject['end_date']!.toString()),
            team: projectJsonObject['team']!.toString(),
            statuses: statuses,
            userstories: userstories,
          );
          projects.add(project);
        }
        _controller.add(ProjectStatus.ready);
        // print('projects');
        // print(projects);
        return projects;
      }
    } catch (error) {
      print(error);
    }
    _controller.add(ProjectStatus.error);
    return null;
  }

  Future<http.Response> requestGetProject({
    required String token,
  }) {
    // _controller.add(ProjectStatus.loading);
    return http.get(
      Uri.parse(NetworkRepository.projectURL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'ngrok-skip-browser-warning': '69420',
        'Authorization': 'Bearer $token'
      },
    );
  }

  Future<Project?> updateProject(String token, Project project) async {
    // print('updateProject');
    final res = await requestUpdateProject(token: token, project: project);
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    // print(json);

    final success = json['success'] as bool;
    if (success) {
      final projectJsonObject = json['data'] as Map<String, dynamic>;

      final statuses = <Status>[];
      final statusesList = projectJsonObject['statuses'] as List;
      if (statusesList.isNotEmpty) {
        for (final statusJsonString in statusesList) {
          final statusJsonObject = statusJsonString as Map<String, dynamic>;
          final status = Status(
            int.parse(
              statusJsonObject['id']!.toString(),
            ),
            order: int.parse(
              statusJsonObject['order']!.toString(),
            ),
            title: statusJsonObject['title']!.toString(),
          );
          statuses.add(status);
        }
      }

      final updatedProject = Project(
        int.parse(projectJsonObject['id']!.toString()),
        title: projectJsonObject['title']!.toString(),
        description: projectJsonObject['description']!.toString(),
        startDate: DateTime.parse(projectJsonObject['start_date']!.toString()),
        endDate: DateTime.parse(projectJsonObject['end_date']!.toString()),
        team: projectJsonObject['team']!.toString(),
        statuses: statuses,
        userstories: project.userstories,
      );
      _controller.add(ProjectStatus.ready);
      // print(updatedProject);
      return updatedProject;
    }

    _controller.add(ProjectStatus.error);
    return null;
  }

  Future<http.Response> requestUpdateProject({
    required String token,
    required Project project,
  }) {
    final url = '${NetworkRepository.projectURL}/${project.id}';
    final body = jsonEncode(
      <String, String>{
        'mode': 'project',
        'title': project.title,
        'description': project.description,
        'start_date': project.startDate!.toString(),
        'end_date': project.endDate!.toString(),
        'statuses': project.statuses
            .map(
              (status) => jsonEncode(
                status.id.toString() == '-1'
                    ? <String, String>{
                        'order': status.order.toString(),
                        'title': status.title,
                      }
                    : <String, String>{
                        'id': status.id.toString(),
                        'order': status.order.toString(),
                        'title': status.title,
                      },
              ),
            )
            .toList()
            .toString(),
        'userstories': project.userstories
            .map(
              (userstory) => jsonEncode(
                userstory.id.toString() == '-1'
                    ? <String, String>{
                        'title': userstory.title,
                        'status': userstory.status.id.toString(),
                      }
                    : <String, String>{
                        'id': userstory.id.toString(),
                        'title': userstory.title,
                        'status': userstory.status.id.toString(),
                      },
              ),
            )
            .toList()
            .toString(),
      },
    );
    print('body');
    print(body);

    return http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'ngrok-skip-browser-warning': '69420',
        'Authorization': 'Bearer $token'
      },
      body: body,
    );
  }

  Future<Userstory?> updateUserstory(String token, Userstory userstory) async {
    print('updateUserstory');
    try {
      final res =
          await requestUpdateUserstory(token: token, userstory: userstory);
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      print(json);

      final success = json['success'] as bool;
      if (success) {
        final userstoryJsonObject = json['data'] as Map<String, dynamic>;
        // print('userstoryJsonObject');
        // print(userstoryJsonObject);

        final statusObj = userstoryJsonObject['status'] as Map<String, dynamic>;
        // print('status');
        // print(statusObj);
        final status = Status(
          statusObj['id'] as int,
          order: statusObj['order'] as int,
          title: statusObj['title'] as String,
        );
        // print(status);

        final tasks = <Task>[];
        final tasksList = userstoryJsonObject['tasks'] as List;
        if (tasksList.isNotEmpty) {
          for (final taskJsonString in tasksList) {
            print('task');
            final taskJsonObject = taskJsonString as Map<String, dynamic>;
            // print(taskJsonObject);
            final task = Task(
              int.parse(
                taskJsonObject['id']!.toString(),
              ),
              order: int.parse(
                taskJsonObject['order']!.toString(),
              ),
              title: taskJsonObject['title']!.toString(),
              startDate:
                  DateTime.parse(taskJsonObject['start_date']!.toString()),
              endDate: DateTime.parse(taskJsonObject['end_date']!.toString()),
            );
            print(task);
            tasks.add(task);
          }
        }

        final updatedUserstory = Userstory(
          int.parse(userstoryJsonObject['id']!.toString()),
          title: userstoryJsonObject['title']!.toString(),
          status: status,
          tasks: tasks,
        );

        // print('updatedUserstory');
        // print(updatedUserstory);
        _controller.add(ProjectStatus.ready);
        return updatedUserstory;
      }
    } catch (e) {
      print(e);
    }

    _controller.add(ProjectStatus.error);
    return null;
  }

  Future<http.Response> requestUpdateUserstory({
    required String token,
    required Userstory userstory,
  }) {
    final url = '${NetworkRepository.projectURL}/${userstory.id}';
    final body = jsonEncode(
      <String, String>{
        'mode': 'userstory',
        'title': userstory.title,
        'status': userstory.status.id.toString(),
        'tasks': userstory.tasks
            .map(
              (task) => jsonEncode(
                task.id.toString() == '-1'
                    ? <String, String>{
                        'order': task.order.toString(),
                        'status': task.status.id.toString(),
                        'title': task.title,
                        'startDate': task.startDate!.toIso8601String(),
                        'endDate': task.endDate!.toIso8601String(),
                      }
                    : <String, String>{
                        'id': task.id.toString(),
                        'order': task.order.toString(),
                        'status': task.status.id.toString(),
                        'title': task.title,
                        'startDate': task.startDate!.toIso8601String(),
                        'endDate': task.endDate!.toIso8601String(),
                      },
              ),
            )
            .toList()
            .toString(),
      },
    );
    // print('body');
    // print(body);

    return http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'ngrok-skip-browser-warning': '69420',
        'Authorization': 'Bearer $token'
      },
      body: body,
    );
  }

  Future<Userstory?> removeUserstory(String token, Userstory userstory) async {
    print('removeUserstory');
    try {
      final res =
          await requestRemoveUserstory(token: token, userstory: userstory);
      // print(res);
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      // print(json);

      final success = json['success'] as bool;
      if (success) {
        final userstoryJsonObject = json['data'] as Map<String, dynamic>;
        print('userstoryJsonObject');
        print(userstoryJsonObject);

        final statusObj = userstoryJsonObject['status'] as Map<String, dynamic>;
        print('statusObj');
        print(statusObj);
        final status = Status(
          statusObj['id'] as int,
          order: statusObj['order'] as int,
          title: statusObj['title'] as String,
        );

        final removedUserstory = Userstory(
          int.parse(userstoryJsonObject['id']!.toString()),
          title: userstoryJsonObject['title']!.toString(),
          status: status,
        );
        print('removedUserstory');
        print(removedUserstory);
        // _controller.add(ProjectStatus.ready);
        return removedUserstory;
      }
    } catch (e) {
      print(e);
    }
    _controller.add(ProjectStatus.error);
    return null;
  }

  Future<http.Response> requestRemoveUserstory({
    required String token,
    required Userstory userstory,
  }) {
    final url = '${NetworkRepository.projectURL}/${userstory.id}';
    final body = jsonEncode(
      <String, String>{
        'mode': 'userstory',
      },
    );
    // print('body');
    // print(body);

    return http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'ngrok-skip-browser-warning': '69420',
        'Authorization': 'Bearer $token'
      },
      body: body,
    );
  }

  void clearCache() {
    _controller.add(ProjectStatus.uninitialized);
  }
}
