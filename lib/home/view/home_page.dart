import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sagile_mobile/authentication/authentication.dart';
import 'package:sagile_mobile/home/view/custom_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

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
                      title: "Home",
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
                              final userid = context.select(
                                (AuthenticationBloc bloc) => bloc.state.user.id,
                              );
                              return Text('$userid');
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
                          // title: Text('username'),
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
                            child: const Icon(Icons.password),
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
                          title: ElevatedButton(
                            child: const Text('Logout'),
                            onPressed: () {
                              context
                                  .read<AuthenticationBloc>()
                                  .add(AuthenticationLogoutRequested());
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
