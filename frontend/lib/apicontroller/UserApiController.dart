import 'package:doit/apicontroller/BasicAuthConfig.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserApiController {
  String _ip;
  String _baseUrl;

  UserApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/doit/api/user";
  }

  Future<String> getUserByMail(String mail) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getByMail/$mail"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getUsersByUsername(String username, String role) async {
    return (await http.get("$_baseUrl/getByUsername/$role/$username",
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getUsersByTags(List<String> tags) async {
    return (await http.put(Uri.encodeFull("$_baseUrl/getByTags"),
            headers: BasicAuthConfig().getBaseHeader(),
            body: json.encode(tags)))
        .body;
  }

  Future<String> getUsersByMails(List<String> mails) async {
    return (await http.put(Uri.encodeFull("$_baseUrl/getByMails"),
            headers: BasicAuthConfig().getBaseHeader(),
            body: json.encode(mails)))
        .body;
  }
}
