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

    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(
                color: Colors.white,
                height: 5,
                thickness: 1,
                indent: 2,
                endIndent: 2,
              ),
              Text("Tag",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              Divider(
                color: Colors.grey,
                height: 20,
                thickness: 1,
                indent: 2,
                endIndent: 2,
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                    height: 35,
                    child: ListView(
                      padding: EdgeInsets.all(10),
                      children: tags,
                      scrollDirection: Axis.horizontal,
                    )),
              )
            ]));
  }
}
