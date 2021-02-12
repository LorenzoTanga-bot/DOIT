import 'package:doit/model/Project.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ProjectOverView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardListProject extends StatelessWidget {
  final Project project;

  const CardListProject({
    Key key,
    this.project,
  }) : super(key: key);

  String _determinateState() {
    return (DateTime.parse(project.getDateOfEnd()).compareTo(DateTime.now()) ==
            1)
        ? (project.getCandidacyMode() ? "Candidacy Mode" : "In corso")
        : "Completato";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(project.getName()),
              subtitle: Text(project.getShortDescription()),
              trailing: Text(_determinateState()),
            ),
          ],
        ),
      ),
      onTap: () {
        Provider.of<ViewProvider>(context, listen: false)
            .pushWidget(ProjectOverView(project: project));
      },
    );
  }
}
