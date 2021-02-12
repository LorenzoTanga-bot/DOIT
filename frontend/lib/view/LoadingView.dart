import 'package:doit/view/HomePage.dart';
import 'package:doit/widget/LoadingScreen.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatefulWidget {
  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  //Provider.of<ProjectProvider>(context, listen: false).updateListAllProject()
  Future _uploadData() async {
    await Future.wait([]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _uploadData(),
      builder: (context, data) {
        switch (data.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return LoadingScreen(message: "Loading");
          case ConnectionState.done:
            return HomePage();
        }
        return null;
      },
    );
  }
}
