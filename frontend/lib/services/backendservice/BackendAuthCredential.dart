import 'package:doit/model/User.dart';
import 'package:doit/model/AuthCredential.dart';
import 'package:doit/services/AuthCredentialService.dart';

class BackendAuthCredential implements AuthCredentialService {

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
  
  @override
  Future<User> addPerson(User newUser, AuthCredential authCredential) {
    // TODO: implement addPerson
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteCredential(AuthCredential authCredential) {
    // TODO: implement deleteCredential
    throw UnimplementedError();
  }

  @override
  Future<User> loginWithCredentials(AuthCredential authCredential) {
    // TODO: implement loginWithCredentials
    throw UnimplementedError();
  }

  @override
  Future<bool> updateCredentials(AuthCredential authCredential) {
    // TODO: implement updateCredentials
    throw UnimplementedError();
  }

}