import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_repository/project_repository.dart';
import 'package:sagile_mobile/authentication/authentication.dart';
import 'package:sagile_mobile/dashboard/cubit/dashboard_cubit.dart';
import 'package:sagile_mobile/home/view/custom_widgets.dart';
import 'package:sagile_mobile/project/bloc/project_bloc.dart';
// import 'package:sagile_mobile_main/models/model.dart';
// import 'package:sagile_mobile_main/pages/custom_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SingleSection(
                      title: "Profile",
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0),
                          child: Divider(),
                        ),
                        ListTile(
                          leading: Container(
                            width: 48,
                            height: 48,
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            alignment: Alignment.center,
                            child: const Icon(Icons.numbers),
                          ),
                          title: Builder(
                            builder: (context) {
                              final id = context.select(
                                (AuthenticationBloc bloc) => bloc.state.user.id,
                              );
                              return Text('$id');
                            },
                          ),
                          dense: false,
                        ),
                        ListTile(
                          leading: Container(
                            width: 48,
                            height: 48,
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            alignment: Alignment.center,
                            child: const Icon(Icons.account_circle),
                          ),
                          title: Builder(
                            builder: (context) {
                              final username = context.select(
                                (AuthenticationBloc bloc) =>
                                    bloc.state.user.username,
                              );
                              return Text('$username');
                            },
                          ),
                          dense: false,
                        ),
                        ListTile(
                          leading: Container(
                            width: 48,
                            height: 48,
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            alignment: Alignment.center,
                            child: const Icon(Icons.email),
                          ),
                          title: Builder(
                            builder: (context) {
                              final email = context.select(
                                (AuthenticationBloc bloc) =>
                                    bloc.state.user.email,
                              );
                              return Text('$email');
                            },
                          ),
                          dense: false,
                        ),
                        ListTile(
                          leading: Container(
                            width: 48,
                            height: 48,
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            alignment: Alignment.center,
                            child: const Icon(Icons.account_circle_outlined),
                          ),
                          title: Builder(
                            builder: (context) {
                              final name = context.select(
                                (AuthenticationBloc bloc) =>
                                    bloc.state.user.name,
                              );
                              return Text('$name');
                            },
                          ),
                          dense: false,
                        ),
                        // ListTile(
                        //   title: ElevatedButton(
                        //     child: const Text('Logout'),
                        //     onPressed: () {
                        //       context
                        //           .read<AuthenticationBloc>()
                        //           .add(AuthenticationLogoutRequested());
                        //     },
                        //   ),
                        //   dense: false,
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SingleSection(
                      title: "Settings",
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0),
                          child: Divider(),
                        ),
                        // CustomListTile(
                        //   onTap: () {},
                        //   title: "Dark Mode",
                        //   icon: Icons.dark_mode_outlined,
                        //   trailing: Switch(
                        //     value: context.read<CurrentUser>().settings.isDark,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         Provider.of<CurrentUser>(context, listen: false)
                        //             .updateSettings(Settings(isDark: value));
                        //       });
                        //     },
                        //   ),
                        // ),
                        // CustomListTile(
                        //     onTap: () {
                        //       context
                        //           .read<AuthenticationBloc>()
                        //           .add(AuthenticationLogoutRequested());
                        //     },
                        //     title: "Sign out",
                        //     icon: Icons.exit_to_app_rounded),
                        ListTile(
                          title: ElevatedButton(
                            child: const Text('Logout'),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => ConfirmationDialog(
                                  title: "Log Out",
                                  content: "Are you sure you want to log out?",
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        context.read<DashboardCubit>().reset();
                                        context.read<ProjectBloc>().add(
                                            ProjectStatusChanged(
                                                ProjectStatus.uninitialized));
                                        context.read<AuthenticationBloc>().add(
                                            AuthenticationLogoutRequested());
                                      },
                                      child: Text("Yes"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          dense: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key, this.title, this.content, this.actions});
  final title, content, actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions,
    );
  }
}
