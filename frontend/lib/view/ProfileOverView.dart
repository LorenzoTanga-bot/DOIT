import 'package:doit/model/Project.dart';
import 'package:doit/model/Tag.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/CreateModifyProfile.dart';
import 'package:doit/widget/FutureBuilder.dart';
import 'package:doit/widget/ListProjects.dart';
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

  void initState() {
    super.initState();
    _proposedProjects = Provider.of<ProjectProvider>(context, listen: false)
        .findByIds(widget.user.getProposedProjects());
    _parteciateInProjects = Provider.of<ProjectProvider>(context, listen: false)
        .findByIds(widget.user.getPartecipateInProjects());
    _tags = Provider.of<TagProvider>(context, listen: false)
        .getTagsByIds(widget.user.getTags());
  }

  bool isTheOwner() {
    User user = context.read<AuthCredentialProvider>().getUser();
    if (user == null) return false;
    return user.getMail() == widget.user.getMail();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
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
                    context.read<ViewProvider>().pushWidget(FutureBuild(
                        future: Future.wait([
                          Provider.of<TagProvider>(context, listen: false)
                              .updateListTag(widget.user.getTags())
                        ]),
                        newView: CreateModifyProfile(
                          mail: widget.user.getMail(),
                          isNewUser: false,
                        )))
                  },
                  child: Text("Modifica"),
                ))),
      PrincipalInformationUser(user: widget.user, tags: _tags),
      if (_proposedProjects.isNotEmpty)
        Padding(
            padding: EdgeInsets.all(15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                ("Proposed projects"),
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Projects in which he participated ",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              ListProjects(projects: _parteciateInProjects)
            ])),
    ]);
  }
}
