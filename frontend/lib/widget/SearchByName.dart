import 'dart:collection';

import 'package:doit/model/Project.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/SearchProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ProfileOverView.dart';
import 'package:doit/widget/CardList.dart';
import 'package:doit/widget/FutureBuilder.dart';
import 'package:doit/widget/SearchFilter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ListProjects.dart';

class SearchByName extends StatefulWidget {
  @override
  _SearchByName createState() => _SearchByName();
}

class _SearchByName extends State<SearchByName> {
  final List<Project> projects = [];
  List<Project> projectsFind = [];
  final List<User> users = [];
  String query = "";
  List<User> usersFind = [];
  bool searchProject = true;
  bool searchUser = true;
  bool searchDesigner = true;
  bool searchProjectProposer = true;
  void buildSuggestions(BuildContext context, String query) async {
    if (query.isEmpty) {
      setState(() {
        projectsFind = [];
        usersFind = [];
      });
    } else {
      searchProjects(query);
      await searchUsers(query, context);
      setState(() {});
    }
  }

  void searchProjects(String query) {
    List<Project> projectsTemp = [];
    if (searchProject) {
      projectsTemp = (Provider.of<ProjectProvider>(context, listen: false)
          .findByName(query));
    }
    projectsFind = projectsTemp;
  }

  Future searchUsers(String query, BuildContext context) async {
    if (searchUser) {
      Set<User> usersTemp = new HashSet();
      if (searchDesigner && searchProjectProposer) {
        usersTemp.addAll(await Provider.of<UserProvider>(context, listen: false)
            .findByUsername(query, "null"));
        usersFind = usersTemp.toList();
      } else if (searchDesigner) {
        usersTemp.addAll(await Provider.of<UserProvider>(context, listen: false)
            .findByUsername(query, "DESIGNER"));
        usersFind = usersTemp.toList();
      } else {
        usersTemp.addAll(await Provider.of<UserProvider>(context, listen: false)
            .findByUsername(query, "PROJECT_PROPOSER"));
        usersFind = usersTemp.toList();
      }
    } else
      usersFind = [];
  }

  void checkFilter() {
    bool tempSearchProjetc = context.watch<SearchProvider>().getSearchProject();
    bool tempSearchUser = context.watch<SearchProvider>().getSearchUser();
    bool tempSearchDesigner =
        context.watch<SearchProvider>().getSearchDesigner();
    bool tempSearchProjectProposer =
        context.watch<SearchProvider>().getSearchProjectProposer();
    if (searchProject != tempSearchProjetc ||
        searchUser != tempSearchUser ||
        searchDesigner != tempSearchDesigner ||
        searchProjectProposer != tempSearchProjectProposer) {
      searchProject = tempSearchProjetc;
      searchUser = tempSearchUser;
      searchDesigner = tempSearchDesigner;
      searchProjectProposer = tempSearchProjectProposer;
      buildSuggestions(context, query);
    }
  }

  @override
  Widget build(BuildContext context) {
    checkFilter();
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                        onChanged: (val) {
                          query = val;
                          buildSuggestions(context, val);
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            contentPadding: EdgeInsets.only(left: 25.0),
                            hintText: 'Search by name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                      )),
                      Padding(
                          padding: EdgeInsets.only(left: 3),
                          child: Icon(
                            Icons.filter_alt,
                            color: Colors.blue,
                          )),
                      RichText(
                        text: TextSpan(
                            text: ("Filtra"),
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SearchFilter();
                                    });
                              }),
                      ),
                    ],
                  ),
                  if (projectsFind.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        "Projects",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (projectsFind.isNotEmpty)
                    Divider(
                      color: Colors.grey,
                      height: 20,
                      thickness: 1,
                      indent: 2,
                      endIndent: 2,
                    ),
                  (Container(
                      constraints: BoxConstraints(maxHeight: 250),
                      child: ListProjects(projects: projectsFind))),
                  Divider(
                    color: Colors.white70,
                    height: 20,
                    thickness: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
                  if (usersFind.isNotEmpty)
                    Text(
                      "Users",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  if (usersFind.isNotEmpty)
                    Divider(
                      color: Colors.grey,
                      height: 20,
                      thickness: 1,
                      indent: 2,
                      endIndent: 2,
                    ),
                  Expanded(
                      child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: usersFind.length,
                    itemBuilder: (context, index) {
                      if (usersFind[index].getIsAPerson())
                        return GestureDetector(
                            child: CardList(
                                name: usersFind[index].getUsername(),
                                sDescription: usersFind[index].getName() +
                                    " " +
                                    usersFind[index].getSurname()),
                            onTap: () {
                              Provider.of<ViewProvider>(context, listen: false)
                                  .pushWidget(FutureBuild(
                                      future: Future.wait([
                                        Provider.of<ProjectProvider>(context,
                                                listen: false)
                                            .findByProjectProposer(
                                                usersFind[index].getMail()),
                                        Provider.of<ProjectProvider>(context,
                                                listen: false)
                                            .findByDesigner(
                                                usersFind[index].getMail()),
                                        Provider.of<TagProvider>(context,
                                                listen: false)
                                            .updateListTag(
                                                usersFind[index].getTags())
                                      ]),
                                      newView: ProfileOverView(
                                          user: usersFind[index].getMail())));
                            });
                      else
                        return GestureDetector(
                            child: CardList(
                                name: usersFind[index].getUsername(),
                                sDescription: usersFind[index].getName()),
                            onTap: () {
                              Provider.of<ViewProvider>(context, listen: false)
                                  .pushWidget(FutureBuild(
                                      future: Future.wait([
                                        Provider.of<ProjectProvider>(context,
                                                listen: false)
                                            .findByProjectProposer(
                                                usersFind[index].getMail()),
                                        Provider.of<ProjectProvider>(context,
                                                listen: false)
                                            .findByDesigner(
                                                usersFind[index].getMail()),
                                        Provider.of<TagProvider>(context,
                                                listen: false)
                                            .updateListTag(
                                                usersFind[index].getTags())
                                      ]),
                                      newView: ProfileOverView(
                                          user: usersFind[index].getMail())));
                            });
                    },
                  ))
                ])));
  }
}
