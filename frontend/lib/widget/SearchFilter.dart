import 'package:flutter/material.dart';

class SearchFilter extends StatelessWidget {
  bool searchUser = true;
  bool searchDesigner = true;
  bool searchProjectProposer = true;
  bool searchProject = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text("Projects"),
                Switch(
                  value: searchProject,
                  onChanged: (value) {
                    {
                      searchProject = value;
                      print(searchProject);
                      setState();
                    }
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                )
              ],
            ),
            Row(children: [
              Text("User"),
              Switch(
                  value: searchUser,
                  onChanged: (bool newValue) {
                    setState() {
                      searchUser = newValue;
                    }
                  })
            ])
          ],
        ),
      ),
    );
  }

  void setState() {}
}
