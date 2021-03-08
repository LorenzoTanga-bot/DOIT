import 'package:flutter/material.dart';

class ErrorPopup extends StatelessWidget {
  final String message;

  const ErrorPopup({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Ops, something went wrong!",style: TextStyle(fontSize: 23,color: Colors.blue)),
      content: Text(message),
    );
  }
}
