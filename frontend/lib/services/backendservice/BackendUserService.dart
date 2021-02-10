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
    return new User.firstAccess(user["mail"]);
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
    var proposedProjectsJson = user["proposedProjects"];
    var partecipateInProjectsJson = user["partecipateInProjects"];
    var evaluationsJson = user["evaluations"];
    var invitesJson = user["invites"];
    var candidaciesJson = user["candidacies"];
    List<UserRole> roles = [];
    List<String> tags = [];
    List<String> proposedProjects = [];
    List<String> partecipateInProjects = [];
    List<String> evaluations = [];
    List<String> invites = [];
    List<String> candidacies = [];
    for (String role in rolesJson)
      roles.add(UserRole.values
          .firstWhere((e) => e.toString() == 'UserRole.' + role));
    if (roles.first == UserRole.NOT_COMPLETED) return _newNotCompleted(user);
    for (String tag in tagsJson) tags.add(tag);
    for (String project in proposedProjectsJson) proposedProjects.add(project);
    for (String project in partecipateInProjectsJson)
      partecipateInProjects.add(project);
    for (String evaluation in evaluationsJson) evaluations.add(evaluation);
    for (String invite in invitesJson) invites.add(invite);
    for (String candidacy in candidaciesJson) candidacies.add(candidacy);
    return new User.complete(
        user["mail"],
        user["aperson"],
        user["usernameToShow"],
        user["name"],
        user["surname"],
        tags,
        roles,
        proposedProjects,
        partecipateInProjects,
        evaluations,
        invites,
        candidacies);
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
  Future<List<User>> findByTags(List<String> tags) async {
    return _createListUser(await _controller.getUsersByTags(tags));
  }

  @override
  Future<List<User>> findByUsername(String username, String role) async {
    return _createListUser(
        await _controller.getUsersByUsername(username, role));
  }
}
