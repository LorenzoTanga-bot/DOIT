import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/model/Tag.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/ProjectProvider.dart';

import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';

import 'package:doit/view/ProfileOverView.dart';
import 'package:doit/view/projectproposer/CreateModifyProject.dart';
import 'package:doit/widget/FutureBuilder.dart';

import 'package:doit/widget/ListTags.dart';
import 'package:doit/widget/SendCandidacy.dart';
import 'package:doit/widget/SendInvite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectOverView extends StatefulWidget {
  final String id;

  const ProjectOverView({Key key, @required this.id}) : super(key: key);

  @override
  _ProjectOverView createState() => _ProjectOverView();
}

class _ProjectOverView extends State<ProjectOverView> {
  User _projectProposer;
  Project _project;
  List<Tag> _listTags;
  String _state;
  List<User> _designers;

  void initState() {
    super.initState();
    _project = context.read<ProjectProvider>().findById(widget.id);
    _projectProposer = Provider.of<UserProvider>(context, listen: false)
        .findByMail(_project.getProjectProposer());
    _listTags = Provider.of<TagProvider>(context, listen: false)
        .getTagsByIds(_project.getTag());
    _designers = Provider.of<UserProvider>(context, listen: false)
        .findByMails(_project.getDesigners());
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
                  child: RaisedButton(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () => {
                      Provider.of<ViewProvider>(context, listen: false)
                          .pushWidget(CreateModifyProject(
                        id: _project.getId(),
                      ))
                    },
                    child: Text("Modifica"),
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
                                                .updateListProject(
                                                    _projectProposer
                                                        .getProposedProjects()),
                                            Provider.of<ProjectProvider>(
                                                    context,
                                                    listen: false)
                                                .updateListProject(_projectProposer
                                                    .getPartecipateInProjects()),
                                            Provider.of<TagProvider>(context,
                                                    listen: false)
                                                .updateListTag(
                                                    _projectProposer.getTags())
                                          ]),
                                          newView: ProfileOverView(
                                              user: _projectProposer)));
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
                        child: FlatButton.icon(
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
    return Card(
        margin: EdgeInsets.all(15),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(children: <Widget>[
          Row(children: [
            Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        color: Colors.white,
                        height: 5,
                        thickness: 1,
                        indent: 2,
                        endIndent: 2,
                      ),
                      Text("Designer",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                    ]))
          ]),
          Divider(
            color: Colors.grey,
            height: 20,
            thickness: 1,
            indent: 2,
            endIndent: 2,
          ),
          Container(
              height: 25,
              child: ListView(
                padding: EdgeInsets.only(left: 10, right: 10),
                children: getListDesigners(),
                scrollDirection: Axis.horizontal,
              ))
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
                  Provider.of<ViewProvider>(context, listen: false)
                      .pushWidget(FutureBuild(
                          future: Future.wait([
                            Provider.of<ProjectProvider>(context, listen: false)
                                .updateListProject(
                                    _designers[i].getProposedProjects()),
                            Provider.of<ProjectProvider>(context, listen: false)
                                .updateListProject(
                                    _designers[i].getPartecipateInProjects()),
                            Provider.of<TagProvider>(context, listen: false)
                                .updateListTag(_designers[i].getTags())
                          ]),
                          newView: ProfileOverView(user: _designers[i])));
                })));
    }
    if (_designers.length > 0)
      _listDesigners.add(RichText(
          text: TextSpan(
              text: ('@' + _designers.last.getUsername()),
              style: TextStyle(color: Colors.black),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Provider.of<ViewProvider>(context, listen: false)
                      .pushWidget(FutureBuild(
                          future: Future.wait([
                            Provider.of<ProjectProvider>(context, listen: false)
                                .updateListProject(
                                    _designers.last.getProposedProjects()),
                            Provider.of<ProjectProvider>(context, listen: false)
                                .updateListProject(
                                    _designers.last.getPartecipateInProjects()),
                            Provider.of<TagProvider>(context, listen: false)
                                .updateListTag(_designers.last.getTags())
                          ]),
                          newView: ProfileOverView(user: _designers.last)));
                })));
    return _listDesigners;
  }

  bool isADesigner() {
    if (_project.getCandidacyMode().toString() == "true") {
      User user = context.read<AuthCredentialProvider>().getUser();
      if (user == null) return false;
      return (user.getRoles().contains(UserRole.DESIGNER_PERSON) ||
          user.getRoles().contains(UserRole.DESIGNER_ENTITY));
    }
    return false;
  }

  bool isAnExpert() {
    if (_project.getEvaluationMode()) {
      User user = context.read<AuthCredentialProvider>().getUser();
      if (user == null) return false;
      if (isSuitable(user)) {
        return (user.getRoles().contains(UserRole.EXPERT));
      }
    }
    return false;
  }

  bool isTheProjectProposerOrCompanyDesigner() {
    if (_project.getCandidacyMode().toString() == "true") {
      User user = context.read<AuthCredentialProvider>().getUser();
      if (user == null)
        return false;
      else {
        if (isADesigner()) {
          if (isADesignerOfTeam()) return (!user.getIsAPerson());
        } else {
          return (isTheProjectProposer());
        }
      }
    }
    return false;
  }

  bool isADesignerOfTeam() {
    if (_project.getCandidacyMode().toString() == "true") {
      User user = context.read<AuthCredentialProvider>().getUser();
      if (user == null) {
        return false;
      } else if (isADesigner()) {
        if (_project.getDesigners().contains(user.getMail())) return true;
      }
    }
    return false;
  }

  bool isTheProjectProposer() {
    User user = context.read<AuthCredentialProvider>().getUser();
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
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () => {},
                    child: Text("Valuta"),
                  ))),
        if (isADesigner())
          Padding(
              padding: EdgeInsets.only(right: 15),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () => {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SendCandidacy(id: _project.getId());
                          })
                    },
                    child: Text("Candidati"),
                  ))),
        if (isTheProjectProposerOrCompanyDesigner())
          Padding(
              padding: EdgeInsets.only(right: 15),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () => {
                      Provider.of<ViewProvider>(context, listen: false)
                          .pushWidget(SendInvite(id: _project.getId()))
                    },
                    child: Text("Invita"),
                  ))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _firstCard(),
        ListTags(listTag: _listTags),
        if (_designers.isNotEmpty) _secondCard(),
        _userCustomization()
      ],
    );
  }
}
