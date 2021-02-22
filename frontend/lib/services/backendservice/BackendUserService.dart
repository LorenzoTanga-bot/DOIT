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
    List<UserRole> roles = [];
    List<String> tags = [];
    List<String> proposedProjects = [];
    List<String> partecipateInProjects = [];
    List<String> evaluationsSend = [];
    List<String> evaluationsReceived = [];
    List<String> invites = [];
    List<String> candidacies = [];

    for (String role in user["roles"])
      roles.add(UserRole.values
          .firstWhere((e) => e.toString() == 'UserRole.' + role));
    for (String tag in user["tags"]) tags.add(tag);
    for (String project in user["proposedProjects"])
      proposedProjects.add(project);
    for (String project in user["partecipateInProjects"])
      partecipateInProjects.add(project);
    for (String evaluation in user["evaluationsSend"])
      evaluationsSend.add(evaluation);
    for (String evaluation in user["evaluationsReceived"])
      evaluationsReceived.add(evaluation);
    for (String invite in user["invites"]) invites.add(invite);
    for (String candidacy in user["candidacies"]) candidacies.add(candidacy);
    return new User.complete(
        user["mail"],
        user["usernameToShow"],
        user["name"],
        user["surname"],
        roles,
        tags,
        proposedProjects,
        partecipateInProjects,
        invites,
        candidacies,
        evaluationsSend,
        evaluationsReceived);
  }

  User _createUser(String controllerJson) {
    if (controllerJson == "") return null;
    return _newUser(json.decode(controllerJson));
  }

  @override
  Future<User> findByMail(String mail) async {
    return _createUser(await _controller.getUserByMail(mail));
  }

  @override
  Future<List<User>> findByMails(List<String> mails) async {
    return _createListUser(await _controller.getUsersByMails(mails));
  }

  @override
  Future<List<User>> findByTags(List<String> tags, String role) async {
    return _createListUser(await _controller.getUsersByTags(tags, role));
  }

  @override
  Future<List<User>> findByUsername(String username, String role) async {
    return _createListUser(
        await _controller.getUsersByUsername(username, role));
  }
}
