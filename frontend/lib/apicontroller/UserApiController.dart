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

  Future<String> getUserById(String id) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getById/$id"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getUserByMail(String mail) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getByMail/$mail"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getUsersByUsername(String username) async {
    return (await http.get("$_baseUrl/getByUsername/$username",
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<List<String>> getUsersByTags(List<String> tags) {

  }
}
