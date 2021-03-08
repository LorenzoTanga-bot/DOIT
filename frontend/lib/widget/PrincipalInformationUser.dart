import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/Tag.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/widget/ListTags.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrincipalInformationUser extends StatelessWidget {
  final User user;
  final List<Tag> tags;

  const PrincipalInformationUser(
      {Key key, @required this.user, @required this.tags})
      : super(key: key);
  Widget getRoles(BuildContext context) {
    User userAuthenticated = context.read<AuthCredentialProvider>().getUser();
    if (userAuthenticated == null ||
        user.getMail() != userAuthenticated.getMail()) {
      if (user.getRoles().contains(UserRole.EXPERT)) {
        List<UserRole> role = user.getRoles();
        role.remove(UserRole.EXPERT);
        return Row(children: [
          Text("Role : "),
          Text(getStringRole(role.first)),
        ]);
      }
    }
    return Row(children: [
      if (user.getRoles().length == 1) Text("Role : ") else Text("Roles : "),
      Text(getStringRole(user.getRoles().first)),
      if (user.getRoles().length == 2)
        Text(", " + getStringRole(user.getRoles().last))
    ]);
  }

  // ignore: missing_return
  String getStringRole(UserRole role) {
    if (role == UserRole.EXPERT) return "Expert";
    if (role == UserRole.DESIGNER_ENTITY || role == UserRole.DESIGNER_PERSON)
      return "Designer";
    if (role == UserRole.PROJECT_PROPOSER) return "ProjectProposer";
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        (user.getUsername()),
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
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
                    getRoles(context),
                    Divider(
                      color: Colors.white,
                      height: 5,
                      thickness: 1,
                      indent: 2,
                      endIndent: 2,
                    ),
                    Row(children: [
                      Text("Name : "),
                      Text(
                        user.getName(),
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
                        user.getIsAPerson()
                            ? Text("Surname : ")
                            : Text("Partita iva : "),
                        Text(user.getSurname())
                      ],
                    ),
                    Divider(
                      color: Colors.white,
                      height: 5,
                      thickness: 1,
                      indent: 2,
                      endIndent: 2,
                    ),
                    if (user.getBiography().isNotEmpty)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Biography : "),
                          Flexible(child: Text(user.getBiography()))
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
      ListTags(listTag: tags),
    ]);
  }
}
