import 'package:doit/model/Project.dart';
import 'package:doit/providers/CandidacyProvider.dart';
import 'package:doit/providers/EvaluationProvider.dart';
import 'package:doit/providers/InviteProvider.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ProjectOverView.dart';
import 'package:doit/widget/FutureBuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardListProject extends StatefulWidget {
  final String id;

  const CardListProject({
    Key key,
    this.id,
  }) : super(key: key);

  @override
  _CardListProject createState() => _CardListProject();
}

class _CardListProject extends State<CardListProject> {
  Project project;
  String _determinateState() {
    return (DateTime.parse(project.getDateOfEnd()).compareTo(DateTime.now()) ==
            -1)
        ? "Completed"
        : (project.getCandidacyMode()
            ? "Candidacy Mode"
            : (DateTime.parse(project.getStartCandidacy())
                    .isAfter(DateTime.now())
                ? "Waiting for opening\nof candidacy"
                : "In progress"));
  }

  @override
  Widget build(BuildContext context) {
    project = context.watch<ProjectProvider>().findById(widget.id);
    return GestureDetector(
      child: Card(
        elevation: 4,
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
        List<String> users = [project.getProjectProposer()];

        users.addAll(project.getDesigners());
        Provider.of<ViewProvider>(context, listen: false)
            .pushWidget(FutureBuild(
                future: Future.wait([
                  Provider.of<UserProvider>(context, listen: false)
                      .updateListUsers(users),
                  Provider.of<TagProvider>(context, listen: false)
                      .updateListTag(project.getTag()),
                  Provider.of<EvaluationProvider>(context, listen: false)
                      .findByProject(project.getId()),
                  Provider.of<CandidacyProvider>(context, listen: false)
                      .findByProject(project.getId()),
                  Provider.of<InviteProvider>(context, listen: false)
                      .findByProject(project.getId())
                ]),
                newView: ProjectOverView(
                  project: project.getId(),
                )));
      },
    );
  }
}
