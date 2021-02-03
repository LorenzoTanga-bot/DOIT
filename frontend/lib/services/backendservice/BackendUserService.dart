import 'dart:convert';

import 'package:doit/apicontroller/UserApiController.dart';
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

  User _newUserWithRole(var user, String role) {
    var skillsJson = user["skills"];
    var projectsJson = user["projects"];
    List<String> skills = new List<String>();
    List<String> projects = new List<String>();
    for (String skill in skillsJson) skills.add(skill);
    for (String project in projectsJson) projects.add(project);
    switch (role) {
      case "DESIGNER":
        return new User.designer(user["id"], user["username"], user["name"],
            user["surname"], user["mail"], skills, projects);
      case "PROJECT_PROPOSER":
        return new User.projectProposer(user["id"], user["username"],
            user["name"], user["surname"], user["mail"], skills, projects);
      case "EXPERT":
        return new User.expert(user["id"], user["username"], user["name"],
            user["surname"], user["mail"], skills, projects);
    }
  }

  User _createUser(String controllerJson) {
    if (controllerJson == "") return null;
    var user = json.decode(controllerJson);
    switch (user["role"]) {
      case "NOT_COMPLETED":
        return _newNotCompleted(user);
      case "PROJECT_PROPOSER":
        return _newUserWithRole(user, "PROJECT_PROPOSER");
      case "DESIGNER":
        return _newUserWithRole(user, "DESIGNER");
      case "EXPERT":
        return _newUserWithRole(user, "EXPERT");
    }
  }

  List<User> _createListUser(String controllerJson) {
    if (controllerJson == "") return null;
    var listUser = json.decode(controllerJson);
    List<User> users = new List<User>();
    for (var user in listUser) {
      users.add(_createUser(user));
    }
    return users;
  }

  @override
  Future<User> addUser(User newUser) async {
    return _createUser(await _controller.addUser(newUser));
  }

  @override
  Future<User> updateUser(User newUser) async {
    return _createUser(await _controller.updateUser(newUser));
  }

  @override
  Future<User> findById(String id) async {
    return _createUser(await _controller.getById(id));
  }

  @override
  Future<User> findByMail(String mail) async {
    return _createUser(await _controller.getByMail(mail));
  }

  @override
  Future<List<User>> findByTags(List<String> skills, UserRole role) async {
    return _createListUser(
        await _controller.getByTags(skills, role.toString()));
  }

  @override
  Future<List<User>> findByUsername(String username, UserRole role) async {
    return _createListUser(
        await _controller.getByUsername(username, role.toString()));
  }

  @override
  Future<bool> existByMail(String mail) async {
    return (await _controller.existByMail(mail)) == 'true';
  }
}
