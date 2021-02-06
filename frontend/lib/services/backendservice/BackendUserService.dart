import 'dart:convert';

import 'package:doit/apicontroller/UserApiController.dart';
import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/User.dart';
import 'package:doit/services/UserService.dart';

class BackendUserService implements UserService {
  UserApiController _controller;

  BackendUserService(String ip) {
    _controller = new UserApiController(ip);
  }

  User _newNotCompleted(var user) {
    return new User.firstAccess(user["id"], user["mail"]);
  }

  List<User> _createListUser(String controllerJson) {
    if (controllerJson == "") return null;
    var listUser = json.decode(controllerJson);
    List<User> users = new List<User>();
    for (var tag in listUser) {
      users.add(_newUser(tag));
    }
    return users;
  }

  User _newUser(var user) {
    var rolesJson = user["roles"];
    var tagsJson = user["tags"];
    var projectsFirstJson = user["projectsFirstRole"];
    var projectsSecondJson = user["projectsSecondRole"];
    List<UserRole> roles = [];
    List<String> tags = [];
    List<String> projectsFirstRole = [];
    List<String> projectsSecondRole = [];
    for (String role in rolesJson)
      roles.add(UserRole.values.firstWhere(
          (e) => e.toString() == 'UserRole.' + role)); //TODO da testare
    if (roles.first == UserRole.NOT_COMPLETED)
      return _newNotCompleted(user);
    else {
      for (String tag in tagsJson) tags.add(tag);
      for (String project in projectsFirstJson) projectsFirstRole.add(project);
      for (String project in projectsSecondJson)
        projectsSecondRole.add(project);
      return new User.complete(
          user["id"],
          user["aperson"],
          user["usernameToShow"],
          user["name"],
          user["surname"],
          user["mail"],
          tags,
          roles,
          projectsFirstRole,
          projectsSecondRole);
    }
  }

  User _createUser(String controllerJson) {
    if (controllerJson == "") return null;
    var user = json.decode(controllerJson);
    return _newUser(user);
  }

  @override
  Future<User> findById(String id) async {
    return _createUser(await _controller.getUserById(id));
  }

  @override
  Future<User> findByMail(String mail) async {
    return _createUser(await _controller.getUserByMail(mail));
  }

  @override
  Future<List<User>> findBySkills(List<String> tags) async {
    return _createListUser(await _controller.getUsersByTags(tags));
  }

  @override
  Future<List<User>> findByUsername(String username, String role) async {
    return _createListUser(
        await _controller.getUsersByUsername(username, role));
  }
}
