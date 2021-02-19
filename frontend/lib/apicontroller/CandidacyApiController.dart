import 'dart:convert';

import 'package:doit/apicontroller/BasicAuthConfig.dart';
import 'package:doit/model/Candidacy.dart';
import 'package:http/http.dart' as http;

class CandidacyApiController {
  String _ip;
  String _baseUrl;

  CandidacyApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/doit/api/candidacy";
  }

  String _stateToString(StateCandidacy state) {
    return state.toString().substring(state.toString().indexOf('.') + 1);
  }

  Future<String> addCandidacy(Candidacy candidacy) async {
    return (await http.post(Uri.encodeFull("$_baseUrl/new"),
            headers: BasicAuthConfig().getUserHeader(),
            body: json.encode({
              'id': candidacy.getId(),
              'designer': candidacy.getDesigner(),
              'projectProposer': candidacy.getProjectProposer(),
              'project': candidacy.getProject(),
              'dateOfCandidacy': candidacy.getDateOfCandidacy(),
              'state': _stateToString(candidacy.getState()),
              'dateOfExpire': candidacy.getDateOfExpire(),
              'message': candidacy.getMessage()
            })))
        .body;
  }

  Future<String> updateCandidacy(Candidacy candidacy) async {
    return (await http.put(Uri.encodeFull("$_baseUrl/update"),
            headers: BasicAuthConfig().getUserHeader(),
            body: json.encode({
              'id': candidacy.getId(),
              'designer': candidacy.getDesigner(),
              'projectProposer': candidacy.getProjectProposer(),
              'project': candidacy.getProject(),
              'dateOfCandidacy': candidacy.getDateOfCandidacy(),
              'state': _stateToString(candidacy.getState()),
              'dateOfExpire': candidacy.getDateOfExpire(),
              'message': candidacy.getMessage()
            })))
        .body;
  }

  Future<String> getCandidacyById(String id) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getById/$id"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getCandidaciesByIds(List<String> ids) async {
    return (await http.put(Uri.encodeFull("$_baseUrl/getByIds"),
            headers: BasicAuthConfig().getBaseHeader(), body: json.encode(ids)))
        .body;
  }

  Future<String> getCandidaciesByDesigner(String user) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getByDesigner/$user"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getCandidaciesByProjectProposer(String user) async {
    return (await http.get(
            Uri.encodeFull("$_baseUrl/getByProjectProposer/$user"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getCandidaciesByProject(String id) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getByProject/$id"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }
}
