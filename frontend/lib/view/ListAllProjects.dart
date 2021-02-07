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
  void initState() { 
    super.initState();
    _projects = context.read<ProjectProvider>().getListAllProject();
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [ListOfProjects(projects: _projects)]);
  }
}
