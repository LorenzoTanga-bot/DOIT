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
              "id": authCredential.getId()
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

  Future<String> updateCredential(AuthCredential authCredential) async {
    return (await http.post(Uri.encodeFull("$_baseUrl/updateCredential"),
            headers: BasicAuthConfig().getUserHeader(),
            body: json.encode({
              "id": authCredential.getId(),
              "mail": authCredential.getMail(),
              "password": authCredential.getPassword(),
              "role": _rolesToString(authCredential.getRoles()),
            })))
        .body;
  }

  Future<String> addUser(User newUser) async {
    return (await http.post(Uri.encodeFull("$_baseUrl/addUser"),
            headers: BasicAuthConfig().getBaseHeader(),
            body: json.encode({
              {
                "id": newUser.getId(),
                "isAPerson": newUser.getIsAperson(),
                "username": newUser.getUsername(),
                "name": newUser.getName(),
                "surname": newUser.getUsername(),
                "mail": newUser.getMail(),
                "roles": _rolesToString(newUser.getRoles()),
                "tags": newUser.getTags(),
                "projectsFirstRole": newUser.getProjectsFirstRole(),
                "projectsSecondRole": newUser.getProjectsSecondRole()
              }
            })))
        .body;
  }

  Future<String> updateUser(User newUser) async {
    return (await http.post(Uri.encodeFull("$_baseUrl/updateUser"),
            headers: BasicAuthConfig().getBaseHeader(),
            body: json.encode({
              "id": newUser.getId(),
              "isAPerson": newUser.getIsAperson(),
              "username": newUser.getUsername(),
              "name": newUser.getName(),
              "surname": newUser.getUsername(),
              "mail": newUser.getMail(),
              "roles": _rolesToString(
                  BasicAuthConfig().getAuthCredential().getRoles()),
              "tags": newUser.getTags(),
              "projectsFirstRole": newUser.getProjectsFirstRole(),
              "projectsSecondRole": newUser.getProjectsSecondRole()
            })))
        .body;
  }

  Future<String> deleteCredential(AuthCredential authCredential) async {
    return (await http.post(Uri.encodeFull("$_baseUrl/delete"),
            headers: BasicAuthConfig().getUserHeader()))
        .body;
  }
}
