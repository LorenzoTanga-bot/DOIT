import 'dart:convert';

import 'package:doit/apicontroller/BasicAuthConfig.dart';
import 'package:doit/exception/BackendException.dart';
import 'package:http/http.dart' as http;
import 'package:doit/model/Tag.dart';
import 'package:http/http.dart';

class TagApiController {
  String _ip;
  String _baseUrl;

  TagApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/doit/api/tag";
  }

  String _getBodyResponse(Response response) {
    if (response.statusCode == 200)
      return response.body;
    else {
      throw (BackendException(json.decode(response.body)["message"]));
    }
  }

  Future<String> getAllTag() async {
    return _getBodyResponse(await http.get("$_baseUrl/get",
        headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> addTag(Tag newTag) async {
    return _getBodyResponse(await http.post("$_baseUrl/new",
        headers: BasicAuthConfig().getUserHeader(),
        body: json.encode({"id": newTag.getId(), "value": newTag.getValue()})));
  }

  Future<String> getTagById(String id) async {
    return _getBodyResponse(await http.get("$_baseUrl/getById/$id",
        headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> getTagByIds(List<String> ids) async {
    return _getBodyResponse(await http.put("$_baseUrl/getByIds",
        headers: BasicAuthConfig().getBaseHeader(), body: json.encode(ids)));
  }
}
