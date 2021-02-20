import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/Invite.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/AuthCredentialProvider.dart';
import 'package:doit/providers/InviteProvider.dart';

import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';

import 'package:doit/view/ProjectOverView.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InviteOverview extends StatefulWidget {
  final Invite invite;

  const InviteOverview({Key key, @required this.invite}) : super(key: key);

  @override
  _InviteOverview createState() => _InviteOverview();
}

class _InviteOverview extends State<InviteOverview> {
  Project project;
  String dateString;
  String dateOfExpireString;
  String state;

  void  initState()  {
    super.initState();
    
    project = Provider.of<ProjectProvider>(context, listen: false)
        .findById(widget.invite.getProject());
    state = widget.invite.getState().toString();
    state = state.substring(state.indexOf(".") + 1);
    DateTime date = DateTime.parse(widget.invite.getDateOfInvite());
    dateString = "${date.day}" + "/" + "${date.month}" + "/" + "${date.year}";
    DateTime dateOfExpire = DateTime.parse(widget.invite.getDateOfExpire());
    dateOfExpireString = "${dateOfExpire.day}" +
        "/" +
        "${dateOfExpire.month}" +
        "/" +
        "${dateOfExpire.year}";
  }

  bool isTheProjectProposer() {
    if (widget.invite.getStateProjectProposer() == StateInvite.WAITING) {
      User user = context.read<AuthCredentialProvider>().getUser();
      if (user == null) return false;
      return widget.invite.getProjectProposer() == user.getMail();
    }
    return false;
  }

  bool isTheInviteSentByDesigner() {
    if (Provider.of<UserProvider>(context, listen: false)
        .findByMail(widget.invite.getSender())
        .getRoles()
        .contains(UserRole.DESIGNER_ENTITY)) {
      return isTheProjectProposer();
    }
  }

  bool isTheDesigner() {
    if (widget.invite.getStateDesigner() == StateInvite.WAITING) {
      User user = context.read<AuthCredentialProvider>().getUser();
      if (user == null) return false;
      return widget.invite.getDesigner() == user.getMail();
    }
    return false;
  }

  void acceptInvite() async {
    if (Provider.of<AuthCredentialProvider>(context, listen: false)
            .getUser()
            .getMail() ==
        widget.invite.getProjectProposer()) {
      widget.invite.setStateProjectProposer(StateInvite.POSITIVE);
      await Provider.of<InviteProvider>(context, listen: false)
          .updateStateProjectProposer(widget.invite);
    } else {
      widget.invite.setStateDesigner(StateInvite.POSITIVE);
      await Provider.of<InviteProvider>(context, listen: false)
          .updateStateDesigner(widget.invite);
    }
  }

  void declineInvite() async {
    if (Provider.of<AuthCredentialProvider>(context, listen: false)
            .getUser()
            .getMail() ==
        widget.invite.getProjectProposer()) {
      widget.invite.setStateProjectProposer(StateInvite.NEGATIVE);
      await Provider.of<InviteProvider>(context, listen: false)
          .updateStateProjectProposer(widget.invite);
    } else {
      widget.invite.setStateDesigner(StateInvite.NEGATIVE);
      await Provider.of<InviteProvider>(context, listen: false)
          .updateStateDesigner(widget.invite);
    }
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
            padding: EdgeInsets.only(right: 15),
            child: Align(
                alignment: Alignment.bottomRight,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () => {acceptInvite(), Navigator.pop(context)},
                  child: Text("Accetta"),
                ))),
        Padding(
            padding: EdgeInsets.only(right: 15),
            child: Align(
                alignment: Alignment.bottomRight,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () => {declineInvite(), Navigator.pop(context)},
                  child: Text("Rifiuta"),
                ))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Text("Invite"),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text("Project: "),
                RichText(
                    text: TextSpan(
                        text: (project.getName()),
                        style: TextStyle(color: Colors.black),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                            Provider.of<ViewProvider>(context, listen: false)
                                .pushWidget(ProjectOverView(project: project));
                          }))
              ]),
              Divider(
                color: Colors.white,
                height: 8,
                thickness: 1,
                indent: 2,
                endIndent: 2,
              ),
              Text("Date of send  : $dateString"),
              Divider(
                color: Colors.white,
                height: 8,
                thickness: 1,
                indent: 2,
                endIndent: 2,
              ),
              Text("State : $state"),
              Divider(
                color: Colors.white,
                height: 8,
                thickness: 1,
                indent: 2,
                endIndent: 2,
              ),
              if (widget.invite.getMessage() != null)
                Column(
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Message : "),
                          Flexible(
                              child: Text(
                            widget.invite.getMessage(),
                          ))
                        ]),
                    Divider(
                      color: Colors.white,
                      height: 8,
                      thickness: 1,
                      indent: 2,
                      endIndent: 2,
                    ),
                  ],
                ),
              Text("Date of Expire : $dateOfExpireString "),
              Divider(
                color: Colors.white,
                height: 8,
                thickness: 1,
                indent: 2,
                endIndent: 2,
              )
            ],
          ),
          if (isTheInviteSentByDesigner() || isTheDesigner()) showButton(),
          Divider(
            color: Colors.white,
            height: 8,
            thickness: 1,
            indent: 2,
            endIndent: 2,
          )
        ]));
  }
}
