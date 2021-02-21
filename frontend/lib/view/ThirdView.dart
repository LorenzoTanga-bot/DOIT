import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/Candidacy.dart';
import 'package:doit/model/Invite.dart';

import 'package:doit/model/User.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/CandidacyProvider.dart';
import 'package:doit/providers/InviteProvider.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';

import 'package:doit/view/ListOfCandidacies.dart';
import 'package:doit/view/ListOfInvites.dart';
import 'package:doit/view/ListOfProjects.dart';
import 'package:doit/view/ProfileOverView.dart';
import 'package:doit/view/projectproposer/CreateModifyProject.dart';
import 'package:doit/widget/CardList.dart';
import 'package:doit/widget/FutureBuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThirdView extends StatefulWidget {
  @override
  _ThirdView createState() => _ThirdView();
}

class _ThirdView extends State<ThirdView> {
  User _user;
  List<Widget> _listView = [];
  List<Candidacy> candidacies = [];
  List<Invite> invites = [];

  _default() {
    _listView.addAll([
      Divider(
        color: Colors.white,
        height: 20,
        thickness: 1,
        indent: 2,
        endIndent: 2,
      ),
      RawMaterialButton(
        onPressed: () {},
        elevation: 2.0,
        fillColor: Colors.white,
        child: Icon(
          Icons.person,
          size: 35.0,
        ),
        padding: EdgeInsets.all(15.0),
        shape: CircleBorder(),
      ),
      Divider(
        color: Colors.white,
        height: 20,
        thickness: 1,
        indent: 2,
        endIndent: 2,
      ),
      GestureDetector(
          child: CardList(
              name: "Profile", sDescription: "View and modify your profile"),
          onTap: () => Provider.of<ViewProvider>(context, listen: false)
              .pushWidget(FutureBuild(
                  future: Future.wait([
                    Provider.of<ProjectProvider>(context, listen: false)
                        .updateListProject(_user.getProposedProjects()),
                    Provider.of<ProjectProvider>(context, listen: false)
                        .updateListProject(_user.getPartecipateInProjects()),
                    Provider.of<TagProvider>(context, listen: false)
                        .updateListTag(_user.getTags())
                  ]),
                  newView: ProfileOverView(user: _user)))),
    ]);
  }

