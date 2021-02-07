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

class ProfileD extends StatefulWidget {
  final String id;

  const ProfileD({Key key, @required this.id}) : super(key: key);

  @override
  _ProfileD createState() => _ProfileD();
}

class _ProfileD extends State<ProfileD> {
  User _projectProposer;
  List<Project> _projects;
  List<Tag> _tags;

  Future init() async {
    _projectProposer =
        await context.read<UserProvider>().findUserById(widget.id);
    _projects = context
        .read<ProjectProvider>()
        .findByIds(_projectProposer.getProjectsFirstRole());
    _tags =
        context.read<TagProvider>().getTagsByIds(_projectProposer.getTags());
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
                PrincipalInformationUser(user: _projectProposer, tags: _tags),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ("Projects in which he participated "),
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
                          SizedBox(
                            height: 300, // fixed height
                            child: ListProjects(projects: _projects),
                          )
                        ])),
              ]);
          }
        });
  }
}
