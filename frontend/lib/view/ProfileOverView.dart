import 'package:doit/model/Project.dart';
import 'package:doit/model/Tag.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/CreateModifyProfile.dart';

import 'package:doit/widget/ListProjects.dart';
import 'package:doit/widget/LoadingScreen.dart';
import 'package:doit/widget/PrincipalInformationUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileOverView extends StatefulWidget {
  final String mail;

  const ProfileOverView({Key key, @required this.mail}) : super(key: key);

  @override
  _ProfileOverView createState() => _ProfileOverView();
}

class _ProfileOverView extends State<ProfileOverView> {
  List<Project> _proposedProjects = [];
  List<Project> _parteciateInProjects = [];
  List<Tag> _tags;
  User _user;

  Future _uploadData() async {
    _user = await Provider.of<UserProvider>(context, listen: false).findUserByMail(widget.mail);
    await Future.wait([
      Provider.of<ProjectProvider>(context, listen: false)
          .updateListProject(_user.getProposedProjects()),
      Provider.of<ProjectProvider>(context, listen: false)
          .updateListProject(_user.getPartecipateInProjects()),
      Provider.of<TagProvider>(context, listen: false)
          .updateListTag(_user.getTags())
    ]);
    _proposedProjects = Provider.of<ProjectProvider>(context, listen: false)
        .findByIds(_user.getProposedProjects());
    _parteciateInProjects = Provider.of<ProjectProvider>(context, listen: false)
        .findByIds(_user.getPartecipateInProjects());
    _tags = Provider.of<TagProvider>(context, listen: false)
        .getTagsByIds(_user.getTags());
  }

  bool isTheOwner() {
    User user = context.read<AuthCredentialProvider>().getUser();
    if (user == null) return false;
    return user.getMail() == _user.getMail();
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
                child: ListView(children: [
                  if (isTheOwner())
                    Padding(
                        padding: EdgeInsets.only(right: 15, top: 10),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: RaisedButton(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () => {
                                Provider.of<ViewProvider>(context,
                                        listen: false)
                                    .pushWidget(CreateModifyProfile(
                                        mail: _user.getMail(),
                                        isNewUser: false))
                              },
                              child: Text("Modifica"),
                            ))),
                  PrincipalInformationUser(user: _user, tags: _tags),
                  if (_proposedProjects.isNotEmpty)
                    Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ("Proposed projects"),
                                textAlign: TextAlign.start,
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
                              ListProjects(projects: _proposedProjects)
                            ])),
                  if (_parteciateInProjects.isNotEmpty)
                    Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Projects in which he participated ",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              ListProjects(projects: _parteciateInProjects)
                            ])),
                ]),
              );
          }
        });
  }
}
