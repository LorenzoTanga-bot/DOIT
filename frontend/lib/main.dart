import 'package:doit/factories/servicesfactories/BackendServiceFactory.dart';
import 'package:doit/factories/servicesfactories/ServiceFactory.dart';
import 'package:doit/providers/ServiceProvider.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(Doit());
}

class Doit extends StatelessWidget {
  String _ip = "192.168.1.127";
  @override
  Widget build(BuildContext context) {
    ServiceFactory _factory = new BackendServiceFactory(_ip);
    ServiceProvider().setFactory(_factory);
    return MyApp();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}
