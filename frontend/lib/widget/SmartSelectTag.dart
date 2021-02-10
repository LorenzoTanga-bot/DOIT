import 'package:doit/providers/TagProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';

class SmartSelectTag extends StatefulWidget {
  final String title;
  final String index;
  SmartSelectTag({Key key, @required this.title, @required this.index})
      : super(key: key);

  _SmartSelectTag createState() => _SmartSelectTag();
}

class _SmartSelectTag extends State<SmartSelectTag> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TagProvider>(builder: (context, tag, child) {
      return SmartSelect<String>.multiple(
        title: widget.title,
        value: tag.getSelectTag(widget.index),
        onChange: (state) =>
            setState(() => tag.setSelectTag(state.value, widget.index)),
        choiceItems: S2Choice.listFrom<String, Map<String, String>>(
          source: tag.getListMapTag(),
          value: (index, item) => item['id'],
          title: (index, item) => item['value'],
        ),
        choiceType: S2ChoiceType.switches,
        modalType: S2ModalType.bottomSheet,
        modalFilter: true,
        tileBuilder: (context, state) {
          return S2Tile.fromState(
            state,
            isTwoLine: true,
            leading: Container(
              width: 30,
              alignment: Alignment.center,
              child: Icon(Icons.tag),
            ),
          );
        },
      );
    });
  }
}
