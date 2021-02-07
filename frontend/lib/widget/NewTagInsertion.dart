import 'package:doit/model/Tag.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewTagInsertion extends StatelessWidget {
  final BuildContext context;

  final TextEditingController _valueTag = TextEditingController();

  NewTagInsertion({Key key, @required this.context}) : super(key: key);

  _createTag() async {
    Tag newTag = new Tag(_valueTag.text);
    bool controller = true;
    for (Tag tag
        in Provider.of<TagProvider>(context, listen: false).getListTag())
      if (tag.getValue() == newTag.getValue()) {
        controller = false;
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Attetion"),
                content: Text("Tag already exist"),
              );
            });
        break;
      }

    if (controller) {
      Navigator.pop(context, true);
      Provider.of<TagProvider>(context, listen: false).addListTag(newTag);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New Tag"),
      content: TextField(
          controller: _valueTag,
          decoration: InputDecoration(labelText: 'Tag\'s name')),
      actions: <Widget>[
        MaterialButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context, true)),
        MaterialButton(
            child: Text("Create"),
            onPressed: () {
              if (_valueTag.text.isEmpty) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Attetion"),
                        content: Text("Fill field before creating a new tag"),
                      );
                    });
              } else {
                _createTag();
              }
            })
      ],
    );
  }
}
