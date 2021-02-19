import 'package:doit/model/Project.dart';

import 'package:doit/widget/CardListProject.dart';
import 'package:flutter/material.dart';


class ListProjects extends StatelessWidget {
  final List<Project> projects;
  const ListProjects({Key key, @required this.projects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return CardListProject(project: projects[index]);
        });
  }
}
