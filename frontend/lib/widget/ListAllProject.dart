import 'package:doit/model/Project.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/view/ListOfProjects.dart';
import 'package:doit/widget/CardList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListAllProjects extends StatefulWidget {
  @override
  _ListAllProjects createState() => _ListAllProjects();
}

class _ListAllProjects extends State<ListAllProjects> {
  List<Project> _project;

  @override
  Widget build(BuildContext context) {
    _project = context.watch<ProjectProvider>().getListAllProject();
    return ListOfProjects(allProject: _project);
  }
}
