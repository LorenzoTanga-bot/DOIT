import 'dart:convert';

import 'package:doit/apicontroller/BasicAuthConfig.dart';
import 'package:doit/model/Evaluation.dart';
import 'package:http/http.dart' as http;

class EvaluationApiController {
  String _ip;
  String _baseUrl;

  EvaluationApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/doit/api/evaluation";
  }

  String _modeToString(EvaluationMode mode) {
    return mode.toString().substring(mode.toString().indexOf('.') + 1);
  }

  Future<String> addEvaluation(Evaluation evaluation) async {
    return (await http.post(Uri.encodeFull("$_baseUrl/new"),
            headers: BasicAuthConfig().getUserHeader(),
            body: json.encode({
              'id': evaluation.getId(),
              'project': evaluation.getProject(),
              'message': evaluation.getMessage(),
              'sender': evaluation.getSender(),
              'evaluationMode': _modeToString(evaluation.getEvaluationMode()),
            })))
        .body;
  }

  Future<String> updateEvaluation(Evaluation evaluation) async {
    return (await http.put(Uri.encodeFull("$_baseUrl/update"),
            headers: BasicAuthConfig().getUserHeader(),
            body: json.encode({
              'id': evaluation.getId(),
              'project': evaluation.getProject(),
              'message': evaluation.getMessage(),
              'sender': evaluation.getSender(),
              'evaluationMode': _modeToString(evaluation.getEvaluationMode()),
            })))
        .body;
  }

  Future<String> getEvaluationById(String id) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getById/$id"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getEvaluationsByIds(List<String> ids) async {
    return (await http.put(Uri.encodeFull("$_baseUrl/getByIds"),
            headers: BasicAuthConfig().getBaseHeader(), body: json.encode(ids)))
        .body;
  }

  Future<String> getEvaluationsBySender(String user) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getBySender/$user"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getEvaluationsByProject(String id) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getByProject/$id"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }
}
