import 'package:doit/model/Project.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ProfileOverView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CardList.dart';
import 'ListProjects.dart';
import 'SmartSelectTag.dart';

class SearchByTag extends StatefulWidget {
  @override
  _SearchByTag createState() => _SearchByTag();
}

class _SearchByTag extends State<SearchByTag> {
  final List<Project> projects = [];
  List<Project> projectsFind = [];
  final List<User> users = [];
  List<User> usersFind = [];
  bool searchUser = true;
  bool searchDesigner = true;
  bool searchProjectProposer = true;
  bool searchProject = true;

  void searchProjectsByTags(List<String> tags) async {
    List<Project> projectsTemp = [];
    projectsTemp.addAll(
        await Provider.of<ProjectProvider>(context, listen: false)
            .findByTags(tags));
    projectsFind = projectsTemp;
  }

  @override
  void initState() {
    super.initState();
    Provider.of<TagProvider>(context, listen: false).setSelectTag([]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(children: [
          new SmartSelectTag(
            title: "Select Tags",
          ),
          if (projectsFind.isNotEmpty)
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Projects",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.white,
                        height: 5,
                        thickness: 1,
                        indent: 2,
                        endIndent: 2,
                      ),
                      (ListProjects(projects: projectsFind)),
                    ])),
          if (usersFind.isNotEmpty)
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Users",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.white,
                        height: 5,
                        thickness: 1,
                        indent: 2,
                        endIndent: 2,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: usersFind.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                child: CardList(
                                    name: usersFind[index].getUsername(),
                                    sDescription: usersFind[index].getName() +
                                        usersFind[index].getSurname()),
                                onTap: () {
                                  Provider.of<ViewProvider>(context,
                                          listen: false)
                                      .pushWidget(ProfileOverView(
                                          id: usersFind[index].getId()));
                                });
                          })
                    ]))
        ]));
  }
}
