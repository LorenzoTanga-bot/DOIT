import 'package:doit/model/Project.dart';
import 'package:doit/model/Tag.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/widget/ListProjects.dart';
import 'package:doit/widget/LoadingScreen.dart';
import 'package:doit/widget/PrincipalInformationUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileOverView extends StatefulWidget {
  final User user;

  const ProfileOverView({Key key, @required this.user}) : super(key: key);

  @override
  _ProfileOverView createState() => _ProfileOverView();
}

class _ProfileOverView extends State<ProfileOverView> {
  List<Project> _proposedProjects = [];
  List<Project> _parteciateInProjects = [];
  List<Tag> _tags;

  Future _uploadData() async {
    await Future.wait([
      Provider.of<ProjectProvider>(context, listen: false)
          .updateListProject(widget.user.getProposedProjects()),
      Provider.of<ProjectProvider>(context, listen: false)
          .updateListProject(widget.user.getPartecipateInProjects()),
      Provider.of<TagProvider>(context, listen: false)
          .updateListTag(widget.user.getTags())
    ]);
    _proposedProjects = Provider.of<ProjectProvider>(context, listen: false)
        .findByIds(widget.user.getProposedProjects());
    _parteciateInProjects = Provider.of<ProjectProvider>(context, listen: false)
        .findByIds(widget.user.getPartecipateInProjects());
    _tags = Provider.of<TagProvider>(context, listen: false)
        .getTagsByIds(widget.user.getTags());
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
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView(children: [
                  PrincipalInformationUser(user: widget.user, tags: _tags),
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
          return null;
        });
  }
}
