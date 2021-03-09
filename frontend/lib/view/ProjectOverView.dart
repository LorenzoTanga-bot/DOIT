import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/model/Tag.dart';
import 'package:doit/model/User.dart';
import 'package:doit/model/Evaluation.dart';

import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/CandidacyProvider.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/providers/EvaluationProvider.dart';

import 'package:doit/view/ProfileOverView.dart';
import 'package:doit/view/projectproposer/CreateModifyProject.dart';

import 'package:doit/widget/FutureBuilder.dart';
import 'package:doit/widget/ListEvaluations.dart';
import 'package:doit/widget/ListTags.dart';
import 'package:doit/widget/SendCandidacy.dart';
import 'package:doit/widget/SendEvaluation.dart';
import 'package:doit/widget/SendInvite.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectOverView extends StatefulWidget {
  final String project;

  const ProjectOverView({
    Key key,
    @required this.project,
  }) : super(key: key);

  @override
  _ProjectOverView createState() => _ProjectOverView();
}

class _ProjectOverView extends State<ProjectOverView> {
  User _projectProposer;
  Project _project;
  List<Tag> _listTags;
  String _state;
  List<User> _designers;
  List<Evaluation> _projectEvaluations;
  List<Evaluation> _teamEvaluations;

  void init() {
    _project = context.watch<ProjectProvider>().findById(widget.project);
    _projectProposer =
        context.watch<UserProvider>().findByMail(_project.getProjectProposer());
    _listTags = context.watch<TagProvider>().getTagsByIds(_project.getTag());
    _designers =
        context.watch<UserProvider>().findByMails(_project.getDesigners());
    _projectEvaluations = context
        .watch<EvaluationProvider>()
        .findReceivedEvaluationForProject(_project.getId());
    _teamEvaluations = context
        .watch<EvaluationProvider>()
        .findReceivedEvaluationForTeamOfProject(_project.getId());
    _state =
        (DateTime.parse(_project.getDateOfEnd()).compareTo(DateTime.now()) ==
                -1)
            ? "Completed"
            : (_project.getCandidacyMode()
                ? "Candidacy Mode"
                : (DateTime.parse(_project.getStartCandidacy())
                        .isAfter(DateTime.now())
                    ? "In attesa di apertura candidature"
                    : "In corso"));
  }

  String _getDate(String type) {
    DateTime date;
    switch (type) {
      case "dStart":
        date = DateTime.parse(_project.getDateOfStart());
        break;
      case "dEnd":
        date = DateTime.parse(_project.getDateOfEnd());
        break;
      case "cStart":
        date = DateTime.parse(_project.getStartCandidacy());
        break;
      case "cEnd":
        date = DateTime.parse(_project.getEndCandidacy());
    }
    return "${date.day} / ${date.month} / ${date.year}";
  }

