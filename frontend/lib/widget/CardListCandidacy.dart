import 'package:doit/model/Candidacy.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/providers/CandidacyProvider.dart';
import 'package:doit/providers/ProjectProvider.dart';

import 'package:doit/widget/CandidacyOverView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardListCandidacy extends StatefulWidget {
  final String id;

  const CardListCandidacy({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  _CardListCandidacy createState() => _CardListCandidacy();
}

class _CardListCandidacy extends State<CardListCandidacy> {
  Widget build(BuildContext context) {
    Candidacy candidacy =
        context.watch<CandidacyProvider>().findById(widget.id);
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
      onTap: () => {
        showDialog(
            context: context,
            builder: (context) {
              return CandidacyOverView(
                candidacy: candidacy,
              );
            })
      },
    );
  }
}
