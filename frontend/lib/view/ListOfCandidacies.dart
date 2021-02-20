import 'package:doit/model/Candidacy.dart';
import 'package:doit/widget/ListCandidacies.dart';
import 'package:flutter/material.dart';

class ListOfCandidacy extends StatefulWidget {
  final List<Candidacy> candidacies;

  const ListOfCandidacy({Key key, @required this.candidacies})
      : super(key: key);
  @override
  _ListOfCandidacy createState() => _ListOfCandidacy();
}

class _ListOfCandidacy extends State<ListOfCandidacy> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 20,
        height: MediaQuery.of(context).size.height - 20,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Candidacies",
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
          ListCandidacies(candidacies: widget.candidacies)
        ]));
  }
}
