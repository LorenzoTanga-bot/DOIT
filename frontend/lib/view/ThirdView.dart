import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/Candidacy.dart';
import 'package:doit/model/Invite.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/CandidacyProvider.dart';
import 'package:doit/providers/InviteProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ListOfCandidacies.dart';
import 'package:doit/view/ListOfInvites.dart';
import 'package:doit/view/ProfileOverView.dart';
import 'package:doit/view/projectproposer/CreateModifyProject.dart';
import 'package:doit/widget/CardList.dart';
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
        onTap: () => context
            .read<ViewProvider>()
            .pushWidget(ProfileOverView(mail: _user.getMail())),
      ),
    ]);
  }

  _projectProposer() {
    List<Candidacy> candidacies = [];
    List<Invite> invites = [];
    _listView.addAll([
      Divider(
        color: Colors.white,
        height: 15,
        thickness: 1,
        indent: 2,
        endIndent: 2,
      ),
      Text("PROJECT PROPOSER"),
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
          onTap: () => {}),
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
      Text("DESIGNER"),
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
      Text("EXPERT"),
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
    if (_user.getRoles().contains(UserRole.DESIGNER)) _designer();
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
          context
              .read<ViewProvider>()
              .pushWidget(ListOfCandidacy(candidacies: candidacies));
          break;
        }
      case "PROJECT_PROPOSER":
        {
          candidacies =
              await Provider.of<CandidacyProvider>(context, listen: false)
                  .findByProjectProposer(_user.getMail());
          context
              .read<ViewProvider>()
              .pushWidget(ListOfCandidacy(candidacies: candidacies));
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
          context
              .read<ViewProvider>()
              .pushWidget(ListOfInvites(invites: invites));
          break;
        }
      case "PROJECT_PROPOSER":
        {
          invites = await Provider.of<InviteProvider>(context, listen: false)
              .findByProjectProposer(_user.getMail());
          context
              .read<ViewProvider>()
              .pushWidget(ListOfInvites(invites: invites));
          break;
        }
    }
  }
}
