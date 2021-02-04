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

  Future<String> loginWithCredentials(AuthCredential authCredential) async {
    return (await http.post(Uri.encodeFull("$_baseUrl/login"),
            headers: BasicAuthConfig().getBaseHeader(),
            body: json.encode({
              "mail": authCredential.getMail(),
              "password": authCredential.getPassword(),
            })))
        .body;
  }

  Future<String> updateCredential(AuthCredential authCredential) async {
    return (await http.post(Uri.encodeFull("$_baseUrl/update"),
            headers: BasicAuthConfig().getUserHeader(),
            body: json.encode({
              "id": authCredential.getId(),
              "mail": authCredential.getMail(),
              "password": authCredential.getPassword(),
              "role": authCredential.getRolesToString(),
            })))
        .body;
  }

  Future<String> addUser(User newUser, AuthCredential authCredential) async {
    return (await http.post(Uri.encodeFull("$_baseUrl/addUser"),
            headers: BasicAuthConfig().getBaseHeader(),
            body: json.encode({
              "user": {
                "id": newUser.getId(),
                "isAPerson": newUser.getIsAperson(),
                "username": newUser.getUsername(),
                "name": newUser.getName(),
                "surname": newUser.getUsername(),
                "mail": newUser.getMail(),
                "role": authCredential.getRolesToString(),
                "tags": newUser.getTags(),
                "projects": newUser.getProjects(),
              },
              "authCredentials": {
                "id": authCredential.getId(),
                "mail": authCredential.getMail(),
                "password": authCredential.getPassword(),
                "role": authCredential.getRolesToString(),
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
                "role": BasicAuthConfig().getAuthCredential().getRolesToString(),
                "tags": newUser.getTags(),
                "projects": newUser.getProjects(),
              })))
        .body;
  }
  

  Future<String> deleteCredential(AuthCredential authCredential) async {
    return (await http.post(Uri.encodeFull("$_baseUrl/delete"),
            headers: BasicAuthConfig().getUserHeader()))
        .body;
  }
}
