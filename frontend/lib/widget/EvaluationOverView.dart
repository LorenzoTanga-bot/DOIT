import 'package:doit/model/Evaluation.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ProjectOverView.dart';
import 'package:doit/widget/FutureBuilder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EvaluationOverView extends StatefulWidget {
  final Evaluation evaluation;

  const EvaluationOverView({Key key, @required this.evaluation})
      : super(key: key);

  @override
  _EvaluationOverView createState() => _EvaluationOverView();
}

class _EvaluationOverView extends State<EvaluationOverView> {
  Project project;

  String state;
  User user;
  void initState() {
    super.initState();
    project = Provider.of<ProjectProvider>(context, listen: false)
        .findById(widget.evaluation.getProject());
    state = widget.evaluation.getEvaluationMode().toString();
    state = state.substring(state.indexOf(".") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Text("Evaluation"),
        content:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text("Project: "),
            RichText(
                text: TextSpan(
                    text: (project.getName()),
                    style: TextStyle(color: Colors.black),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pop(context);
                        List<String> users = [project.getProjectProposer()];
                        users.addAll(project.getDesigners());
                        context.read<ViewProvider>().pushWidget(FutureBuild(
                            future: Future.wait([
                              Provider.of<UserProvider>(context, listen: false)
                                  .updateListUsers(users),
                              Provider.of<TagProvider>(context, listen: false)
                                  .updateListTag(project.getTag())
                            ]),
                            newView: ProjectOverView(
                              id: project.getId(),
                            )));
                      }))
          ]),
          Divider(
            color: Colors.white,
            height: 10,
            thickness: 1,
            indent: 2,
            endIndent: 2,
          ),
           Text("Evaluation for : "+ state),
            Divider(
            color: Colors.white,
            height: 10,
            thickness: 1,
            indent: 2,
            endIndent: 2,
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Message : "),
            Flexible(
                child: Text(
              widget.evaluation.getMessage(),
            ))
          ]),
        ]));
  }
}
