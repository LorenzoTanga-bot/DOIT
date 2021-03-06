import 'package:doit/model/Candidacy.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/CandidacyProvider.dart';
import 'package:doit/providers/EvaluationProvider.dart';

import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ProfileOverView.dart';

import 'package:doit/view/ProjectOverView.dart';
import 'package:doit/widget/FutureBuilder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CandidacyOverView extends StatefulWidget {
  final Candidacy candidacy;

  const CandidacyOverView({Key key, @required this.candidacy})
      : super(key: key);

  @override
  _CandidacyOverView createState() => _CandidacyOverView();
}

class _CandidacyOverView extends State<CandidacyOverView> {
  Project project;
  String dateString;
  String dateOfExpireString;
  String state;
  User user;
  void initState() {
    super.initState();
    project = context
        .watch<ProjectProvider>()
        .findById(widget.candidacy.getProject());
    state = widget.candidacy.getState().toString();
    state = state.substring(state.indexOf(".") + 1);
    DateTime date = DateTime.parse(widget.candidacy.getDateOfCandidacy());
    dateString = "${date.day}" + "/" + "${date.month}" + "/" + "${date.year}";
    DateTime dateOfExpire = DateTime.parse(widget.candidacy.getDateOfExpire());
    dateOfExpireString = "${dateOfExpire.day}" +
        "/" +
        "${dateOfExpire.month}" +
        "/" +
        "${dateOfExpire.year}";
  }

  bool isTheProjectProposer() {
    if (widget.candidacy.getState() == StateCandidacy.WAITING) {
      User user = context.read<AuthCredentialProvider>().getUser();
      if (user == null) return false;
      return widget.candidacy.getProjectProposer() == user.getMail();
    }
    return false;
  }

  void acceptCandidacy(BuildContext context) async {
    widget.candidacy.setState(StateCandidacy.POSITIVE);
    await Provider.of<CandidacyProvider>(context, listen: false)
        .updateCandidacy(widget.candidacy);
    await Provider.of<UserProvider>(context, listen: false)
        .reloadUser(widget.candidacy.getDesigner());
    await Provider.of<ProjectProvider>(context, listen: false)
        .reloadProject(widget.candidacy.getProject());
  }

  void declineCandidacy(BuildContext context) async {
    widget.candidacy.setState(StateCandidacy.NEGATIVE);
    await Provider.of<CandidacyProvider>(context, listen: false)
        .updateCandidacy(widget.candidacy);
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
            padding: EdgeInsets.only(right: 15),
            child: Align(
                alignment: Alignment.bottomRight,
                child: OutlinedButton(
                  onPressed: () =>
                      {acceptCandidacy(context), Navigator.pop(context)},
                  child: Text("Accetta"),
                ))),
        Padding(
            padding: EdgeInsets.only(right: 15),
            child: Align(
                alignment: Alignment.bottomRight,
                child: OutlinedButton(
                  onPressed: () =>
                      {declineCandidacy(context), Navigator.pop(context)},
                  child: Text("Rifiuta"),
                ))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Text("Candidacy"),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .updateListUsers(users),
                                  Provider.of<TagProvider>(context,
                                          listen: false)
                                      .updateListTag(project.getTag()),
                                  Provider.of<EvaluationProvider>(context,
                                          listen: false)
                                      .findByProject(project.getId())
                                ]),
                                newView: ProjectOverView(
                                  project: project,
                                )));
                          }))
              ]),
              Divider(
                color: Colors.white,
                height: 8,
                thickness: 1,
                indent: 2,
                endIndent: 2,
              ),
              Row(children: [
                Text("Sender: "),
                RichText(
                    text: TextSpan(
                        text: (widget.candidacy.getProjectProposer()),
                        style: TextStyle(color: Colors.black),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                            user = Provider.of<UserProvider>(context,
                                    listen: false)
                                .findByMail(
                                    widget.candidacy.getProjectProposer());
                            Provider.of<ViewProvider>(context, listen: false)
                                .pushWidget(FutureBuild(
                                    future: Future.wait([
                                      Provider.of<ProjectProvider>(context,
                                              listen: false)
                                          .findByProjectProposer(
                                              user.getMail()),
                                      Provider.of<ProjectProvider>(context,
                                              listen: false)
                                          .findByDesigner(
                                              user.getMail()),
                                      Provider.of<TagProvider>(context,
                                              listen: false)
                                          .updateListTag(user.getTags())
                                    ]),
                                    newView: ProfileOverView(user: user)));
                          }))
              ]),
              Divider(
                color: Colors.white,
                height: 8,
                thickness: 1,
                indent: 2,
                endIndent: 2,
              ),
              Row(children: [
                Text("Receiver: "),
                RichText(
                    text: TextSpan(
                        text: (widget.candidacy.getDesigner()),
                        style: TextStyle(color: Colors.black),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                            user = Provider.of<UserProvider>(context,
                                    listen: false)
                                .findByMail(widget.candidacy.getDesigner());
                            Provider.of<ViewProvider>(context, listen: false)
                                .pushWidget(FutureBuild(
                                    future: Future.wait([
                                      Provider.of<ProjectProvider>(context,
                                              listen: false)
                                          .findByProjectProposer(
                                              user.getMail()),
                                      Provider.of<ProjectProvider>(context,
                                              listen: false)
                                          .findByDesigner(
                                              user.getMail()),
                                      Provider.of<TagProvider>(context,
                                              listen: false)
                                          .updateListTag(user.getTags())
                                    ]),
                                    newView: ProfileOverView(user: user)));
                          }))
              ]),
              Divider(
                color: Colors.white,
                height: 8,
                thickness: 1,
                indent: 2,
                endIndent: 2,
              ),
              Divider(
                color: Colors.white,
                height: 8,
                thickness: 1,
                indent: 2,
                endIndent: 2,
              ),
              Text("Date of send  : $dateString"),
              Divider(
                color: Colors.white,
                height: 8,
                thickness: 1,
                indent: 2,
                endIndent: 2,
              ),
              Text("State : $state"),
              Divider(
                color: Colors.white,
                height: 8,
                thickness: 1,
                indent: 2,
                endIndent: 2,
              ),
              if (widget.candidacy.getMessage() != null)
                Column(
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Message : "),
                          Flexible(
                              child: Text(
                            widget.candidacy.getMessage(),
                          ))
                        ]),
                    Divider(
                      color: Colors.white,
                      height: 8,
                      thickness: 1,
                      indent: 2,
                      endIndent: 2,
                    ),
                  ],
                ),
              Text("Date of Expire : $dateOfExpireString "),
              Divider(
                color: Colors.white,
                height: 8,
                thickness: 1,
                indent: 2,
                endIndent: 2,
              )
            ],
          ),
          if (isTheProjectProposer()) showButton(),
          Divider(
            color: Colors.white,
            height: 8,
            thickness: 1,
            indent: 2,
            endIndent: 2,
          )
        ]));
  }
}
