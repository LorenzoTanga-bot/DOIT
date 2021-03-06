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
    List<UserRole> roles = [];
    List<String> tags = [];
    for (String role in user["roles"])
      roles.add(UserRole.values
          .firstWhere((e) => e.toString() == 'UserRole.' + role));
    for (String tag in user["tags"]) tags.add(tag);
    return new User.complete(
      user["mail"],
      user["usernameToShow"],
      user["name"],
      user["surname"],
      roles,
      tags,
    );
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
  Future<User> addCredentials(AuthCredential authCredential) async {
    return _createUser(await _controller.addCredential(authCredential));
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
