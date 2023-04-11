import 'package:flutter/material.dart';
import 'package:sagile_mobile/project/project.dart';

class ProjectListItem extends StatelessWidget {
  const ProjectListItem({super.key, required this.post});

  final Project post;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: ListTile(
        leading: Text('${post.id}', style: textTheme.bodySmall),
        title: Text(post.title),
        isThreeLine: true,
        subtitle: Text(post.body),
        dense: true,
      ),
    );
  }
}
