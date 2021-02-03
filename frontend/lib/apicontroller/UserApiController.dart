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
}
