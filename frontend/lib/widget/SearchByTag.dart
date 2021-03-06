import 'dart:collection';

import 'package:doit/model/Project.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/SearchProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ProfileOverView.dart';
import 'package:doit/widget/FutureBuilder.dart';
import 'package:doit/widget/SearchFilter.dart';
import 'package:flutter/gestures.dart';
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
  void buildSuggestions(BuildContext context) async {
    List<String> tags =
        Provider.of<TagProvider>(context, listen: false).getSelectTag("SEARCH");
    if (tags.isNotEmpty) {
      await searchProjects(tags);
      await searchUsers(tags, context);
      setState(() {});
    }
  }

  Future searchProjects(List<String> tags) async {
    if (Provider.of<SearchProvider>(context, listen: false)
        .getSearchProject()) {
      List<Project> projectsTemp = [];
      projectsTemp.addAll(
          await Provider.of<ProjectProvider>(context, listen: false)
              .findByTags(tags));
      projectsFind = projectsTemp;
    } else
      projectsFind = [];
  }

  Future searchUsers(List<String> tags, BuildContext context) async {
    if (Provider.of<SearchProvider>(context, listen: false).getSearchUser()) {
      Set<User> usersTemp = new HashSet();
      if (Provider.of<SearchProvider>(context, listen: false)
              .getSearchDesigner() &&
          Provider.of<SearchProvider>(context, listen: false)
              .getSearchProjectProposer()) {
        usersTemp.addAll(await Provider.of<UserProvider>(context, listen: false)
            .findByTags(tags, "null"));
        usersFind = usersTemp.toList();
      } else if (Provider.of<SearchProvider>(context, listen: false)
          .getSearchDesigner()) {
        usersTemp.addAll(await Provider.of<UserProvider>(context, listen: false)
            .findByTags(tags, "DESIGNER"));
        usersFind = usersTemp.toList();
      } else {
        usersTemp.addAll(await Provider.of<UserProvider>(context, listen: false)
            .findByTags(tags, "PROJECT_PROPOSER"));
        usersFind = usersTemp.toList();
      }
    } else
      usersFind = [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                        child: new SmartSelectTag(
                            title: "Select Tags", index: "SEARCH")),
                    Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () => buildSuggestions(context)))
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                  Icon(
                    Icons.filter_alt,
                    color: Colors.blue,
                  )
                ]),
                if (projectsFind.isNotEmpty)
                  Text(
                    "Projects",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                Divider(
                  color: Colors.white,
                  height: 5,
                  thickness: 1,
                  indent: 2,
                  endIndent: 2,
                ),
                (Container(
                    constraints: BoxConstraints(maxHeight: 250),
                    child: ListProjects(projects: projectsFind))),
                if (usersFind.isNotEmpty)
                  Text(
                    "Users",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                Divider(
                  color: Colors.white,
                  height: 5,
                  thickness: 1,
                  indent: 2,
                  endIndent: 2,
                ),
                Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: usersFind.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              child: CardList(
                                  name: usersFind[index].getUsername(),
                                  sDescription: usersFind[index].getName() +
                                      " " +
                                      usersFind[index].getSurname()),
                              onTap: () {
                                Provider.of<ViewProvider>(context,
                                        listen: false)
                                    .pushWidget(FutureBuild(
                                        future: Future.wait([
                                          Provider.of<ProjectProvider>(context,
                                                  listen: false)
                                              .findByProjectProposer(
                                                  usersFind[index]
                                                      .getMail()),
                                          Provider.of<ProjectProvider>(context,
                                                  listen: false)
                                              .findByDesigner(usersFind[
                                                      index]
                                                  .getMail()),
                                          Provider.of<TagProvider>(context,
                                                  listen: false)
                                              .updateListTag(
                                                  usersFind[index].getTags())
                                        ]),
                                        newView: ProfileOverView(
                                            user: usersFind[index])));
                              });
                        }))
              ],
            )));
  }
}
