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

  User _newProjectProposer(var user) {
    var skillsJson = user["skills"];
    var projectsJson = user["projects"];
    List<String> skills = new List<String>();
    List<String> projects = new List<String>();
    for (String skill in skillsJson) skills.add(skill);
    for (String project in projectsJson) projects.add(project);
    return new User.projectProposer(user["id"], user["username"], user["name"],
        user["surname"], user["mail"], skills, projects);
  }

  User _createUser(String controllerJson) {
    if (controllerJson == "") return null;
    var user = json.decode(controllerJson);
    switch (user["role"]) {
      case "NOT_COMPLETED":
        return _newNotCompleted(user);
      case "PROJECT_PROPOSER":
        return _newProjectProposer(user);
    }
  }

  @override
  Future<User> addUser(User newUser) async {
    return _createUser(await _controller.addUser(newUser));
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
