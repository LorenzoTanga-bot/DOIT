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

  User _newUser(var user) {
    var rolesJson = user["roles"];
    var tagsJson = user["tags"];
    var projectsJson = user["projects"];
    List<UserRole> roles = [];
    List<String> tags = [];
    List<String> projects = [];
    for (String role in rolesJson)
      roles.add(UserRole.values.firstWhere((e) => e.toString() == 'UserRole.'+role)); //TODO da testare
    for (String skill in tagsJson) tags.add(skill);
    for (String project in projectsJson) projects.add(project);
    return new User.complete(user["id"], user["isAPerson"],user["username"], user["name"],
        user["surname"], user["mail"], tags, roles, projects);
  }

  User _createUser(String controllerJson) {
    if (controllerJson == "") return null;
    var user = json.decode(controllerJson);
    switch (user["role"]) {
      case "NOT_COMPLETED":
        return _newNotCompleted(user);
      case "PROJECT_PROPOSER":
        return _newUser(user);
    }
    return null;
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
  Future<List<User>> findBySkills(List<String> skills) async {
    //return _createUser(await _controller.findBySkills(skills));
    //TODO da fare
  }

  @override
  Future<User> findByUsername(String username) async {
    return _createUser(await _controller.getUsersByUsername(username));
  }
}
