import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/Signin.dart';
import 'package:doit/view/projectproposer/CreateModifyProject.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitialSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class _InitialSelectionState extends State<InitialSelection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("You are : "),
          RaisedButton(
            onPressed: () => Provider.of<ViewProvider>(context, listen: false)
                .pushWidget(Signin(
              isAPerson: false,
            )),
            child: Text("Entity"),
          ),
          RaisedButton(
            onPressed: () => Provider.of<ViewProvider>(context, listen: false)
                .pushWidget(Signin(
              isAPerson: true,
            )),
            child: Text("Person"),
          )
        ],
      ),
    );
  }
}
