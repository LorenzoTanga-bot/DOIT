import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  final String name;
  final String sDescription;
  final String id;

  const CardList({Key key, this.name, this.sDescription, this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(name),
            subtitle: Text(sDescription),
          ),
        ],
      ),
    );
  }
}
