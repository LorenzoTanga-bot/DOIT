import 'package:doit/model/Invite.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/providers/InviteProvider.dart';
import 'package:doit/providers/ProjectProvider.dart';

import 'package:doit/widget/InviteOverview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardListInvite extends StatefulWidget {
  final String id;

  const CardListInvite({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  _CardListInvite createState() => _CardListInvite();
}

class _CardListInvite extends State<CardListInvite> {
  Widget build(BuildContext context) {
    Invite invite = context.watch<InviteProvider>().findById(widget.id);
    String state = invite.getState().toString();
    state = state.substring(state.indexOf(".") + 1);
    DateTime date = DateTime.parse(invite.getDateOfInvite());
    String dateString =
        "${date.day}" + "/" + "${date.month}" + "/" + "${date.year}";

    Project project =
        context.read<ProjectProvider>().findById(invite.getProject());
    return GestureDetector(
      child: Card(
         elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
                title: Text("project : " + project.getName()),
                subtitle: Text("sent : " + dateString),
                trailing: Text(state)),
          ],
        ),
      ),
      onTap: () => {
        showDialog(
            context: context,
            builder: (context) {
              return InviteOverview(
                invite: invite,
               
              );
            })
      },
    );
  }
}
