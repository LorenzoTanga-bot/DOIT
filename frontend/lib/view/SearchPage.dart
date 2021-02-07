import 'package:doit/model/Project.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ListAllProjects.dart';
import 'package:doit/view/ListOfProjects.dart';
import 'package:doit/view/ProfileDoubleRoleOverView.dart';
import 'package:doit/view/ProjectOverView.dart';
import 'package:doit/view/projectproposer/CreateModifyProject.dart';
import 'package:doit/widget/CardList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPage createState() => new _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  final List<Project> projects = [];
  List<Project> projectsFind = [];
  final List<User> users = [];
  List<User> usersFind = [];
  bool searchUser = true;
  bool searchDesigner = true;
  bool searchProjectProposer = true;
  bool searchProject = true;

  void buildSuggestions(BuildContext context, String query) async {
    if (query.isEmpty) {
      projectsFind = [];
      usersFind = [];
    } else {
      searchProjects(query);
      await searchUsers(query, context);
      setState(() {});
    }
  }

  void searchProjects(String query) {
    List<Project> projectsTemp = [];
    projectsTemp.addAll(
        Provider.of<ProjectProvider>(context, listen: false).findByName(query));
    projectsFind = projectsTemp;
  }

  Future searchUsers(String query, BuildContext context) async {
    List<User> usersTemp = [];
    usersTemp.addAll(await Provider.of<UserProvider>(context, listen: false)
        .findByUsername(query, "null"));
    usersFind = usersTemp;
  }

  Widget buildResults(BuildContext context) {
    return ListOfProjects(
      projects: projectsFind,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val) {
                buildSuggestions(context, val);
              },
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.filter_alt),
                    iconSize: 20.0,
                    onPressed: () =>
                        showDialog(context: context), //metere apposto qui
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search by name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0))),
            ),
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
                      (ListOfProjects(projects: projectsFind)),
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
                                      .pushWidget(ProfileDoubleRoleOverView(
                                          id: usersFind[index].getId()));
                                });
                          })
                    ]))
        ],
      ),
    );
  }
}
