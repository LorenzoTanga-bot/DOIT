import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/model/Tag.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';

import 'package:doit/view/ProfileOverView.dart';
import 'package:doit/view/projectproposer/CreateModifyProject.dart';

import 'package:doit/widget/ListTags.dart';
import 'package:doit/widget/LoadingScreen.dart';
import 'package:doit/widget/SendCandidacy.dart';
import 'package:doit/widget/SendInvite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectOverView extends StatefulWidget {
  final Project project;

  const ProjectOverView({Key key, @required this.project}) : super(key: key);

  @override
  _ProjectOverView createState() => _ProjectOverView();
}

class _ProjectOverView extends State<ProjectOverView> {
  User _projectProposer;
  List<Tag> _listTags;
  String _state;

  Future _uploadData() async {
    await Future.wait([
      Provider.of<UserProvider>(context, listen: false)
          .updateListUsers([widget.project.getProjectProposer()]),
      Provider.of<TagProvider>(context, listen: false)
          .updateListTag(widget.project.getTag())
    ]);
    //TODO da sostiuire con [project.getProjectProposer()].addAll(project.getDesigner());
    _projectProposer = await Provider.of<UserProvider>(context, listen: false)
        .findUserByMail(widget.project.getProjectProposer());
    _listTags = Provider.of<TagProvider>(context, listen: false)
        .getTagsByIds(widget.project.getTag());
    _state = (DateTime.parse(widget.project.getDateOfEnd())
                .compareTo(DateTime.now()) ==
            1)
        ? (widget.project.getCandidacyMode() ? "Candidacy Mode" : "In corso")
        : "Completed";
  }

  String _getDate(String type) {
    DateTime date;
    switch (type) {
      case "dStart":
        date = DateTime.parse(widget.project.getDateOfStart());
        break;
      case "dEnd":
        date = DateTime.parse(widget.project.getDateOfEnd());
        break;
      case "cStart":
        date = DateTime.parse(widget.project.getStartCandidacy());
        break;
      case "cEnd":
        date = DateTime.parse(widget.project.getEndCandidacy());
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
                        id: widget.project.getId(),
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
                      widget.project.getName(),
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
                                      .pushWidget(ProfileOverView(
                                          mail: _projectProposer.getMail()));
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
                    Text(widget.project.getShortDescription()),
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
                                      content: Text(
                                          widget.project.getDescription()));
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
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Text("Designer, "),
                Padding(padding: EdgeInsets.all(5.00)),
                Text("Designer "),
                Padding(padding: EdgeInsets.all(5.00)),
              ],
            ),
          )
        ]));
  }

  bool isADesigner() {
    if (widget.project.getCandidacyMode().toString() == "true") {
      User user = context.read<AuthCredentialProvider>().getUser();
      if (user == null) return false;
      return (user.getRoles().contains(UserRole.DESIGNER_PERSON) ||
          user.getRoles().contains(UserRole.DESIGNER_ENTITY));
    }
    return false;
  }

  bool isAnExpert() {
    if (widget.project.getEvaluationMode()) {
      User user = context.read<AuthCredentialProvider>().getUser();
      if (user == null) return false;
      if (isSuitable(user)) {
        return (user.getRoles().contains(UserRole.EXPERT));
      }
    }
    return false;
  }

  bool isTheProjectProposerOrCompanyDesigner() {
    if (widget.project.getCandidacyMode().toString() == "true") {
      User user = context.read<AuthCredentialProvider>().getUser();
      if (user == null)
        return false;
      else {
        if (isADesigner()) {
          if (isSuitable(user)) return (!user.getIsAPerson());
        } else {
          return (isTheProjectProposer());
        }
      }
    }
    return false;
  }

  bool isTheProjectProposer() {
    User user = context.read<AuthCredentialProvider>().getUser();
    if (user == null) return false;
    return widget.project.getProjectProposer() == user.getMail();
  }

  bool isSuitable(User user) {
    for (String tag in widget.project.getTag())
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
                            return SendCandidacy(id: widget.project.getId());
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
                          .pushWidget(SendInvite(id: widget.project.getId()))
                    },
                    child: Text("Invita"),
                  ))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _uploadData(),
      builder: (context, data) {
        switch (data.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return LoadingScreen(message: "Loading");
          case ConnectionState.done:
            return ListView(
              children: [
                _firstCard(),
                ListTags(listTag: _listTags),
                _secondCard(),
                _userCustomization()
              ],
            );
        }
        return null;
      },
    );
  }
}
