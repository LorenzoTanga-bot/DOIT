import 'dart:convert';

import 'package:doit/apicontroller/AuthCredentialController.dart';
import 'package:doit/model/User.dart';
import 'package:doit/model/AuthCredential.dart';
import 'package:doit/services/AuthCredentialService.dart';

class BackendAuthCredential implements AuthCredentialService {
  AuthCredentialController _controller;

  BackendAuthCredential(String ip) {
    _controller = new AuthCredentialController(ip);
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
  Future<User> loginWithCredentials(AuthCredential authCredential) async {
    return _createUser(await _controller.loginWithCredentials(authCredential));
  }

  @override
  Future<bool> addCredentials(AuthCredential authCredential) async {
    return (await _controller.addCredential(authCredential)) == "true"
        ? true
        : false;
  }

  @override
  Future<bool> updateCredentials(AuthCredential authCredential) async {
    return (await _controller.updateCredential(authCredential)) == "true"
        ? true
        : false;
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
  Future<bool> deleteCredential(AuthCredential authCredential) async {
    return (await _controller.deleteCredential(authCredential)) == "true"
        ? true
        : false;
  }

  @override
  Future<bool> existsByMail(String mail) async {
    return (await _controller.existByMail(mail)) == "true" ? true : false;
  }
}
