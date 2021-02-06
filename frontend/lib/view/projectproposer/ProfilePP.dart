import 'package:doit/model/Project.dart';
import 'package:doit/model/Tag.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ListOfProjects.dart';
import 'package:doit/view/ProjectOverView.dart';
import 'package:doit/widget/CardList.dart';
import 'package:doit/widget/ListTags.dart';
import 'package:doit/widget/LoadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePP extends StatefulWidget {
  final String id;

  const ProfilePP({Key key, @required this.id}) : super(key: key);

  @override
  _ProfilePP createState() => _ProfilePP();
}

class _ProfilePP extends State<ProfilePP> {
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
                Padding(
                    padding: EdgeInsets.only(top: 15, left: 10),
                    child: Text(
                      ("Project Proposer"),
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                              Row(children: [
                                Text("Username :"),
                                Text(_projectProposer.getUsername())
                              ]),
                              Divider(
                                color: Colors.white,
                                height: 5,
                                thickness: 1,
                                indent: 2,
                                endIndent: 2,
                              ),
                              Row(children: [
                                Text("Name :"),
                                Text(
                                  _projectProposer.getName(),
                                )
                              ]),
                              Divider(
                                color: Colors.white,
                                height: 5,
                                thickness: 1,
                                indent: 2,
                                endIndent: 2,
                              ),
                              Row(
                                children: [
                                  _projectProposer.getIsAperson()
                                      ? Text("Surname : ")
                                      : Text("Partita iva : "),
                                  Text(_projectProposer.getSurname())
                                ],
                              ),
                              Divider(
                                color: Colors.white,
                                height: 5,
                                thickness: 1,
                                indent: 2,
                                endIndent: 2,
                              ),
                            ]))),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ("Tags"),
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
                          Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: SizedBox(
                                height: 30,
                                child: ListTags(listTag: _tags),
                              ))
                        ])),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ("Projects"),
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
                            child: ListOfProjects(projects: _projects),
                          )
                        ])),
              ]);
          }
        });
  }
}
