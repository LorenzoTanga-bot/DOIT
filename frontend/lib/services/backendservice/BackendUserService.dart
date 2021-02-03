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
    var skillsJson = user["skills"];
    var projectsJson = user["projects"];
    List<UserRole> roles = [];
    List<String> skills = [];
    List<String> projects = [];
    for (String role in rolesJson)
      roles.add(UserRole.values.firstWhere((e) => e.toString() == 'UserRole.'+role)); //TODO da testare
    for (String skill in skillsJson) skills.add(skill);
    for (String project in projectsJson) projects.add(project);
    return new User.complete(user["id"], user["username"], user["name"],
        user["surname"], user["mail"], skills, roles, projects);
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
  Future<User> addUser(User newUser) async {
    return _createUser(await _controller.addUser(newUser));
  }

  @override
  Future<User> findById(String id) async {
    return _createUser(await _controller.findById(id));
  }

  @override
  Future<User> findByMail(String mail) async {
    return _createUser(await _controller.findByMail(mail));
  }

  @override
  Future<List<User>> findBySkills(List<String> skills) async {
    //return _createUser(await _controller.findBySkills(skills));
    //TODO da fare
  }

  @override
  Future<User> findByUsername(String username) async {
    return _createUser(await _controller.findByUsername(username));
  }

  @override
  Future<User> updateUser(User newUser) async {
    return _createUser(await _controller.updateUser(newUser));
  }

  @override
  Future<bool> existByMail(String mail) async {
    return (await _controller.existByMail(mail)) == 'true';
  }
}
