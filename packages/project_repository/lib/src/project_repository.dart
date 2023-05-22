import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:network_repository/network_repository.dart';
import 'package:project_repository/src/models/models.dart';

enum ProjectStatus { error, uninitialized, loaded }
// enum ProjectStatus { error, empty, loading, loaded }

class ProjectRepository {
  final _controller = StreamController<ProjectStatus>();

  Stream<ProjectStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield ProjectStatus.uninitialized;
    yield* _controller.stream;
  }

  Future<List<Project>?> getProject(String token) async {
    print('token $token');
    // print('_projects $_projects');

    final res = await requestProject(token: token);
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    print(json);
    final success = json['success'] as bool;
    final projects = <Project>[];

    if (success == true) {
      final data = json['data'] as Map<String, dynamic>;
      final dataProjects = data['projects'] as List<Map<String, dynamic>>;

      for (final element in dataProjects) {
        final id = element['id'] as String;
        final title = element['title'] as String;
        // final statuses = element['statuses'].toString();
        // final userstories = element['userstories'].toString();

        projects.add(Project(id, title: title));
      }
      _controller.add(ProjectStatus.loaded);
    } else {
      _controller.add(ProjectStatus.error);
    }
    return projects;
  }

  Future<http.Response> requestProject({
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

  void clearCache() {
    _controller.add(ProjectStatus.uninitialized);
  }
}
