import 'package:doit/providers/ViewProvider.dart';
import 'package:doit/view/Signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitialSelection extends StatefulWidget {
   final String mail;

  const InitialSelection({Key key, @required this.mail}) : super(key: key);
  @override
  _InitialSelectionState createState() => _InitialSelectionState();
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
                  mail: widget.mail,
              isAPerson: false,
            )),
            child: Text("Entity"),
          ),
          RaisedButton(
            onPressed: () => Provider.of<ViewProvider>(context, listen: false)
                .pushWidget(Signin(
                  mail: widget.mail,
              isAPerson: true,
            )),
            child: Text("Person"),
          )
        ],
      ),
    );
  }
}
