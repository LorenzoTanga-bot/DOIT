import 'package:doit/model/Evaluation.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/EvaluationProvider.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/widget/ErrorPopUp.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendEvaluation extends StatefulWidget {
  final String id;
  final BuildContext context;
  const SendEvaluation({Key key, @required this.id, @required this.context})
      : super(key: key);

  @override
  _SendEvaluation createState() => _SendEvaluation();
}

class _SendEvaluation extends State<SendEvaluation> {
  Project _project;
  TextEditingController _message = TextEditingController();
  bool evaluatedTeam;
  int group = 1;

  void createEvaluation(BuildContext context) async {
    Evaluation evaluation = new Evaluation();
    evaluation
        .setSender(context.read<AuthCredentialProvider>().getUser().getMail());
    evaluation.setMessage(_message.text);

    if (evaluatedTeam)
      evaluation.setEvaluationMode(EvaluationMode.TEAM);
    else
      evaluation.setEvaluationMode(EvaluationMode.PROJECT);
    evaluation.setProject(_project.getId());
    try {
      await Provider.of<EvaluationProvider>(context, listen: false)
          .addEvaluation(evaluation);

      await Provider.of<ProjectProvider>(context, listen: false)
          .reloadProject(_project.getId());
      await Provider.of<UserProvider>(context, listen: false).reloadUser(
          context.read<AuthCredentialProvider>().getUser().getMail());
      Navigator.pop(context);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return ErrorPopup(message: e.toString());
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (group == 0)
      evaluatedTeam = true;
    else
      evaluatedTeam = false;
    _project = context.watch<ProjectProvider>().findById(widget.id);
    context = widget.context;
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Text("do you want to evaluate the team or the project? "),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (checkAlreadySended(EvaluationMode.TEAM) &&
                    _project.getDesigners().isNotEmpty)
                  Text(
                    "Team",
                    style: TextStyle(fontSize: 17),
                  ),
                if (checkAlreadySended(EvaluationMode.TEAM) &&
                    _project.getDesigners().isNotEmpty)
                  Radio(
                      value: 0,
                      groupValue: group,
                      onChanged: (value) {
                        setState(() {
                          evaluatedTeam = true;
                          group = value;
                        });
                      }),
                if (checkAlreadySended(EvaluationMode.PROJECT))
                  Text("Project", style: TextStyle(fontSize: 17)),
                if (checkAlreadySended(EvaluationMode.PROJECT))
                  Radio(
                    value: 1,
                    groupValue: group,
                    onChanged: (value) {
                      setState(() {
                        evaluatedTeam = false;
                        group = value;
                      });
                    },
                  ),
              ],
            ),
            if (!evaluatedTeam)
              TextField(
                  controller: _message,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Inser a evaluation for the  project ",
                  )),
            if (evaluatedTeam)
              TextField(
                  controller: _message,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Inser a evaluation for the team ",
                  )),
            Divider(
              color: Colors.white,
              height: 20,
              thickness: 1,
              indent: 2,
              endIndent: 2,
            ),
            if (!evaluatedTeam)
              Text(
                  "are you sure you want to submit a evaluation for the project " +
                      _project.getName() +
                      "?"),
            if (evaluatedTeam)
              Text("are you sure you want to submit a evaluation to the " +
                  _project.getName() +
                  " project team ?"),
            Divider(
              color: Colors.white,
              height: 20,
              thickness: 1,
              indent: 2,
              endIndent: 2,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              OutlinedButton(
                onPressed: () => {Navigator.pop(context)},
                child: Text("Back"),
              ),
              OutlinedButton(
                onPressed: () => {
                  createEvaluation(context),
                },
                child: Text("Evaluate"),
              )
            ])
          ],
        ));
  }

  bool checkAlreadySended(EvaluationMode evaluationMode) {
    List<Evaluation> alreadySended =
        Provider.of<EvaluationProvider>(context, listen: false)
            .findSendedEvaluation(
                Provider.of<AuthCredentialProvider>(context, listen: false)
                    .getUser()
                    .getMail());

    if (alreadySended
        .where((element) => ((element.getProject() == _project.getId()) &&
            (element.getEvaluationMode() == evaluationMode)))
        .isEmpty)
      return true;
    else
      return false;
  }
}
