import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/model/Tag.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
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
  User _user;
  List<Project> _proposedProjects=[];
  List<Project> _parteciateInProjects=[];
  List<Tag> _tags;

  Future init() async {
    _user = await context.read<UserProvider>().findUserByMail(widget.mail);
    _proposedProjects =
        context.read<ProjectProvider>().findByIds(_user.getProposedProjects());
    _parteciateInProjects = context
        .read<ProjectProvider>()
        .findByIds(_user.getPartecipateInProjects());
    _tags = context.read<TagProvider>().getTagsByIds(_user.getTags());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: init(),
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
                              // fixed height
                              ListProjects(projects: _proposedProjects)
                            ])),
                  if (_parteciateInProjects.isNotEmpty &&
                      _user.getRoles().last != UserRole.DESIGNER)
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
