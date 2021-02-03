import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/projectproposer/CreateModifyProject.dart';
import 'package:doit/widget/CardList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThreeViewPP extends StatefulWidget {
  @override
  _ThreeView createState() => _ThreeView();
}

class _ThreeView extends State<ThreeViewPP> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Divider(
          color: Colors.white,
          height: 5,
          thickness: 1,
          indent: 2,
          endIndent: 2,
        ),
        RawMaterialButton(
          onPressed: () {},
          elevation: 2.0,
          fillColor: Colors.white,
          child: Icon(
            Icons.person,
            size: 35.0,
          ),
          padding: EdgeInsets.all(15.0),
          shape: CircleBorder(),
        ),
        GestureDetector(
          child:
              CardList(name: "New Project", sDescription: "Create New Project"),
          onTap: () =>
              context.read<ViewProvider>().pushWidget(CreateModifyProject(
                    id: "",
                  )),
        ),
        GestureDetector(
          child: CardList(name: "Profile", sDescription: "Settings"),
          onTap: () => context.read<ViewProvider>().pushWidget(Text("abc")),
        ),
        GestureDetector(
          child: CardList(
              name: "Proposed projects", sDescription: "All projects loaded"),
          onTap: () => context.read<ViewProvider>().pushWidget(Text("abc")),
        ),
      ],
    );
    ;
  }
}
