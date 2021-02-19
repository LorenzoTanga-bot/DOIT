import 'package:doit/model/Invite.dart';
import 'package:doit/widget/ListInvites.dart';
import 'package:flutter/material.dart';

class ListOfInvites extends StatefulWidget {
  final List<Invite> invites;

  const ListOfInvites({Key key, @required this.invites}) : super(key: key);
  @override
  _ListOfInvites createState() => _ListOfInvites();
}

class _ListOfInvites extends State<ListOfInvites> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Invites",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: Colors.white,
            height: 5,
            thickness: 1,
            indent: 2,
            endIndent: 2,
          ),
          ListInvites(invites: widget.invites)
        ]));
  }
}
