import 'package:doit/model/Candidacy.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/CandidacyProvider.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/ViewProvider.dart';

import 'package:doit/view/ProjectOverView.dart';
import 'package:doit/widget/LoadingScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CandidacyOverView extends StatefulWidget {
  final String id;

  const CandidacyOverView({Key key, @required this.id}) : super(key: key);

  @override
  _CandidacyOverView createState() => _CandidacyOverView();
}

class _CandidacyOverView extends State<CandidacyOverView> {
  Candidacy candidacy;
  Project project;
  String dateString;
  String dateOfExpireString;
  String state;
  Future _uploadData() async {
    candidacy = await Provider.of<CandidacyProvider>(context, listen: false)
        .findById(widget.id);
    project = Provider.of<ProjectProvider>(context, listen: false)
        .findById(candidacy.getProject());
    state = candidacy.getState().toString();
    state = state.substring(state.indexOf(".") + 1);
    DateTime date = DateTime.parse(candidacy.getDateOfCandidacy());
    dateString = "${date.day}" + "/" + "${date.month}" + "/" + "${date.year}";
    DateTime dateOfExpire = DateTime.parse(candidacy.getDateOfExpire());
    dateOfExpireString = "${dateOfExpire.day}" +
        "/" +
        "${dateOfExpire.month}" +
        "/" +
        "${dateOfExpire.year}";
  }

  bool isTheProjectProposer() {
    return true;
    User user = context.read<AuthCredentialProvider>().getUser();
    if (user == null) return false;
    return candidacy.getProjectProposer() == user.getMail();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _uploadData(),
        // ignore: missing_return
        builder: (context, data) {
          switch (data.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return LoadingScreen(message: "Loading");
            case ConnectionState.done:
              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView(shrinkWrap: true, children: [
                    Padding(
                        padding: EdgeInsets.only(top: 15, left: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Candidacy",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        )),
                    Card(
                        margin: EdgeInsets.all(15),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
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
                                              Provider.of<ViewProvider>(context,
                                                      listen: false)
                                                  .pushWidget(ProjectOverView(
                                                      project: project));
                                            }))
                                ]),
                                Divider(
                                  color: Colors.white,
                                  height: 8,
                                  thickness: 1,
                                  indent: 2,
                                  endIndent: 2,
                                ),
                                Text("Date : $dateString"),
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
                                if (candidacy.getMessage() != null)
                                  Row(children: [
                                    Text("Message : "),
                                    Text(candidacy.getMessage())
                                  ]),
                                Text("Date of Expire : $dateOfExpireString "),
                              ],
                            ))),
                    if (isTheProjectProposer())
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    onPressed: () => {},
                                    child: Text("Accetta"),
                                  ))),
                          Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    onPressed: () => {},
                                    child: Text("Rifiuta"),
                                  ))),
                        ],
                      ),
                  ]));
          }
        });
  }
}
