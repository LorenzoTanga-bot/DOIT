import 'package:doit/model/Project.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ProjectOverView.dart';
import 'package:doit/widget/CardList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfProjects extends StatefulWidget {
  @override
  _ListOfProjects createState() => _ListOfProjects();
}

class _ListOfProjects extends State<ListOfProjects> {
  List<Project> _allProject;
  List<GestureDetector> _cardsWithTap = [];

  @override
  Widget build(BuildContext context) {
    _allProject = context.watch<ProjectProvider>().getListAllProject();
    for (Project item in _allProject) {
      _cardsWithTap.add(GestureDetector(
        child: CardList(
            name: item.getName(), sDescription: item.getShortDescription()),
        onTap: () {
          Provider.of<ViewProvider>(context, listen: false)
              .pushWidget(ProjectOverView(id: item.getId()));
        },
      ));
    }
    return ListView(
      children: _cardsWithTap,
    );
  }
}
