import 'package:doit/model/Project.dart';
import 'package:doit/widget/ListProjects.dart';
import 'package:flutter/material.dart';

class ListOfProjects extends StatefulWidget {
  final List<Project> projects;
  final bool isTheProjectProposer;

  const ListOfProjects(
      {Key key, @required this.projects, @required this.isTheProjectProposer})
      : super(key: key);
  @override
  _ListOfProjects createState() => _ListOfProjects();
}

class _ListOfProjects extends State<ListOfProjects> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          if (widget.isTheProjectProposer)
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Proposed Project",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Partecipated in project",
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
          if (widget.projects.isEmpty)
            if (widget.isTheProjectProposer)
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "You have no proposed project at the moment",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "You have no partecipate in project at the moment",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
          ListProjects(projects: widget.projects)
        ]));
  }
}
