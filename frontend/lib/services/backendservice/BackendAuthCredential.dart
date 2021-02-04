import 'package:doit/apicontroller/AuthCredentialController.dart';
import 'package:doit/model/User.dart';
import 'package:doit/model/AuthCredential.dart';
import 'package:doit/services/AuthCredentialService.dart';

class BackendAuthCredential implements AuthCredentialService {
  AuthCredentialController _controller;

  BackendAuthCredential(String ip) {
    _controller = new AuthCredentialController(ip);
  }
  User _createUser(var user) {
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
    for (String tag in tagsJson) tags.add(tag);
    for (String project in projectsFirstJson) projectsFirstRole.add(project);
    for (String project in projectsSecondJson) projectsSecondRole.add(project);
    return new User.complete(
        user["id"],
        user["isAPerson"],
        user["username"],
        user["name"],
        user["surname"],
        user["mail"],
        tags,
        roles,
        projectsFirstRole,
        projectsSecondRole);
  }

  @override
  Future<User> addUser(User newUser, AuthCredential authCredential) async {
    return _createUser(await _controller.addUser(newUser, authCredential));
  }

  @override
  Future<bool> deleteCredential(AuthCredential authCredential) async {
    return (await _controller.deleteCredential(authCredential)) == "true"
        ? true
        : false;
  }

  @override
  Future<User> loginWithCredentials(AuthCredential authCredential) async {
    return _createUser(await _controller.loginWithCredentials(authCredential));
  }

  @override
  Future<bool> updateCredentials(AuthCredential authCredential) async {
    return (await _controller.updateCredential(authCredential)) == "true"
        ? true
        : false;
  }

  @override
  Future<User> updateUser(User newUser) async {
    return _createUser(await _controller.updateUser(newUser));
  }
}