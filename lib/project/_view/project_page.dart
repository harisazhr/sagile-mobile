import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sagile_mobile/project/project.dart';
import 'package:http/http.dart' as http;

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: BlocProvider(
        create: (_) =>
            ProjectBloc(httpClient: http.Client())..add(ProjectFetched()),
        child: const ProjectList(),
      ),
    );
  }
}
