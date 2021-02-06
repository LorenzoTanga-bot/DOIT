import 'package:doit/model/Tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ListTags extends StatelessWidget {
  final List<Tag> listTag;

  const ListTags({Key key, @required this.listTag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Text> tags = [];

    for (int i = 0; i < listTag.length - 1; i++) {
      tags.add(Text(listTag[i].getValue() + ", "));
    }
    if (listTag.length > 0) tags.add(Text(listTag.last.getValue()));
    return ListView(
      padding: EdgeInsets.only(left: 10, right: 10),
      children: tags,
      scrollDirection: Axis.horizontal,
    );
  }
}
