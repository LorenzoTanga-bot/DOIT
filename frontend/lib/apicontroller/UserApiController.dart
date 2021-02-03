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
            headers: await BasicAuthConfig().getHeader(),
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
            headers: await BasicAuthConfig().getHeader(),
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

Future<String> getById(String id)async {
  return (await http.get(Uri.encodeFull("$_baseUrl/getById/$id"),
            headers: await BasicAuthConfig().getHeader()))
        .body;
}

 Future<String> getByIds(List<String> ids) async {
    return (await http.put(Uri.encodeFull("$_baseUrl/getByIds"),
            headers: await BasicAuthConfig().getHeader(),
            body: json.encode({ids})))
        .body;
  }
  Future<String> getByMail(String mail) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getByMail/$mail"),
            headers: await BasicAuthConfig().getHeader()))
        .body;
  }

  Future<String> getByUsername(String username,String role) async {
    return (await http.get("$_baseUrl/getByUsername/$role/$username",
            headers: await BasicAuthConfig().getHeader()))
        .body;
  }

  Future<String> getByTags(List<String> tags,String role) async{
     return (await http.put(Uri.encodeFull("$_baseUrl/getByTags/$role"),
            headers: await BasicAuthConfig().getHeader(),
            body: json.encode({tags})))
        .body;
  }
  

  Future<String> existByMail(String mail) async {
    return (await http.get("$_baseUrl/exists/$mail",
            headers: await BasicAuthConfig().getHeader()))
        .body;
  }
}