  Widget _firstCard() {
    return Column(
      children: [
        if (isTheProjectProposer())
          Padding(
              padding: EdgeInsets.only(right: 15, top: 10),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    iconSize: 30,
                    color: Colors.blue,
                    icon: Icon(Icons.border_color),
                    onPressed: () => {
                      Provider.of<ViewProvider>(context, listen: false)
                          .pushWidget(CreateModifyProject(
                        id: widget.project,
                      ))
                    },
                  ))),
        Card(
            margin: EdgeInsets.all(15),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _project.getName(),
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      color: Colors.white,
                      height: 5,
                      thickness: 1,
                      indent: 2,
                      endIndent: 2,
                    ),
                    Row(children: [
                      Text("Project proposer : "),
                      RichText(
                          text: TextSpan(
                              text: (_projectProposer.getUsername()),
                              style: TextStyle(color: Colors.black),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Provider.of<ViewProvider>(context,
                                          listen: false)
                                      .pushWidget(FutureBuild(
                                          future: Future.wait([
                                            Provider.of<ProjectProvider>(
                                                    context,
                                                    listen: false)
                                                .findByProjectProposer(
                                                    _projectProposer.getMail()),
                                            Provider.of<ProjectProvider>(
                                                    context,
                                                    listen: false)
                                                .findByDesigner(
                                                    _projectProposer.getMail()),
                                            Provider.of<TagProvider>(context,
                                                    listen: false)
                                                .updateListTag(
                                                    _projectProposer.getTags())
                                          ]),
                                          newView: ProfileOverView(
                                              user:
                                                  _projectProposer.getMail())));
                                }))
                    ]),
                    Divider(
                      color: Colors.white,
                      height: 5,
                      thickness: 1,
                      indent: 2,
                      endIndent: 2,
                    ),
                    Text("State : $_state"),
                    Divider(
                      color: Colors.white,
                      height: 5,
                      thickness: 1,
                      indent: 2,
                      endIndent: 2,
                    ),
                    Text("Date : ${_getDate("dStart")} - ${_getDate("dEnd")}"),
                    Divider(
                      color: Colors.white,
                      height: 5,
                      thickness: 1,
                      indent: 2,
                      endIndent: 2,
                    ),
                    Text(
                        "Date of candidacy: ${_getDate("cStart")} - ${_getDate("cEnd")}"),
                    Divider(
                      color: Colors.white,
                      height: 5,
                      thickness: 1,
                      indent: 2,
                      endIndent: 2,
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 5,
                      thickness: 1,
                      indent: 2,
                      endIndent: 2,
                    ),
                    Divider(
                      color: Colors.white,
                      height: 5,
                      thickness: 1,
                      indent: 2,
                      endIndent: 2,
                    ),
                    Text(_project.getShortDescription()),
                    Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white)),
                          icon: Icon(Icons.info),
                          label: Text('More Info'),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      scrollable: true,
                                      title: Text(
                                          "Descrizione", //non funziona troppo bene
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontStyle: FontStyle.italic)),
                                      content: Text(_project.getDescription()));
                                });
                          },
                        ))
                  ],
                ))),
      ],
    );
  }

  Widget _secondCard() {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Designer",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          Divider(
            color: Colors.grey,
            height: 20,
            thickness: 1,
            indent: 2,
            endIndent: 2,
          ),
          Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Container(
                  height: 35,
                  child: ListView(
                    padding: EdgeInsets.all(10),
                    children: getListDesigners(),
                    scrollDirection: Axis.horizontal,
                  )))
        ]));
  }

  Widget _thirdCard() {
    return Padding(
        padding: EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Project evaluations",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          Divider(
            color: Colors.grey,
            height: 20,
            thickness: 1,
            indent: 2,
            endIndent: 2,
          ),
          Container(
            child: ListEvaluations(evaluations: _projectEvaluations),
          ),
        ]));
  }

  Widget _fourthCard() {
    return Padding(
        padding: EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Team evaluations",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          Divider(
            color: Colors.grey,
            height: 20,
            thickness: 1,
            indent: 2,
            endIndent: 2,
          ),
          Container(
            child: ListEvaluations(evaluations: _teamEvaluations),
          )
        ]));
  }

  List<Widget> getListDesigners() {
    List<Widget> _listDesigners = [];
    for (int i = 0; i < _designers.length - 1; i++) {
      _listDesigners.add(RichText(
          text: TextSpan(
              text: ('@' + _designers[i].getUsername() + ", "),
              style: TextStyle(color: Colors.black),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Provider.of<ViewProvider>(context, listen: false).pushWidget(
                      FutureBuild(
                          future: Future.wait([
                            Provider.of<ProjectProvider>(context, listen: false)
                                .findByProjectProposer(_designers[i].getMail()),
                            Provider.of<ProjectProvider>(context, listen: false)
                                .findByDesigner(_designers[i].getMail()),
                            Provider.of<TagProvider>(context, listen: false)
                                .updateListTag(_designers[i].getTags())
                          ]),
                          newView:
                              ProfileOverView(user: _designers[i].getMail())));
                })));
    }
    if (_designers.length > 0)
      _listDesigners.add(RichText(
          text: TextSpan(
              text: ('@' + _designers.last.getUsername()),
              style: TextStyle(color: Colors.black),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Provider.of<ViewProvider>(context, listen: false).pushWidget(
                      FutureBuild(
                          future: Future.wait([
                            Provider.of<ProjectProvider>(context, listen: false)
                                .findByProjectProposer(
                                    _designers.last.getMail()),
                            Provider.of<ProjectProvider>(context, listen: false)
                                .findByDesigner(_designers.last.getMail()),
                            Provider.of<TagProvider>(context, listen: false)
                                .updateListTag(_designers.last.getTags())
                          ]),
                          newView: ProfileOverView(
                              user: _designers.last.getMail())));
                })));
    return _listDesigners;
  }

  bool isADesigner(bool isForCandidacy) {
    if (_project.getCandidacyMode().toString() == "true") {
      User user =
          Provider.of<AuthCredentialProvider>(context, listen: false).getUser();
      if (user == null) return false;
      if (_project.getDesigners().contains(user.getMail())) return false;
      if (isForCandidacy) if (Provider.of<CandidacyProvider>(context,
              listen: false)
          .alreadySended(user.getMail(), _project.getId())) {
        return false;
      }
      return (user.getRoles().contains(UserRole.DESIGNER_PERSON) ||
          (user.getRoles().contains(UserRole.DESIGNER_ENTITY) &&
              !isTheProjectProposer()));
    }
    return false;
  }

  bool isAnExpert() {
    if (_project.getEvaluationMode()) {
      User user =
          Provider.of<AuthCredentialProvider>(context, listen: false).getUser();
      if (user == null) return false;
      if (Provider.of<EvaluationProvider>(context, listen: false).alreadySended(
          user.getMail(), EvaluationMode.PROJECT, _project.getId())) {
        if (Provider.of<EvaluationProvider>(context, listen: false)
                .alreadySended(
                    user.getMail(), EvaluationMode.TEAM, _project.getId()) ||
            _project.getDesigners().isEmpty) {
          return false;
        }
      }

      if (isSuitable(user)) {
        return (user.getRoles().contains(UserRole.EXPERT));
      }
    }
    return false;
  }

  bool isTheProjectProposerOrCompanyDesigner() {
    if (_project.getCandidacyMode().toString() == "true") {
      User user =
          Provider.of<AuthCredentialProvider>(context, listen: false).getUser();
      if (user == null)
        return false;
      else {
        if (isADesignerOfTeam()) {
          return true;
        } else {
          return (isTheProjectProposer());
        }
      }
    }
    return false;
  }

  bool isADesignerOfTeam() {
    if (_project.getCandidacyMode().toString() == "true") {
      User user =
          Provider.of<AuthCredentialProvider>(context, listen: false).getUser();
      if (user == null) {
        return false;
      } else if (user.getRoles().contains(UserRole.DESIGNER_ENTITY) &&
          !isTheProjectProposer())
        return _project.getDesigners().contains(user.getMail());
    }
    return false;
  }

  bool isTheProjectProposer() {
    User user =
        Provider.of<AuthCredentialProvider>(context, listen: false).getUser();
    if (user == null) return false;
    return _project.getProjectProposer() == user.getMail();
  }

  bool isSuitable(User user) {
    for (String tag in _project.getTag())
      if (user.getTags().contains(tag)) return true;
    return false;
  }

  Widget _userCustomization() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isAnExpert())
          Padding(
              padding: EdgeInsets.only(right: 15),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: OutlinedButton(
                    onPressed: () => {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SendEvaluation(
                            id: widget.project,
                            context: context,
                          );
                        },
                      ),
                    },
                    child: Text("Valuta"),
                  ))),
        if (isADesigner(true))
          Padding(
              padding: EdgeInsets.only(right: 15),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: OutlinedButton(
                    onPressed: () => {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SendCandidacy(
                              id: widget.project,
                            );
                          })
                    },
                    child: Text("Candidati"),
                  ))),
        if (isTheProjectProposerOrCompanyDesigner())
          Padding(
              padding: EdgeInsets.only(right: 15),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: OutlinedButton(
                    onPressed: () => {
                      Provider.of<ViewProvider>(context, listen: false)
                          .pushWidget(SendInvite(id: widget.project)),
                    },
                    child: Text("Invita"),
                  ))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    init();
    return ListView(
      children: [
        _firstCard(),
        ListTags(listTag: _listTags),
        if (_designers.isNotEmpty) _secondCard(),
        if (_projectEvaluations.isNotEmpty) _thirdCard(),
        if (_teamEvaluations.isNotEmpty) _fourthCard(),
        _userCustomization()
      ],
    );
  }
}
