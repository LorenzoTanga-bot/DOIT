import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/model/Tag.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/view/ListOfProjects.dart';
import 'package:doit/widget/LoadingScreen.dart';
import 'package:doit/widget/PrincipalInformationUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileUserOverView extends StatefulWidget {
  final String id;

  const ProfileUserOverView({Key key, @required this.id}) : super(key: key);

  @override
  _ProfileUserOverView createState() => _ProfileUserOverView();
}

class _ProfileUserOverView extends State<ProfileUserOverView> {
  User _user;
  List<Project> _projects;
  List<Tag> _tags;

  Future init() async {
    _user = await context.read<UserProvider>().findUserById(widget.id);
    _projects =
        context.read<ProjectProvider>().findByIds(_user.getProjectsFirstRole());
    _tags = context.read<TagProvider>().getTagsByIds(_user.getTags());
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
                PrincipalInformationUser(user: _user, tags: _tags),
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
                        if (_user.getRoles().first == UserRole.DESIGNER)
                          Text(
                            "Projects in which he participated ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        if (_user.getRoles().first == UserRole.PROJECT_PROPOSER)
                          Text(
                            ("Proposed projects"),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        SizedBox(
                          height: 300, // fixed height
                          child: ListOfProjects(projects: _projects),
                        )
                      ]),
                )
              ]);
          }
        });
  }
}
