import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
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
    _listView.addAll([
      Text("PROJECT PROPOSER"),
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
          onTap: () => {}),
      GestureDetector(
          child:
              CardList(name: "Invites", sDescription: "View all invites sent"),
          onTap: () => {}),
      GestureDetector(
          child: CardList(
              name: "Proposed project",
              sDescription: "View all proposed project"),
          onTap: () => {}),
    ]);
  }

  _designer() {
    _listView.addAll([
      Text("DESIGNER"),
      GestureDetector(
        child: CardList(
            name: "Candidature", sDescription: "View all candidacy sent"),
        onTap: () => context.read<ViewProvider>().pushWidget(null),
      ),
      GestureDetector(
        child: CardList(
            name: "Invites", sDescription: "View all invites recieved"),
        onTap: () => context.read<ViewProvider>().pushWidget(null),
      ),
    ]);
  }

  _expert() {
    _listView.addAll([
      Text("EXPERT"),
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
}
