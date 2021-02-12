import 'dart:convert';

import 'package:doit/apicontroller/BasicAuthConfig.dart';
import 'package:http/http.dart' as http;
import 'package:doit/model/Tag.dart';

class TagApiController {
  String _ip;
  String _baseUrl;

  TagApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/doit/api/tag";
  }

  Future<String> getAllTag() async {
    return (await http.get("$_baseUrl/get",
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> addTag(Tag newTag) async {
    return (await http.post("$_baseUrl/new",
            headers: BasicAuthConfig().getUserHeader(),
            body: json
                .encode({"id": newTag.getId(), "value": newTag.getValue()})))
        .body;
  }

  Future<String> getTagById(String id) async {
    return (await http.get("$_baseUrl/getById/$id",
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getTagByIds(List<String> ids) async {
    return (await http.put("$_baseUrl/getByIds",
            headers: BasicAuthConfig().getBaseHeader(), body: json.encode(ids)))
        .body;
  }
}
