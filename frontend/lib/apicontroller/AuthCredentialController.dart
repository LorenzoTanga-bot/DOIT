import 'dart:convert';

import 'package:doit/apicontroller/BasicAuthConfig.dart';
import 'package:doit/exception/BackendException.dart';
import 'package:doit/model/AuthCredential.dart';
import 'package:doit/model/User.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

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

  String _getBodyResponse(Response response) {
    if (response.statusCode == 200)
      return response.body;
    else {
      throw (BackendException( json.decode(response.body)["message"]));
    }
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
    return _getBodyResponse(await http.post(Uri.encodeFull("$_baseUrl/login"),
        headers: BasicAuthConfig().getBaseHeader(),
        body: json.encode({
          "mail": authCredential.getMail(),
          "password": authCredential.getPassword(),
        })));
  }

  Future<String> addCredential(AuthCredential authCredential) async {
    return _getBodyResponse(await http.post(
        Uri.encodeFull("$_baseUrl/addCredential"),
        headers: BasicAuthConfig().getBaseHeader(),
        body: json.encode({
          "mail": authCredential.getMail(),
          "password": authCredential.getPassword()
        })));
  }

  Future<String> existByMail(String id) async {
    return _getBodyResponse(await http.get(Uri.encodeFull("$_baseUrl/existsById/{id}"),
            headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> updateCredential(AuthCredential authCredential) async {
    return _getBodyResponse(
        await http.put(Uri.encodeFull("$_baseUrl/updateCredential"),
            headers: BasicAuthConfig().getUserHeader(),
            body: json.encode({
              "mail": authCredential.getMail(),
              "password": authCredential.getPassword(),
              "role": _rolesToString(authCredential.getRoles()),
            })));
  }

  Future<String> addUser(User newUser) async {
    return _getBodyResponse(await http.post(Uri.encodeFull("$_baseUrl/addUser"),
            headers: BasicAuthConfig().getUserHeader(),
            body: json.encode({
              'mail': newUser.getMail(),
              'usernameToShow': newUser.getUsername(),
              'name': newUser.getName(),
              'surname': newUser.getSurname(),
              'roles': _rolesToString(newUser.getRoles()),
              'tags': newUser.getTags(),
              
            })));
  }

  Future<String> updateUser(User newUser) async {
    return _getBodyResponse(await http.put(Uri.encodeFull("$_baseUrl/updateUser"),
            headers: BasicAuthConfig().getUserHeader(),
            body: json.encode({
              'mail': newUser.getMail(),
              'usernameToShow': newUser.getUsername(),
              'name': newUser.getName(),
              'surname': newUser.getSurname(),
              'roles': _rolesToString(newUser.getRoles()),
              'tags': newUser.getTags(),
             
            })));
  }

  Future<String> deleteCredential(AuthCredential authCredential) async {
    return _getBodyResponse(await http.delete(Uri.encodeFull("$_baseUrl/delete"),
            headers: BasicAuthConfig().getUserHeader()));
  }
}
