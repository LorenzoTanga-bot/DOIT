import 'package:doit/model/Project.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ProjectOverView.dart';
import 'package:doit/widget/CardList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfProjects extends StatelessWidget {
  final List<Project> projects;
  const ListOfProjects({Key key, @required this.projects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<GestureDetector> _cardsWithTap = [];
    for (Project item in projects) {
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
