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

import 'package:doit/widget/ListTags.dart';
import 'package:doit/widget/LoadingScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectOverView extends StatefulWidget {
  final String id;

  const ProjectOverView({Key key, this.id}) : super(key: key);

  @override
  _ProjectOverView createState() => _ProjectOverView();
}

class _ProjectOverView extends State<ProjectOverView> {
  Project _project;
  List<Tag> _listTags;
  List<User> _listDesigner;
  User _projectProposer;
  String _state;

/*
List<RichText> getListDesigner() {
    List<RichText> designers = [];
    if(_listDesigner.isEmpty()) designers.add(RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: "Ancora nessun designer"),
          ],
        ),
      ));else(
    for (int i = 0; i < _listDesigner.length - 1; i++) {
      designers.add(RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: _listDesigner[i].getName() +
                    _listDesigner[i].getSurname() +
                    ", ",
                recognizer: TapGestureRecognizer()..onTap = () {}),
          ],
        ),
      ));
    }
    if (_listDesigner.length > 0)
      designers.add(RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: _listDesigner.last.getName() +
                    _listDesigner.last.getSurname(),
                recognizer: TapGestureRecognizer()..onTap = () {}),
          ],
        ),
      ));
      );
    return designers;
  }
  */
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

  String determinateState() {
    return (DateTime.parse(_project.getDateOfEnd()).compareTo(DateTime.now()) ==
            1)
        ? (_project.getCandidacyMode() ? " Candidacy Mode" : "In corso")
        : "Completato";
  }

  Future init() async {
    _project = context.read<ProjectProvider>().findById(widget.id);
    _listTags = context.read<TagProvider>().getTagsByIds(_project.getTag());
    // _listDesigner = context.read()<UserProvider>().getUsersById(_project.getDesigner());
    _projectProposer = await context
        .read<UserProvider>()
        .findUserByMail(_project.getProjectProposer());
    _state = determinateState();
  }

  String showLastButton() {
    return "E"; //da eleiminare
    /*User user = context.read<UserProvider>().getSpringUser();
    if (_project.getEvaluationMode()) if (user.getRole() == UserRole.EXPERT)
      return "E";

    if (_project.getCandidacyMode()) if (user.getId() ==
        _project.getProjectProposer()) return "P";

    if (user.getRole() == UserRole.DESIGNER) return "D";
    return "";*/
  }

  bool isADesigner() {
    return false; //rimuovere
    User user = context.read<AuthCredentialProvider>().getUser();
    return (user.getRoles().first == UserRole.DESIGNER);
  }

  bool isAnExpert() {
    return true; //rimuovere
    User user = context.read<AuthCredentialProvider>().getUser();
    if (isADesigner()) {
      return (user.getRoles().last == UserRole.EXPERT);
    } else
      return (user.getRoles().first == UserRole.EXPERT);
  }

  bool isTheProjectProposerOrCompanyDesigner() {
    return false; //rimuovere
    User user = context.read<AuthCredentialProvider>().getUser();
    if (isADesigner()) {
      return (!user.getIsAperson());
    } else {
      return (isTheProjectProposer());
    }
  }

  bool isTheProjectProposer() {
    return true; // rimuovere
    return _project.getProjectProposer() ==
        context.read<AuthCredentialProvider>().getUser().getMail();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: init(),
        builder: (context, data) {
          switch (data.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return LoadingScreen(message: "Loading");
            case ConnectionState.done:
              return ListView(children: [
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
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
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
                                              .pushWidget(ProfileOverView(
                                                  mail: _projectProposer
                                                      .getMail()));
                                        }),
                                )
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
                              Text(
                                  "Date : ${_getDate("dStart")} - ${_getDate("dEnd")}"),
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
                                                        fontStyle:
                                                            FontStyle.italic)),
                                                content: Text(
                                                    _project.getDescription()));
                                          });
                                    },
                                  )),
                            ]))),
                ListTags(listTag: _listTags),
                Card(
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
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
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
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Text("Designer, "),
                            Padding(padding: EdgeInsets.all(5.00)),
                            Text("Designer "),
                            Padding(padding: EdgeInsets.all(5.00)),
                          ],
                        ),
                      )
                    ])),
                Row(
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
                                onPressed: () => {},
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
                                onPressed: () => {},
                                child: Text("Invita"),
                              ))),
                  ],
                )
              ]);
          }
        });
  }
}
