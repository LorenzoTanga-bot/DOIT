import 'package:doit/model/Project.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/SearchProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ProfileOverView.dart';
import 'package:doit/widget/CardList.dart';
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

  List<User> usersFind = [];

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
    if (Provider.of<SearchProvider>(context, listen: false)
        .getSearchProject()) {
      List<Project> projectsTemp = [];
      projectsTemp.addAll(Provider.of<ProjectProvider>(context, listen: false)
          .findByName(query));
      projectsFind = projectsTemp;
    }
  }

  Future searchUsers(String query, BuildContext context) async {
    if (Provider.of<SearchProvider>(context, listen: false).getSearchUser()) {
      List<User> usersTemp = [];
      usersTemp.addAll(await Provider.of<UserProvider>(context, listen: false)
          .findByUsername(query, "null"));
      usersFind = usersTemp;
      if (Provider.of<SearchProvider>(context, listen: false)
          .getSearchDesigner()) {
        List<User> usersTemp = [];
        usersTemp.addAll(await Provider.of<UserProvider>(context, listen: false)
            .findByUsername(query, "DESIGNER"));
        usersFind = usersTemp;
      }
      if (Provider.of<SearchProvider>(context, listen: false)
          .getSearchProjectProposer()) {
        List<User> usersTemp = [];
        usersTemp.addAll(await Provider.of<UserProvider>(context, listen: false)
            .findByUsername(query, "PROJECT_PROPOSER"));
        usersFind = usersTemp;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (val) {
                  buildSuggestions(context, val);
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.only(left: 25.0),
                    hintText: 'Search by name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0))),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                ])),
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
                                            user: usersFind[index]));
                                  });
                            })
                      ]))
          ],
        ));
  }
}
