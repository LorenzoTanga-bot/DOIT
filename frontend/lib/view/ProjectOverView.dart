import 'package:doit/model/Project.dart';
import 'package:doit/model/Tag.dart';
import 'package:doit/model/User.dart';
import 'package:doit/providers/ProjectProvider.dart';
import 'package:doit/providers/TagProvider.dart';
import 'package:doit/providers/UserProvider.dart';
import 'package:doit/widget/LoadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectOverView extends StatefulWidget {
  final String id;

  const ProjectOverView({Key key, this.id}) : super(key: key);

  @override
  _ProjectOverView createState() => _ProjectOverView();
}

class _ProjectOverView extends State<ProjectOverView> {
  Project _project;
  List<Tag> _listTag;
  User _projectProposer;

  String _getDate(String type) {
    DateTime date;
    switch (type) {
      case "dStart":
        date = DateTime.parse(_project.getDateOfStart());
        break;
      case "dEnd":
        date = DateTime.parse(_project.getDateOfEnd());
        break;
      case "cStart":
        date = DateTime.parse(_project.getStartCandidacy());
        break;
      case "cEnd":
        date = DateTime.parse(_project.getEndCandidacy());
    }
    return "${date.day} / ${date.month} / ${date.year}";
  }

  Future _uploadData() async {
    List<String> users = [_project.getProjectProposer()];
    await Provider.of<UserProvider>(context, listen: false)
        .updateListUsers(users);
    _projectProposer = Provider.of<UserProvider>(context, listen: false)
        .findUserById(_project.getProjectProposer());
  }

  @override
  void initState() {
    super.initState();
    _project = context.read<ProjectProvider>().findById(widget.id);
    _listTag = context.read<TagProvider>().getTagsByIds(_project.getTag());
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
            return ListView(
              children: [
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              color: Colors.white,
                              height: 5,
                              thickness: 1,
                              indent: 2,
                              endIndent: 2,
                            ),
                            Text(
                              _project.getName(),
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
                            Text(
                              "${_projectProposer.getName()} ${_projectProposer.getSurname()}",
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            Divider(
                              color: Colors.white,
                              height: 5,
                              thickness: 1,
                              indent: 2,
                              endIndent: 2,
                            ),
                            Text(
                                "Date: ${_getDate("dStart")} - ${_getDate("dEnd")}"),
                            Divider(
                              color: Colors.grey,
                              height: 10,
                              thickness: 1,
                              indent: 0,
                              endIndent: 0,
                            ),
                            Text(_project.getShortDescription()),
                            Align(
                                alignment: Alignment.centerRight,
                                child: FlatButton.icon(
                                  icon: Icon(Icons.info),
                                  label: Text('More Info'),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              scrollable: true,
                                              title: Text(_project.getName(),
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontStyle:
                                                          FontStyle.italic)),
                                              content: Text(
                                                  _project.getDescription()));
                                        });
                                  },
                                )),
                          ],
                        ))),
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(
                                color: Colors.white,
                                height: 5,
                                thickness: 1,
                                indent: 2,
                                endIndent: 2,
                              ),
                              Text("Designer",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Divider(
                                color: Colors.grey,
                                height: 20,
                                thickness: 1,
                                indent: 2,
                                endIndent: 2,
                              ),
                              Container(
                                height: 25,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: <Widget>[
                                    Text("Designer"),
                                    Padding(padding: EdgeInsets.all(5.00)),
                                    Text("Designer"),
                                    Padding(padding: EdgeInsets.all(5.00)),
                                    Text("Designer"),
                                    Padding(padding: EdgeInsets.all(5.00)),
                                    Text("Designer"),
                                    Padding(padding: EdgeInsets.all(5.00)),
                                    Text("Designer"),
                                    Padding(padding: EdgeInsets.all(5.00)),
                                    Text("Designer"),
                                    Padding(padding: EdgeInsets.all(5.00)),
                                    Text("Designer"),
                                    Padding(padding: EdgeInsets.all(5.00)),
                                    Text("Designer"),
                                    Padding(padding: EdgeInsets.all(5.00)),
                                    Text("Designer"),
                                    Padding(padding: EdgeInsets.all(5.00)),
                                    Text("Designer"),
                                    Padding(padding: EdgeInsets.all(5.00)),
                                    Text("Designer"),
                                    Padding(padding: EdgeInsets.all(5.00)),
                                    Text("Designer"),
                                  ],
                                ),
                              )
                            ]))),
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(
                                color: Colors.white,
                                height: 5,
                                thickness: 1,
                                indent: 2,
                                endIndent: 2,
                              ),
                              Text("Tag",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Divider(
                                color: Colors.grey,
                                height: 20,
                                thickness: 1,
                                indent: 2,
                                endIndent: 2,
                              ),
                              Container(
                                  height: 25,
                                  child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: <Widget>[])),
                            ])))
              ],
            );
        }
        return null;
      },
    );
  }
}
