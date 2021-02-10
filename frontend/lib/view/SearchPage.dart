import 'package:doit/model/Project.dart';
import 'package:doit/model/Tag.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/ProfileOverView.dart';
import 'package:doit/widget/CardList.dart';
import 'package:doit/widget/CardListProject.dart';
import 'package:doit/widget/ListProjects.dart';
import 'package:doit/widget/NewTagInsertion.dart';
import 'package:doit/widget/SearchByName.dart';
import 'package:doit/widget/SearchByTag.dart';
import 'package:doit/widget/SmartSelectTag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPage createState() => new _SearchPage();
}

class _SearchPage extends State<SearchPage> with TickerProviderStateMixin {
  TabController tabController;
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
        body: new TabBarView(
            controller: tabController,
            children: [SearchByName(), SearchByTag()]));
  }
}
