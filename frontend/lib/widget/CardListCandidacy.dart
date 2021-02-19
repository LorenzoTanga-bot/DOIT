import 'package:doit/model/Candidacy.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ProjectOverView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardListCandidacy extends StatelessWidget {
  final Candidacy candidacy;

  const CardListCandidacy({
    Key key,
    @required this.candidacy,
  }) : super(key: key);

  Widget build(BuildContext context) {
    String state = candidacy.getState().toString();
    state = state.substring(state.indexOf(".") + 1);
    DateTime date = DateTime.parse(candidacy.getDateOfCandidacy());
    String dateString =
        "${date.day}" + "/" + "${date.month}" + "/" + "${date.year}";
    Project project =
        context.read<ProjectProvider>().findById(candidacy.getProject());
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
                title: Text("project : " + project.getName()),
                subtitle: Text("sent : " + dateString),
                trailing: Text(state)),
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
