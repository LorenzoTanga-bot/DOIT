import 'package:doit/model/Project.dart';
import 'package:doit/model/Tag.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ProfileOverView.dart';
import 'package:doit/widget/CardList.dart';
import 'package:doit/widget/ListProjects.dart';
import 'package:doit/widget/SmartSelectTag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPage createState() => new _SearchPage();
}

class _SearchPage extends State<SearchPage> with TickerProviderStateMixin {
  final List<Project> projects = [];
  List<Project> projectsFind = [];
  final List<User> users = [];
  List<User> usersFind = [];
  bool searchUser = true;
  bool searchDesigner = true;
  bool searchProjectProposer = true;
  bool searchProject = true;
  TabController tabController;

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

  void searchProjectsByTags(List<String> tags) async {
    List<Project> projectsTemp = [];
    projectsTemp.addAll(
        await Provider.of<ProjectProvider>(context, listen: false)
            .findByTags(tags));
    projectsFind = projectsTemp;
  }

  Future searchUsers(String query, BuildContext context) async {
    List<User> usersTemp = [];
    usersTemp.addAll(await Provider.of<UserProvider>(context, listen: false)
        .findByUsername(query, "null"));
    usersFind = usersTemp;
  }

  Widget buildResults(BuildContext context) {
    return ListProjects(
      projects: projectsFind,
    );
  }

  @override
  Widget build(BuildContext context) {
    tabController = new TabController(length: 2, vsync: this);

    return Scaffold(
      appBar: new TabBar(
        controller: tabController,
        tabs: [
          new Tab(
            child: Text(
              "by Name",
              style: TextStyle(color: Colors.blue),
            ),
          ),
          new Tab(
            child: Text("by Tags", style: TextStyle(color: Colors.blue)),
          )
        ],
      ),
      body: new TabBarView(controller: tabController, children: [
        Column(
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
          ],
        ),
        Column(children: [
          new SmartSelectTag(
            title: "Select Tags",
          ),
        ])
      ]),
    );
  }
}
