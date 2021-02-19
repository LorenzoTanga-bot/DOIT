import 'package:doit/model/Invite.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/widget/CardListInvite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListInvites extends StatelessWidget {
  final List<Invite> invites;
  const ListInvites({Key key, @required this.invites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: invites.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              child: CardListInvite(invite: invites[index]),
              onTap: () {
                
              });
        });
  }
}
