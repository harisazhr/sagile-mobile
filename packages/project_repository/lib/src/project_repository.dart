import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:network_repository/network_repository.dart';
import 'package:project_repository/src/models/models.dart';

enum ProjectStatus { error, uninitialized, loading, updating, loaded }
// enum ProjectStatus { error, uninitialized, loading, loaded }

class ProjectRepository {
  final _controller = StreamController<ProjectStatus>();

  Stream<ProjectStatus> get status async* {
    yield* _controller.stream;
  }

  Future<List<Project>?> getProject(String token) async {
    final res = await requestGetProject(token: token);
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    print('json');
    print(json);
    final success = json['success'] as bool;

    if (success) {
      final projects = <Project>[];
      final data = json['data'] as List;

      for (final projectJsonString in data) {
        final projectJsonObject = projectJsonString as Map<String, dynamic>;

        final statuses = <String>[];
        final statusesList = projectJsonObject['statuses'] as List;
        for (final statusJsonString in statusesList) {
          final statusJsonObject = statusJsonString as Map<String, dynamic>;
          final status = statusJsonObject['title']!.toString();
          statuses.add(status);
        }

        final project = Project(
          int.parse(projectJsonObject['id']!.toString()),
          title: projectJsonObject['title']!.toString(),
          description: projectJsonObject['description']!.toString(),
          team: projectJsonObject['team']!.toString(),
          statuses: statuses,
        );
        print('project');
        print(project);
        projects.add(project);
      }
      _controller.add(ProjectStatus.loaded);
      return projects;
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
    final res = await requestUpdateProject(token: token, project: project);
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final success = json['success'] as bool;

    if (success) {
      final data = json['data'] as Map<String, dynamic>;
      final project = Project(
        int.parse(data['id']!.toString()),
        title: data['title']!.toString(),
        description: data['description']!.toString(),
        team: data['team']!.toString(),
      );
      _controller.add(ProjectStatus.loaded);
      return project;
    }

    _controller.add(ProjectStatus.error);
    return null;
  }

  Future<http.Response> requestUpdateProject({
    required String token,
    required Project project,
  }) {
    // _controller.add(ProjectStatus.loading);
    final url = '${NetworkRepository.projectURL}/${project.id}';
    return http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'ngrok-skip-browser-warning': '69420',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(
        <String, String>{
          'title': project.title,
          'description': project.description,
        },
      ),
    );
  }

  void clearCache() {
    _controller.add(ProjectStatus.uninitialized);
  }
}
