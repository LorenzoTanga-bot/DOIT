import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String message;
  LoadingScreen({@required this.message});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/images/logo.png', scale: 3)),
      backgroundColor: Colors.white,
    );
  }
}
