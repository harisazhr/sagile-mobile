import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_repository/project_repository.dart';
import 'package:sagile_mobile/project/bloc/project_bloc.dart';

class ProjectModal extends StatefulWidget {
  const ProjectModal({
    super.key,
    required this.projectId,
  });

  final int projectId;

  @override
  State<ProjectModal> createState() => _ProjectModalState();
}

class _ProjectModalState extends State<ProjectModal> {
  @override
  Widget build(BuildContext context) {
    final _navigator = Navigator.of(context);
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        final project = state.projects
            .firstWhere((element) => element.id == widget.projectId);
        // print('project');
        // print(widget.projectId);
        // print(project);
        return AlertDialog(
          // title: Text("Success"),
          title: Text('${project.title}'),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${project.description}'),
                Text('Team: ${project.team}'),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _navigator.pop();
                showDialog(
                  context: context,
                  builder: (context) =>
                      ProjectModalEdit(projectId: widget.projectId),
                );
              },
              child: Text("Edit"),
            ),
            ElevatedButton(
              onPressed: () {
                _navigator.pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

class ProjectModalEdit extends StatefulWidget {
  const ProjectModalEdit({
    super.key,
    required this.projectId,
  });

  final int projectId;

  @override
  State<ProjectModalEdit> createState() => _ProjectModalEditState();
}

class _ProjectModalEditState extends State<ProjectModalEdit> {
  @override
  Widget build(BuildContext context) {
    final _navigator = Navigator.of(context);
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        final _project = state.projects
            .firstWhere((element) => element.id == widget.projectId);
        final _controller = <String, TextEditingController>{
          'title': TextEditingController.fromValue(
              TextEditingValue(text: _project.title)),
          'description': TextEditingController.fromValue(
              TextEditingValue(text: _project.description)),
          'team': TextEditingController.fromValue(
              TextEditingValue(text: _project.team)),
        };

        final _formKey = GlobalKey<FormState>();
        return Scaffold(
          appBar: AppBar(title: Text('Edit Project'), actions: []),
          floatingActionButton: BlocListener<ProjectBloc, ProjectState>(
            listener: (context, state) {
              switch (state.status) {
                case ProjectStatus.updating:
                  break;
                default:
              }
            },
            child: FloatingActionButton(
              onPressed: () {
                final isValid = _formKey.currentState!.validate();
                if (isValid) {
                  final updatedProject = Project(
                    widget.projectId,
                    title: _controller['title']!.text,
                    description: _controller['description']!.text,
                    team: _controller['team']!.text,
                  );
                  _navigator.pop();
                  context
                      .read<ProjectBloc>()
                      .add(ProjectStatusChanged(ProjectStatus.updating));
                  context
                      .read<ProjectBloc>()
                      .add(ProjectUpdateRequested(updatedProject));
                }
              },
              child: Icon(
                Icons.save,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _controller['title'],
                          decoration: InputDecoration(
                            labelText: "Title",
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _controller['description'],
                          decoration: InputDecoration(
                            labelText: "Description",
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          // maxLength: 300,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _controller['team'],
                          decoration: InputDecoration(
                            labelText: "Team",
                            isDense: true,
                            border: OutlineInputBorder(),
                            enabled: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Statuses',
                              ),
                              ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Add New Status')),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ReorderableListView(
                            // shrinkWrap: true,
                            children: <Widget>[
                              ..._project.statuses.map(
                                (e) => Card(
                                  key: Key('$e'),
                                  child: ListTile(
                                    title: Text('$e'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  ProjectModalStatusDelete(
                                                      project: _project,
                                                      statusId:
                                                          // 'e.index'),
                                                          1),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                            onReorder: (int oldIndex, int newIndex) {
                              setState(() {
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                _project.statuses.insert(newIndex,
                                    _project.statuses.removeAt(oldIndex));
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProjectModalStatusDelete extends StatefulWidget {
  const ProjectModalStatusDelete({
    super.key,
    required this.project,
    required this.statusId,
  });

  final Project project;
  final int statusId;

  @override
  State<ProjectModalStatusDelete> createState() =>
      _ProjectModalStatusDeleteState();
}

class _ProjectModalStatusDeleteState extends State<ProjectModalStatusDelete> {
  @override
  Widget build(BuildContext context) {
    final _navigator = Navigator.of(context);
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        final status = widget.project.statuses[widget.statusId];
        return AlertDialog(
          // title: Text("Success"),
          title: Text('${status}'),
          content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text('Are you sure you want to delte this status?')),
          actions: [
            ElevatedButton(
              onPressed: () {
                _navigator.pop();
                // TODO: Delete
                // showDialog(
                //   context: context,
                //   builder: (context) =>
                //       ProjectModalEdit(projectId: widget.projectId),
                // );
              },
              child: Text("Delete"),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Cancel
                _navigator.pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
