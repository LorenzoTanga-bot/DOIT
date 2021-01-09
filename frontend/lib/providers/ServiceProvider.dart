import 'package:doit/factories/servicesfactories/ServiceFactory.dart';
import 'package:doit/services/ProjectService.dart';
import 'package:doit/services/TagService.dart';
import 'package:doit/services/UserService.dart';
import 'package:flutter/material.dart';

class ServiceProvider extends ChangeNotifier {
  ServiceFactory _factory;

  static final ServiceProvider _singleton = ServiceProvider._internal();

  factory ServiceProvider() {
    return _singleton;
  }

  ServiceProvider._internal();

  void setFactory(ServiceFactory newFactory) {
    this._factory = newFactory;
  }

  ProjectService getProjectService() {
    return _factory.getProjectService();
  }

  TagService getTagService() {
    return _factory.getTagService();
  }

  UserService getUserService() {
    return _factory.getUserService();
  }
}
