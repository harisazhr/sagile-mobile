import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sagile_mobile/project/project.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({super.key});

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        switch (state.status) {
          case ProjectStateList.failure:
            return const Center(child: Text('failed to fetch posts'));
          case ProjectStateList.success:
            if (state.projects.isEmpty) {
              return const Center(child: Text('no projects'));
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.projects.length
                    ? const BottomLoader()
                    : ProjectListItem(post: state.projects[index]);
              },
              itemCount: state.hasReachedMax
                  ? state.projects.length
                  : state.projects.length + 1,
              controller: _scrollController,
            );
          case ProjectStateList.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<ProjectBloc>().add(ProjectFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
