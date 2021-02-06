import 'package:doit/model/Project.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ListAllProjects.dart';
import 'package:doit/view/ListOfProjects.dart';
import 'package:doit/view/ProjectOverView.dart';
import 'package:doit/view/projectproposer/CreateModifyProject.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPage createState() => new _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  final List<Project> projects = [];
   final recent = [];
  List<Project> find = [];
  final List<User> users=[];

  void buildSuggestions(BuildContext context, String query) {
    if (query.isEmpty) find = [];
    List<Project> sugg = [];
    if (query.isNotEmpty)
      sugg.addAll(Provider.of<ProjectProvider>(context, listen: false)
          .findByName(query));
    find = sugg;
    setState(() {});
  }

  Widget buildResults(BuildContext context) {
    return ListOfProjects(
      projects: find,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: ListView(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              onChanged: (val) {
               buildSuggestions(context, val);
              },
              decoration: InputDecoration(

                  prefixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.filter_9_outlined),
                    iconSize: 20.0,
                    onPressed: () {},
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search by name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0))),
            ),
            SizedBox(
              child: ListOfProjects(projects: find),
              height: 400,
            )
          ],
        ),
      ),
    ]));
  }
}
