import 'dart:convert';

import 'package:doit/apicontroller/BasicAuthConfig.dart';
import 'package:doit/exception/BackendException.dart';
import 'package:doit/model/Candidacy.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class CandidacyApiController {
  String _ip;
  String _baseUrl;

  CandidacyApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/doit/api/candidacy";
  }

  String _getBodyResponse(Response response) {
    if (response.statusCode == 200)
      return response.body;
    else {
      throw (BackendException(json.decode(response.body)["message"]));
    }
  }

  String _stateToString(StateCandidacy state) {
    return state.toString().substring(state.toString().indexOf('.') + 1);
  }

  Future<String> addCandidacy(Candidacy candidacy) async {
    return _getBodyResponse(await http.post(Uri.encodeFull("$_baseUrl/new"),
        headers: BasicAuthConfig().getUserHeader(),
        body: json.encode({
          'id': candidacy.getId(),
          'project': candidacy.getProject(),
          'designer': candidacy.getDesigner(),
          'projectProposer': candidacy.getProjectProposer(),
          'dateOfCandidacy': candidacy.getDateOfCandidacy(),
          'state': _stateToString(candidacy.getState()),
          'dateOfExpire': candidacy.getDateOfExpire(),
          'message': candidacy.getMessage()
        })));
  }

  Future<String> updateCandidacy(Candidacy candidacy) async {
    return _getBodyResponse(await http.put(Uri.encodeFull("$_baseUrl/update"),
        headers: BasicAuthConfig().getUserHeader(),
        body: json.encode({
          'id': candidacy.getId(),
          'project': candidacy.getProject(),
          'designer': candidacy.getDesigner(),
          'projectProposer': candidacy.getProjectProposer(),
          'dateOfCandidacy': candidacy.getDateOfCandidacy(),
          'state': _stateToString(candidacy.getState()),
          'dateOfExpire': candidacy.getDateOfExpire(),
          'message': candidacy.getMessage()
        })));
  }

  Future<String> getCandidacyById(String id) async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull("$_baseUrl/public/getById/$id"),
        headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> getCandidaciesByIds(List<String> ids) async {
    return _getBodyResponse(await http.put(Uri.encodeFull("$_baseUrl/public/getByIds"),
        headers: BasicAuthConfig().getBaseHeader(), body: json.encode(ids)));
  }

  Future<String> getCandidaciesByDesigner(String user) async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull("$_baseUrl/public/getByDesigner/$user"),
        headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> getCandidaciesByProjectProposer(String user) async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull("$_baseUrl/public/getByProjectProposer/$user"),
        headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> getCandidaciesByProject(String id) async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull("$_baseUrl/public/getByProject/$id"),
        headers: BasicAuthConfig().getBaseHeader()));
  }
}
