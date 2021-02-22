import 'package:doit/model/Evaluation.dart';
import 'package:doit/widget/ListEvaluations.dart';

import 'package:flutter/material.dart';

class ListOfEvaluations extends StatefulWidget {
  final List<Evaluation> evaluations;

  const ListOfEvaluations({Key key, @required this.evaluations})
      : super(key: key);
  @override
  _ListOfEvaluations createState() => _ListOfEvaluations();
}

class _ListOfEvaluations extends State<ListOfEvaluations> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Evaluations",
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
          if (widget.evaluations.isEmpty)
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "You have no evaluation at the moment",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ListEvaluations(evaluations: widget.evaluations)
        ]));
  }
}
