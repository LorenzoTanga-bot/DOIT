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
    return Card(
        margin: EdgeInsets.all(15),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        color: Colors.white,
                        height: 5,
                        thickness: 1,
                        indent: 2,
                        endIndent: 2,
                      ),
                      Text("Tag",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold))
                    ])),
            Divider(
              color: Colors.grey,
              height: 20,
              thickness: 1,
              indent: 2,
              endIndent: 2,
            ),
            Container(
                height: 25,
                child: ListView(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  children: tags,
                  scrollDirection: Axis.horizontal,
                )),
          ],
        ));
  }
}
