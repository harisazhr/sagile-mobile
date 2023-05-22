import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_repository/project_repository.dart';
import 'package:sagile_mobile/project/bloc/project_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sagile_mobile/authentication/authentication.dart';
// import 'package:sagile_mobile/home/view/custom_widgets.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ProjectPage());
  }

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<ProjectBloc, ProjectState>(
          listener: (context, state) {
            switch (state.status) {
              case ProjectStatus.uninitialized:
                context
                    .read<ProjectBloc>()
                    .add(ProjectStatusChanged(ProjectStatus.loaded));
                break;
              case ProjectStatus.loaded:
              case ProjectStatus.error:
                break;
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case ProjectStatus.uninitialized:
                return CircularProgressIndicator();
              case ProjectStatus.loaded:
                return Text('loaded');
              case ProjectStatus.error:
                return Text('error');
            }
          },
        ),
      ),
    );
    // return Scaffold(
    //   body: Container(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Card(
    //           child: Container(
    //             padding: const EdgeInsets.all(8.0),
    //             child: ListView(
    //               shrinkWrap: true,
    //               children: [
    //                 SingleSection(
    //                   title: "Projects",
    //                   children: [
    //                     const Padding(
    //                       padding: EdgeInsets.symmetric(horizontal: 32.0),
    //                       child: Divider(),
    //                     ),
    //                     ...projects
    //                         .map(
    //                           (e) => Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: MaterialButton(
    //                               shape: RoundedRectangleBorder(
    //                                 borderRadius: BorderRadius.circular(10),
    //                                 side: BorderSide(
    //                                   color: Theme.of(context)
    //                                       .colorScheme
    //                                       .onSurface,
    //                                 ),
    //                               ),
    //                               onPressed: () {},
    //                               child: ListTile(
    //                                 title: Padding(
    //                                   padding: const EdgeInsets.symmetric(
    //                                       vertical: 16.0),
    //                                   child: Text(
    //                                     '${e.title}',
    //                                     style: TextStyle(
    //                                       fontSize: 16,
    //                                       fontWeight: FontWeight.bold,
    //                                     ),
    //                                   ),
    //                                 ),
    //                                 trailing: Row(
    //                                   mainAxisSize: MainAxisSize.min,
    //                                   children: [
    //                                     IconButton(
    //                                       onPressed: () {},
    //                                       icon: Icon(Icons.delete),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         )
    //                         .toList(),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
