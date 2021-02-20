import 'dart:convert';

import 'package:doit/apicontroller/BasicAuthConfig.dart';
import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/User.dart';
import 'package:http/http.dart' as http;

class Person {
  User user;
  AuthCredential authCredentials;
}

class AuthCredentialController {
  String _ip;
  String _baseUrl;

  AuthCredentialController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/doit/api/authCredential";
  }

  List<String> _rolesToString(List<UserRole> roles) {
    List<String> stringRoles = [];
    for (UserRole item in roles) {
      stringRoles
          .add(item.toString().substring(item.toString().indexOf('.') + 1));
    }
    return stringRoles;
  }

  Future<String> loginWithCredentials(AuthCredential authCredential) async {
    return (await http.post(Uri.encodeFull("$_baseUrl/login"),
            headers: BasicAuthConfig().getBaseHeader(),
            body: json.encode({
              "mail": authCredential.getMail(),
              "password": authCredential.getPassword(),
            })))
        .body;
  }

  Future<String> addCredential(AuthCredential authCredential) async {
    return (await http.post(Uri.encodeFull("$_baseUrl/addCredential"),
            headers: BasicAuthConfig().getBaseHeader(),
            body: json.encode({
              "mail": authCredential.getMail(),
              "password": authCredential.getPassword()
            })))
        .body;
  }

  Future<String> existByMail(String id) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/existsById/{id}"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> updateCredential(AuthCredential authCredential) async {
    return (await http.put(Uri.encodeFull("$_baseUrl/updateCredential"),
            headers: BasicAuthConfig().getUserHeader(),
            body: json.encode({
              "mail": authCredential.getMail(),
              "password": authCredential.getPassword(),
              "role": _rolesToString(authCredential.getRoles()),
            })))
        .body;
  }

  Future<String> addUser(User newUser) async {
    return (await http.post(Uri.encodeFull("$_baseUrl/addUser"),
            headers: BasicAuthConfig().getUserHeader(),
            body: json.encode({
              'mail': newUser.getMail(),
              'usernameToShow': newUser.getUsername(),
              'name': newUser.getName(),
              'surname': newUser.getSurname(),
              'roles': _rolesToString(newUser.getRoles()),
              'tags': newUser.getTags(),
              'proposedProjects': newUser.getProposedProjects(),
              'partecipateInProjects': newUser.getPartecipateInProjects(),
              'invites': newUser.getInvites(),
              'evaluations': newUser.getEvaluations(),
              'candidacies': newUser.getCandidacies(),
            })))
        .body;
  }

  Future<String> updateUser(User newUser) async {
    return (await http.put(Uri.encodeFull("$_baseUrl/updateUser"),
            headers: BasicAuthConfig().getUserHeader(),
            body: json.encode({
              'mail': newUser.getMail(),
              'usernameToShow': newUser.getUsername(),
              'name': newUser.getName(),
              'surname': newUser.getSurname(),
              'roles': _rolesToString(newUser.getRoles()),
              'tags': newUser.getTags(),
              'proposedProjects': newUser.getProposedProjects(),
              'partecipateInProjects': newUser.getPartecipateInProjects(),
              'invites': newUser.getInvites(),
              'evaluations': newUser.getEvaluations(),
              'candidacies': newUser.getCandidacies(),
            })))
        .body;
  }

  Future<String> deleteCredential(AuthCredential authCredential) async {
    return (await http.delete(Uri.encodeFull("$_baseUrl/delete"),
            headers: BasicAuthConfig().getUserHeader()))
        .body;
  }
}