  _projectProposer() {
    _listView.addAll([
      Divider(
        color: Colors.white,
        height: 15,
        thickness: 1,
        indent: 2,
        endIndent: 2,
      ),
      Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text("PROJECT PROPOSER",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      Divider(
        color: Colors.white,
        height: 15,
        thickness: 1,
        indent: 2,
        endIndent: 2,
      ),
      GestureDetector(
        child:
            CardList(name: "New Project", sDescription: "Create New Project"),
        onTap: () =>
            context.read<ViewProvider>().pushWidget(CreateModifyProject(
                  id: "",
                )),
      ),
      GestureDetector(
          child: CardList(
              name: "Candidacies",
              sDescription: "View all candidacies received"),
          onTap: () => getListCandidacy("PROJECT_PROPOSER")),
      GestureDetector(
          child:
              CardList(name: "Invites", sDescription: "View all invites sent"),
          onTap: () => getListInvite("PROJECT_PROPOSER")),
      GestureDetector(
          child: CardList(
              name: "Proposed project",
              sDescription: "View all proposed project"),
          onTap: () => {
                context.read<ViewProvider>().pushWidget(FutureBuild(
                    future: Provider.of<ProjectProvider>(context, listen: false)
                        .updateListProject(_user.getProposedProjects()),
                    newView: ListOfProjects(
                        projects:
                            Provider.of<ProjectProvider>(context, listen: false)
                                .findByIds(_user.getProposedProjects()))))
              }),
    ]);
  }

  _designer() async {
    _listView.addAll([
      Divider(
        color: Colors.white,
        height: 15,
        thickness: 1,
        indent: 2,
        endIndent: 2,
      ),
      Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text("DESIGNER",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      Divider(
        color: Colors.white,
        height: 15,
        thickness: 1,
        indent: 2,
        endIndent: 2,
      ),
      GestureDetector(
          child: CardList(
              name: "Candidature", sDescription: "View all candidacy sent"),
          onTap: () => getListCandidacy("DESIGNER")),
      GestureDetector(
          child: CardList(
              name: "Invites", sDescription: "View all invites recieved"),
          onTap: () => getListInvite("DESIGNER")),
      if (_user.getRoles().contains(UserRole.DESIGNER_ENTITY))
        GestureDetector(
            child: CardList(
                name: "Invites to designer",
                sDescription: "View all invites sent"),
            onTap: () => {}),
    ]);
  }

  _expert() {
    _listView.addAll([
      Divider(
        color: Colors.white,
        height: 15,
        thickness: 1,
        indent: 2,
        endIndent: 2,
      ),
      Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text("EXPERT",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      Divider(
        color: Colors.white,
        height: 15,
        thickness: 1,
        indent: 2,
        endIndent: 2,
      ),
      GestureDetector(
        child: CardList(
            name: "Projects evaluated",
            sDescription: "Active and completed projects evaluated"),
        //TODO aggiustare
        onTap: () => context.read<ViewProvider>().pushWidget(null),
      ),
    ]);
  }

  @override
  void initState() {
    super.initState();
    _user = context.read<AuthCredentialProvider>().getUser();
    _default();
    if (_user.getRoles().contains(UserRole.PROJECT_PROPOSER))
      _projectProposer();
    if (_user.getRoles().contains(UserRole.DESIGNER_PERSON) ||
        _user.getRoles().contains(UserRole.DESIGNER_ENTITY)) _designer();
    if (_user.getRoles().contains(UserRole.EXPERT)) _expert();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _listView,
    );
  }

  getListCandidacy(String role) async {
    switch (role) {
      case "DESIGNER":
        {
          candidacies =
              await Provider.of<CandidacyProvider>(context, listen: false)
                  .findByDesigner(_user.getMail());
          List<String> users = [];
          for (Candidacy candidacy in candidacies) {
            users.addAll(
                [candidacy.getDesigner(), candidacy.getProjectProposer()]);
          }
          context.read<ViewProvider>().pushWidget(FutureBuild(
              future: Provider.of<UserProvider>(context, listen: false)
                  .updateListUsers(users),
              newView: ListOfCandidacy(candidacies: candidacies)));
          break;
        }
      case "PROJECT_PROPOSER":
        {
          candidacies =
              await Provider.of<CandidacyProvider>(context, listen: false)
                  .findByProjectProposer(_user.getMail());
          List<String> users = [];
          for (Candidacy candidacy in candidacies) {
            users.addAll(
                [candidacy.getDesigner(), candidacy.getProjectProposer()]);
          }
          context.read<ViewProvider>().pushWidget(FutureBuild(
              future: Provider.of<UserProvider>(context, listen: false)
                  .updateListUsers(users),
              newView: ListOfCandidacy(candidacies: candidacies)));
          break;
        }
    }
  }

  getListInvite(String role) async {
    switch (role) {
      case "DESIGNER":
        {
          invites = await Provider.of<InviteProvider>(context, listen: false)
              .findByDesigner(_user.getMail());
          List<String> users = [];
          for (Invite invite in invites) {
            users.addAll([
              invite.getDesigner(),
              invite.getProjectProposer(),
              invite.getSender()
            ]);
          }
          context.read<ViewProvider>().pushWidget(FutureBuild(
              future: Provider.of<UserProvider>(context, listen: false)
                  .updateListUsers(users),
              newView: ListOfInvites(invites: invites)));
          break;
        }
      case "PROJECT_PROPOSER":
        {
          invites = await Provider.of<InviteProvider>(context, listen: false)
              .findByProjectProposer(_user.getMail());
          List<String> users = [];
          for (Invite invite in invites) {
            users.addAll([
              invite.getDesigner(),
              invite.getProjectProposer(),
              invite.getSender()
            ]);
          }
          context.read<ViewProvider>().pushWidget(FutureBuild(
              future: Provider.of<UserProvider>(context, listen: false)
                  .updateListUsers(users),
              newView: ListOfInvites(invites: invites)));
          break;
        }
    }
  }
}
