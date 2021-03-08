import 'dart:convert';

import 'package:doit/apicontroller/AuthCredentialController.dart';
import 'package:doit/apicontroller/BasicAuthConfig.dart';
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
    return new User.complete(user["mail"], user["usernameToShow"], user["name"],
        user["surname"], roles, tags, user["biography"]);
  }

  User _createUser(String body) {
    if (body == "") return null;
    return _newUser(json.decode(body));
  }

  void _extractToken(String body) {
    var jsonBody = json.decode(body);
    BasicAuthConfig().setAuthCredential(jsonBody["token"]);
  }

  @override
  Future<User> loginWithCredentials(AuthCredential authCredential) async {
    String body = await _controller.loginWithCredentials(authCredential);
    _extractToken(body);
    return _createUser(json.encode((json.decode(body))["user"]));
  }

  @override
  Future<User> addCredentials(AuthCredential authCredential) async {
     String body = await _controller.addCredential(authCredential);
    _extractToken(body);
    return _createUser(json.encode((json.decode(body))["user"]));
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
