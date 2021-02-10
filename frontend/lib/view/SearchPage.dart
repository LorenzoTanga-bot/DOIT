
import 'package:doit/widget/SearchByName.dart';
import 'package:doit/widget/SearchByTag.dart';

import 'package:flutter/material.dart';

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
