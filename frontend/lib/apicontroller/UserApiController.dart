import 'package:doit/apicontroller/BasicAuthConfig.dart';
import 'package:doit/model/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserApiController {
  String _ip;
  String _baseUrl;

  UserApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/doit/api/user";
  }

  Future<String> addUser(User newUser) async {
    return (await http.post(Uri.encodeFull("$_baseUrl/new"),
            headers: await BasicAuthConfig().getSudoHeader(),
            body: json.encode({
              "id": newUser.getId(),
              "username": newUser.getUsername(),
              "name": newUser.getName(),
              "surname": newUser.getUsername(),
              "mail": newUser.getMail(),
              "role": newUser
                  .getRole()
                  .toString()
                  .substring(newUser.getRole().toString().indexOf('.') + 1),
              "skills": newUser.getSkills(),
              "projects": newUser.getProjects(),
            })))
        .body;
  }

  Future<String> updateUser(User newUser) async {
    return (await http.put(Uri.encodeFull("$_baseUrl/update"),
            headers: await BasicAuthConfig().getUserHeader(),
            body: json.encode({
              "id": newUser.getId(),
              "username": newUser.getUsername(),
              "name": newUser.getName(),
              "surname": newUser.getUsername(),
              "mail": newUser.getMail(),
              "role": newUser
                  .getRole()
                  .toString()
                  .substring(newUser.getRole().toString().indexOf('.') + 1),
              "skills": newUser.getSkills(),
              "projects": newUser.getProjects()
            })))
        .body;
  }

  Future<String> findById(String id) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/id/$id"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> findByMail(String mail) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/mail/$mail"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> findByUsername(String username) async {
    return (await http.get("$_baseUrl/username/$username",
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<List<String>> findByTags(List<String> skills) {
    //TODO da fare
  }

  Future<String> existByMail(String mail) async {
    return (await http.get("$_baseUrl/exists/$mail",
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }
}
