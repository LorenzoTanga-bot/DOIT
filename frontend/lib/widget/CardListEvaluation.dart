import 'package:doit/model/Evaluation.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/providers/EvaluationProvider.dart';
import 'package:doit/providers/ProjectProvider.dart';

import 'package:doit/widget/EvaluationOverView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardListEvaulation extends StatefulWidget {
  final String id;

  const CardListEvaulation({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  _CardListEvaulation createState() => _CardListEvaulation();
}

class _CardListEvaulation extends State<CardListEvaulation> {
  Widget build(BuildContext context) {
    Evaluation evaluation =
        context.watch<EvaluationProvider>().findById(widget.id);
    String state = evaluation.getEvaluationMode().toString();
    state = state.substring(state.indexOf(".") + 1);
    Project project =
        context.read<ProjectProvider>().findById(evaluation.getProject());
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
                subtitle: Text(
                  "evaluation : " + evaluation.getMessage(),
                  maxLines: 2,
                ),
                trailing: Text(state)),
          ],
        ),
      ),
      onTap: () => {
        showDialog(
            context: context,
            builder: (context) {
              return EvaluationOverView(
                evaluation: evaluation,
              );
            })
      },
    );
  }
}
