import 'package:doit/model/Project.dart';
import 'package:doit/model/Tag.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/CreateModifyProfile.dart';
import 'package:doit/widget/FutureBuilder.dart';
import 'package:doit/widget/ListProjects.dart';
import 'package:doit/widget/PrincipalInformationUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileOverView extends StatefulWidget {
  final String user;

  const ProfileOverView({Key key, @required this.user}) : super(key: key);

  @override
  _ProfileOverView createState() => _ProfileOverView();
}

class _ProfileOverView extends State<ProfileOverView> {
  List<Project> _proposedProjects = [];
  List<Project> _parteciateInProjects = [];
  List<Tag> _tags;
  User _user;

  void init() {
    _user = context.watch<UserProvider>().findByMail(widget.user);
    _proposedProjects =
        context.watch<ProjectProvider>().findByUser(_user.getMail(), true);
    _parteciateInProjects =
        context.watch<ProjectProvider>().findByUser(_user.getMail(), false);
    _tags = context.watch<TagProvider>().getTagsByIds(_user.getTags());
  }

  bool isTheOwner() {
    User user =
        Provider.of<AuthCredentialProvider>(context, listen: false).getUser();
    if (user == null) return false;
    return user.getMail() == _user.getMail();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return ListView(children: [
      if (isTheOwner())
        Padding(
            padding: EdgeInsets.only(right: 15, top: 10),
            child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  iconSize: 30,
                  color: Colors.blue,
                  icon: Icon(Icons.border_color),
                  onPressed: () => {
                    context.read<ViewProvider>().pushWidget(FutureBuild(
                        future: Future.wait([
                          Provider.of<TagProvider>(context, listen: false)
                              .updateListTag(_user.getTags())
                        ]),
                        newView: CreateModifyProfile(
                          isNewUser: false,
                        )))
                  },
                ))),
      PrincipalInformationUser(user: _user, tags: _tags),
      if (_proposedProjects.isNotEmpty)
        Padding(
            padding: EdgeInsets.all(15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                ("Proposed projects"),
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Colors.grey,
                height: 20,
                thickness: 1,
                indent: 2,
                endIndent: 2,
              ),
              ListProjects(projects: _proposedProjects)
            ])),
      if (_parteciateInProjects.isNotEmpty)
        Padding(
            padding: EdgeInsets.all(15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Projects in which he participated ",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Colors.grey,
                height: 20,
                thickness: 1,
                indent: 2,
                endIndent: 2,
              ),
              ListProjects(projects: _parteciateInProjects)
            ])),
    ]);
  }
}
