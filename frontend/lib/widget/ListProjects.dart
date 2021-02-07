import 'package:doit/model/Project.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ProjectOverView.dart';
import 'package:doit/widget/CardListProject.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListProjects extends StatelessWidget {
  final List<Project> projects;
  const ListProjects({Key key, @required this.projects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              child: CardListProject(
                  project: projects[index]),
              onTap: () {
                Provider.of<ViewProvider>(context, listen: false)
                    .pushWidget(ProjectOverView(id: projects[index].getId()));
              });
        });
  }
}
