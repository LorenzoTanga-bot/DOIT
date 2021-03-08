import 'dart:convert';

import 'package:doit/apicontroller/BasicAuthConfig.dart';
import 'package:doit/exception/BackendException.dart';
import 'package:doit/model/Evaluation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class EvaluationApiController {
  String _ip;
  String _baseUrl;

  EvaluationApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/doit/api/evaluation";
  }

  String _getBodyResponse(Response response) {
    if (response.statusCode == 200)
      return response.body;
    else {
      throw (BackendException(json.decode(response.body)["message"]));
    }
  }

  String _modeToString(EvaluationMode mode) {
    return mode.toString().substring(mode.toString().indexOf('.') + 1);
  }

  Future<String> addEvaluation(Evaluation evaluation) async {
    return _getBodyResponse(await http.post(Uri.encodeFull("$_baseUrl/new"),
        headers: BasicAuthConfig().getUserHeader(),
        body: json.encode({
          'id': evaluation.getId(),
          'project': evaluation.getProject(),
          'message': evaluation.getMessage(),
          'sender': evaluation.getSender(),
          'evaluationMode': _modeToString(evaluation.getEvaluationMode()),
        })));
  }

  Future<String> updateEvaluation(Evaluation evaluation) async {
    return _getBodyResponse(await http.put(Uri.encodeFull("$_baseUrl/update"),
        headers: BasicAuthConfig().getUserHeader(),
        body: json.encode({
          'id': evaluation.getId(),
          'project': evaluation.getProject(),
          'message': evaluation.getMessage(),
          'sender': evaluation.getSender(),
          'evaluationMode': _modeToString(evaluation.getEvaluationMode()),
        })));
  }

  Future<String> getEvaluationById(String id) async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull("$_baseUrl/public/getById/$id"),
        headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> getEvaluationsByIds(List<String> ids) async {
    return _getBodyResponse(await http.put(Uri.encodeFull("$_baseUrl/public/getByIds"),
        headers: BasicAuthConfig().getBaseHeader(), body: json.encode(ids)));
  }

  Future<String> getEvaluationsBySender(String user) async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull("$_baseUrl/public/getBySender/$user"),
        headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> getEvaluationsByProject(String id) async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull("$_baseUrl/public/getByProject/$id"),
        headers: BasicAuthConfig().getBaseHeader()));
  }
}
