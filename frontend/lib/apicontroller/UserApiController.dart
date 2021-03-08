import 'package:doit/apicontroller/BasicAuthConfig.dart';
import 'package:doit/exception/BackendException.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

class UserApiController {
  String _ip;
  String _baseUrl;

  UserApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/doit/api/user";
  }
  String _getBodyResponse(Response response) {
    if (response.statusCode == 200)
      return response.body;
    else {
      throw (BackendException(json.decode(response.body)["message"]));
    }
  }

  Future<String> getUserByMail(String mail) async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull("$_baseUrl/public/getById/$mail"),
        headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> getUsersByUsername(String username, String role) async {
    return _getBodyResponse(await http.get(
        "$_baseUrl/public/getByUsername/$role/$username",
        headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> getUsersByTags(List<String> tags, String role) async {
    return _getBodyResponse(await http.put(
        Uri.encodeFull("$_baseUrl/public/getByTags/$role"),
        headers: BasicAuthConfig().getBaseHeader(),
        body: json.encode(tags)));
  }

  Future<String> getUsersByMails(List<String> ids) async {
    return _getBodyResponse(await http.put(
        Uri.encodeFull("$_baseUrl/public/getByIds"),
        headers: BasicAuthConfig().getBaseHeader(),
        body: json.encode(ids)));
  }
}
