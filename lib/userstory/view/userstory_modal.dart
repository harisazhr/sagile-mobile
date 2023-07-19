import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project_repository/project_repository.dart';
import 'package:sagile_mobile/project/bloc/project_bloc.dart';

class UserstoryModal extends StatefulWidget {
  const UserstoryModal({
    super.key,
    required this.userstoryId,
  });

  final int userstoryId;

  @override
  State<UserstoryModal> createState() => _UserstoryModalState();
}

class _UserstoryModalState extends State<UserstoryModal> {
  @override
  Widget build(BuildContext context) {
    final _navigator = Navigator.of(context);
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        final _project = state.projects.firstWhere(
            (project) =>
                project.userstories.firstWhere(
                    (userstory) => userstory.id == widget.userstoryId,
                    orElse: () => Userstory.empty) !=
                Userstory.empty,
            orElse: () => Project.empty);
        final _userstory = _project.userstories.firstWhere(
            (userstory) => userstory.id == widget.userstoryId,
            orElse: () => Userstory.empty);

        return AlertDialog(
          titlePadding: EdgeInsets.all(16.0),
          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
          actionsPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: EdgeInsets.zero,
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    '${_userstory.status.title}',
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimary
                        // fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              Text(
                '${_userstory.title}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._userstory.tasks.map(
                  (task) => Card(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                margin: EdgeInsets.zero,
                                color: Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Text(
                                    '${task.status.title}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '${task.title}',
                                style: TextStyle(
                                  fontSize: 12,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Card(
                                margin: EdgeInsets.zero,
                                color: Colors.green,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Text(
                                    '${DateFormat('dd/MM/yyyy').format(task.startDate!)}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                margin: EdgeInsets.zero,
                                color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Text(
                                    '${DateFormat('dd/MM/yyyy').format(task.endDate!)}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Text('Status: ${userstory.status.title}'),
                // Text('Team: ${userstory.}'),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.red)),
              onPressed: () {
                _navigator.pop();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                        "Are you sure you want to DELETE this user story?"),
                    actions: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.red)),
                        onPressed: () {
                          _navigator.pop();
                          context.read<ProjectBloc>()
                            ..add(ProjectStatusChanged(ProjectStatus.loading))
                            ..add(ProjectStatusChanged(
                                ProjectStatus.removingUserstory,
                                userstory: _userstory));
                        },
                        child: Text("Yes"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _navigator.pop();
                        },
                        child: Text("Cancel"),
                      ),
                    ],
                  ),
                );
              },
              child: Text("Delete"),
            ),
            ElevatedButton(
              onPressed: () {
                _navigator.pop();
                _navigator.push(
                  MaterialPageRoute(
                    builder: (context) =>
                        UserstoryModalEdit(userstoryId: widget.userstoryId),
                  ),
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

class UserstoryModalEdit extends StatefulWidget {
  const UserstoryModalEdit({
    super.key,
    required this.userstoryId,
  });

  final int userstoryId;

  @override
  State<UserstoryModalEdit> createState() => _UserstoryModalEditState();
}

class _UserstoryModalEditState extends State<UserstoryModalEdit> {
  @override
  Widget build(BuildContext context) {
    final _navigator = Navigator.of(context);
    final _formKey = GlobalKey<FormState>();

    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        final _project = state.projects.firstWhere(
            (project) =>
                project.userstories.firstWhere(
                    (userstory) => userstory.id == widget.userstoryId,
                    orElse: () => Userstory.empty) !=
                Userstory.empty,
            orElse: () => Project.empty);
        final _userstory = _project.userstories.firstWhere(
            (userstory) => userstory.id == widget.userstoryId,
            orElse: () => Userstory.empty);

        final _statuses = _project.statuses;
        final _controller = <String, TextEditingController>{
          'title': TextEditingController.fromValue(
              TextEditingValue(text: _userstory.title)),
          'status': TextEditingController.fromValue(
              TextEditingValue(text: _userstory.status.id.toString())),
        };

        return Scaffold(
          appBar: AppBar(title: Text('Edit User Story'), actions: [
            IconButton(
              onPressed: () {
                final isValid = _formKey.currentState!.validate();
                if (isValid) {
                  final _updatedUserStory = Userstory(
                    widget.userstoryId,
                    title: _controller['title']!.text,
                    status: _statuses.firstWhere(
                      (status) =>
                          status.id == int.parse(_controller['status']!.text),
                    ),
                    tasks: _userstory.tasks,
                  );

                  context.read<ProjectBloc>()
                    ..add(ProjectStatusChanged(ProjectStatus.loading))
                    ..add(ProjectStatusChanged(ProjectStatus.updatingUserstory,
                        userstory: _updatedUserStory));
                  _navigator.pop();
                }
              },
              icon: Icon(
                Icons.save,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            )
          ]),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField(
                          // controller: _controller['status'],
                          decoration: InputDecoration(
                            labelText: "Status",
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          items: _statuses
                              .map((status) => DropdownMenuItem(
                                    child: Text(status.title),
                                    value: status.id,
                                  ))
                              .toList(),
                          value: int.parse(_controller['status']!.text),
                          onChanged: (newValue) {
                            _controller['status'] = TextEditingController(
                                text: newValue.toString());
                          },
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _navigator.push(
                        MaterialPageRoute(
                          builder: (context) => UserstoryModalTask(
                            userstoryId: widget.userstoryId,
                          ),
                        ),
                      );
                    },
                    child: Text("Manage Tasks"),
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

class UserstoryModalNew extends StatefulWidget {
  const UserstoryModalNew({
    super.key,
    required this.projectId,
  });

  final int projectId;

  @override
  State<UserstoryModalNew> createState() => _UserstoryModalNewState();
}

class _UserstoryModalNewState extends State<UserstoryModalNew> {
  @override
  Widget build(BuildContext context) {
    final _navigator = Navigator.of(context);
    final _formKey = GlobalKey<FormState>();

    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        final _project = state.projects
            .firstWhere((project) => project.id == widget.projectId);

        final _statuses = _project.statuses;
        final _controller = <String, TextEditingController>{
          'title': TextEditingController(),
          'status': TextEditingController(),
        };

        return Scaffold(
          appBar: AppBar(title: Text('Add User Story'), actions: [
            IconButton(
              onPressed: () {
                final isValid = _formKey.currentState!.validate();
                if (isValid) {
                  final _updatedUserStory = Userstory(
                    -1,
                    title: _controller['title']!.text,
                    status: _statuses.firstWhere(
                      (status) =>
                          status.id == int.parse(_controller['status']!.text),
                    ),
                  );

                  context.read<ProjectBloc>()
                    ..add(ProjectStatusChanged(ProjectStatus.loading))
                    ..add(ProjectStatusChanged(ProjectStatus.updatingUserstory,
                        userstory: _updatedUserStory));
                  _navigator.pop();
                }
              },
              icon: Icon(
                Icons.save,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            )
          ]),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField(
                          // controller: _controller['status'],
                          decoration: InputDecoration(
                            labelText: "Status",
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          items: _statuses
                              .map((status) => DropdownMenuItem(
                                    child: Text(status.title),
                                    value: status.id,
                                  ))
                              .toList(),
                          value: int.parse(_controller['status']!.text),
                          onChanged: (newValue) {
                            _controller['status'] = TextEditingController(
                                text: newValue.toString());
                          },
                        ),
                      ],
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     _navigator.push(
                  //       MaterialPageRoute(
                  //         builder: (context) => UserstoryModalTask(
                  //           userstoryId: widget.userstoryId,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   child: Text("Manage Tasks"),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class UserstoryModalTask extends StatefulWidget {
  const UserstoryModalTask({
    super.key,
    required this.userstoryId,
  });
  final int userstoryId;

  @override
  State<UserstoryModalTask> createState() => _UserstoryModalTaskState();
}

class _UserstoryModalTaskState extends State<UserstoryModalTask> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _navigator = Navigator.of(context);
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        final _project = state.projects.firstWhere(
            (project) =>
                project.userstories.firstWhere(
                    (userstory) => userstory.id == widget.userstoryId,
                    orElse: () => Userstory.empty) !=
                Userstory.empty,
            orElse: () => Project.empty);
        final _userstory = _project.userstories.firstWhere(
            (userstory) => userstory.id == widget.userstoryId,
            orElse: () => Userstory.empty);

        return Scaffold(
          appBar: AppBar(
            title: Text('Manage Tasks'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ElevatedButton(
                  //     onPressed: () {
                  //       // showDialog(
                  //       //   context: context,
                  //       //   builder: (context) => UserstoryModalStatusNew(
                  //       //     projectId: _project.id,
                  //       //   ),
                  //       // );
                  //     },
                  //     child: Text('Add New Task')),
                  Expanded(
                    child: ReorderableListView(
                      // shrinkWrap: true,
                      children: <Widget>[
                        ..._userstory.tasks.map(
                          (task) => Card(
                            key: ValueKey('${task.id}'),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    margin: EdgeInsets.zero,
                                    color: Colors.blue,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Text(
                                        '${task.status.title}',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text('${task.title}'),
                                ],
                              ),
                              // subtitle: Card(
                              //   margin: EdgeInsets.zero,
                              //   color: Colors.blue,
                              //   child: Padding(
                              //     padding: const EdgeInsets.symmetric(
                              //         horizontal: 4.0),
                              //     child: Text(
                              //       '${task.status.title}',
                              //       style: TextStyle(
                              //         color: Theme.of(context)
                              //             .colorScheme
                              //             .onPrimary,
                              //         fontSize: 12,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // trailing: Row(
                              //   mainAxisSize: MainAxisSize.min,
                              //   children: [
                              //     IconButton(
                              //       onPressed: () {
                              //         // showDialog(
                              //         //   context: context,
                              //         //   builder: (context) =>
                              //         //       UserstoryModalStatusEdit(
                              //         //     projectId: _project.id,
                              //         //     statusId: status.id,
                              //         //   ),
                              //         // );
                              //       },
                              //       icon: Icon(
                              //         Icons.edit,
                              //         color: Colors.blueGrey,
                              //       ),
                              //     ),
                              //     IconButton(
                              //       onPressed: () {
                              //         // showDialog(
                              //         //   context: context,
                              //         //   builder: (context) =>
                              //         //       UserstoryModalStatusDelete(
                              //         //     projectId: _project.id,
                              //         //     statusId: status.id,
                              //         //   ),
                              //         // );
                              //       },
                              //       icon: Icon(
                              //         Icons.delete,
                              //         color: Colors.red,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ),
                          ),
                        )
                      ],
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          // _project.statuses.insert(
                          //     newIndex, _project.statuses.removeAt(oldIndex));
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// class UserstoryModalStatusNew extends StatefulWidget {
//   const UserstoryModalStatusNew({
//     super.key,
//     required this.projectId,
//   });

//   final int projectId;

//   @override
//   State<UserstoryModalStatusNew> createState() =>
//       _UserstoryModalStatusNewState();
// }

// class _UserstoryModalStatusNewState extends State<UserstoryModalStatusNew> {
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final _navigator = Navigator.of(context);
//     return BlocBuilder<ProjectBloc, ProjectState>(
//       builder: (context, state) {
//         final _project = state.projects
//             .firstWhere((project) => project.id == widget.projectId);
//         final _controller = <String, TextEditingController>{
//           'title': TextEditingController(),
//         };

//         return AlertDialog(
//           title: Text('New Status'),
//           content: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextFormField(
//                     controller: _controller['title'],
//                     decoration: InputDecoration(
//                       labelText: "Title",
//                       isDense: true,
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 final isValid = _formKey.currentState!.validate();
//                 if (isValid) {
//                   final updatedStatus =
//                       Status(-1, title: _controller['title']!.text);
//                   _project.updateStatus(updatedStatus);
//                   _project.reorderStatuses();
//                   context.read<ProjectBloc>()
//                     ..add(ProjectStatusChanged(ProjectStatus.loading))
//                     ..add(ProjectStatusChanged(ProjectStatus.ready));

//                   _navigator.pop();
//                 }
//               },
//               child: Text("Save"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _navigator.pop();
//               },
//               child: Text("Close"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class UserstoryModalStatusEdit extends StatefulWidget {
//   const UserstoryModalStatusEdit({
//     super.key,
//     required this.projectId,
//     required this.statusId,
//   });

//   final int projectId;
//   final int statusId;

//   @override
//   State<UserstoryModalStatusEdit> createState() =>
//       _UserstoryModalStatusEditState();
// }

// class _UserstoryModalStatusEditState extends State<UserstoryModalStatusEdit> {
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final _navigator = Navigator.of(context);
//     return BlocBuilder<ProjectBloc, ProjectState>(
//       builder: (context, state) {
//         final _project = state.projects
//             .firstWhere((project) => project.id == widget.projectId);
//         final _status = _project.statuses
//             .firstWhere((status) => status.id == widget.statusId);
//         final _controller = <String, TextEditingController>{
//           'title': TextEditingController.fromValue(
//               TextEditingValue(text: _status.title)),
//         };

//         return AlertDialog(
//           title: Text('Edit Status'),
//           content: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextFormField(
//                     controller: _controller['title'],
//                     decoration: InputDecoration(
//                       labelText: "Title",
//                       isDense: true,
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 final isValid = _formKey.currentState!.validate();
//                 if (isValid) {
//                   final updatedStatus = Status(widget.statusId,
//                       title: _controller['title']!.text);
//                   _project.updateStatus(updatedStatus);
//                   _project.reorderStatuses();
//                   context.read<ProjectBloc>()
//                     ..add(ProjectStatusChanged(ProjectStatus.loading))
//                     ..add(ProjectStatusChanged(ProjectStatus.ready));

//                   _navigator.pop();
//                 }
//               },
//               child: Text("Save"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _navigator.pop();
//               },
//               child: Text("Close"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class UserstoryModalStatusDelete extends StatefulWidget {
//   const UserstoryModalStatusDelete({
//     super.key,
//     required this.projectId,
//     required this.statusId,
//   });

//   final int projectId;
//   final int statusId;

//   @override
//   State<UserstoryModalStatusDelete> createState() =>
//       _UserstoryModalStatusDeleteState();
// }

// class _UserstoryModalStatusDeleteState
//     extends State<UserstoryModalStatusDelete> {
//   @override
//   Widget build(BuildContext context) {
//     final _navigator = Navigator.of(context);
//     return BlocBuilder<ProjectBloc, ProjectState>(
//       builder: (context, state) {
//         final _project = state.projects.firstWhere(
//             (project) => project.id == widget.projectId,
//             orElse: () => Project.empty);
//         final _status = _project.statuses.firstWhere(
//             (status) => status.id == widget.statusId,
//             orElse: () => Status.empty);
//         return AlertDialog(
//           title: Text('${_status.title}'),
//           content: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 4.0),
//               child: Text('Are you sure you want to delete this status?')),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 _navigator.pop();
//                 _project.removeStatus(_status.id);
//                 _project.reorderStatuses();
//                 context.read<ProjectBloc>()
//                   ..add(ProjectStatusChanged(ProjectStatus.loading))
//                   ..add(ProjectStatusChanged(ProjectStatus.ready));
//               },
//               child: Text("Delete"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _navigator.pop();
//               },
//               child: Text("Cancel"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
