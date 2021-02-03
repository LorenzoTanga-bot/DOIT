import 'package:doit/model/Project.dart';
import 'package:doit/model/Tag.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/projectproposer/CreateModifyProject.dart';
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
  List<Tag> _listTag;
  //List<User> _listDesigner;
  User _projectProposer;
  String _state;

  List<Text> getListTag() {
    List<Text> tags = [];

    for (int i = 0; i < _listTag.length - 1; i++) {
      tags.add(Text(_listTag[i].getValue() + ", "));
    }
    if (_listTag.length > 0) tags.add(Text(_listTag.last.getValue()));
    return tags;
  }

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

  @override
  void initState() {
    _project = context.read<ProjectProvider>().findById(widget.id);
    _listTag = context.read<TagProvider>().getTagsByIds(_project.getTag());
    // _listDesigner = context.read()<UserProvider>().getUsersById(_project.getDesigner());
    //_projectProposer = context.read<UserProvider>().findUserById(_project.getProjectProposer());
    _state = determinateState();
    super.initState();
  }

  String showLastButton() {
    return "E"; //da eleiminare
    User user = context.read<UserProvider>().getSpringUser();
    if (_project.getEvaluationMode()) if (user.getRole() == UserRole.EXPERT)
      return "E";

    if (_project.getCandidacyMode()) if (user.getId() ==
        _project.getProjectProposer()) return "P";

    if (user.getRole() == UserRole.DESIGNER) return "D";
    return "";
  }

  Widget choseLastButton() {
    if (showLastButton() == "E")
      return Padding(
          padding: EdgeInsets.only(right: 15),
          child: Align(
              alignment: Alignment.bottomRight,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () => {},
                child: Text("Valuta"),
              )));
    else if (showLastButton() == "P")
      return Padding(
          padding: EdgeInsets.only(right: 15),
          child: Align(
              alignment: Alignment.bottomRight,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () => {},
                child: Text("Invita"),
              )));
    else if (showLastButton() == "D")
      return Padding(
          padding: EdgeInsets.only(right: 15),
          child: Align(
              alignment: Alignment.bottomRight,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () => {},
                child: Text("Candidati"),
              )));
    else
      return Container(
        height: 1,
      );
  }

  bool showModify() {
    return true; // rimuovere
    User user = Provider.of<UserProvider>(context).getSpringUser();
    return _project.getProjectProposer() == user.getId();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      if (showModify())
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
          child: Column(children: <Widget>[
            Row(children: [
              Padding(
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
                        Text(
                          "ProjectProposer",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        Divider(
                          color: Colors.white,
                          height: 5,
                          thickness: 1,
                          indent: 2,
                          endIndent: 2,
                        ),
                        Text("Stato: $_state"),
                        Divider(
                          color: Colors.white,
                          height: 5,
                          thickness: 1,
                          indent: 2,
                          endIndent: 2,
                        ),
                        Text(
                            "Date: ${_getDate("dStart")} - ${_getDate("dEnd")}"),
                      ]))
            ]),
            Divider(
              color: Colors.grey,
              height: 5,
              thickness: 1,
              indent: 2,
              endIndent: 2,
            ),
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_project.getShortDescription()),
                        ])),
              ],
            ),
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
                              title: Text(_project.getName(),
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontStyle: FontStyle.italic)),
                              content: Text(_project.getDescription()));
                        });
                  },
                )),
          ])),
      Card(
          margin: EdgeInsets.all(15),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: <Widget>[
              Row(children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            color: Colors.white,
                            height: 5,
                            thickness: 1,
                            indent: 2,
                            endIndent: 2,
                          ),
                          Text("Tag",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))
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
                      children: getListTag())),
            ],
          )),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                fontSize: 20, fontWeight: FontWeight.bold)),
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
      choseLastButton(),
    ]);
  }
}
