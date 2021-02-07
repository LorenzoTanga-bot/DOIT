import 'package:doit/model/Project.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/view/ListOfProjects.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListAllProjects extends StatefulWidget {
  @override
  _ListAllProjectsState createState() => _ListAllProjectsState();
}

class _ListAllProjectsState extends State<ListAllProjects> {
  List<Project> _projects;
  @override
  Widget build(BuildContext context) {
    _projects = context.read<ProjectProvider>().getListAllProject();
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [ListOfProjects(projects: _projects)]);
  }
}
