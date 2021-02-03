import 'dart:convert';

import 'package:doit/apicontroller/BasicAuthConfig.dart';
import 'package:doit/model/Project.dart';
import 'package:http/http.dart' as http;

class ProjectApiController {
  String _ip;
  String _baseUrl;

  ProjectApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/doit/api/project";
  }

  Future<String> addProject(Project newProject) async {
    return (await http.post(Uri.encodeFull("$_baseUrl/new"),
            headers: await BasicAuthConfig()
                .getSudoHeader(), //TODO togliere .getSudoHeader() mettere .getuserHeader()
            body: json.encode({
              "id": newProject.getId(),
              "name": newProject.getName(),
              "projectProposer": newProject.getProjectProposer(),
              "tag": newProject.getTag(),
              "dateOfCreation": newProject.getDateOfCreation(),
              "dateOfStart": newProject.getDateOfStart(),
              "dateOfEnd": newProject.getDateOfEnd(),
              "shortDescription": newProject.getShortDescription(),
              "descriptionIsAFile": newProject.getDescriptionIsAFile(),
              "description": newProject.getDescription(),
              "evaluationMode": newProject.getEvaluationMode(),
              "startEvaluation": newProject.getStartEvaluation(),
              "endEvaluation": newProject.getEndEvaluation(),
              "candidacyMode": newProject.getCandidacyMode(),
              "startCandidacy": newProject.getStartCandidacy(),
              "endCandidacy": newProject.getEndCandidacy()
            })))
        .body;
  }

  Future<String> updateProject(Project newProject) async {
    return (await http.put(Uri.encodeFull("$_baseUrl/update"),
            headers: await BasicAuthConfig().getUserHeader(),
            body: json.encode({
              "name": newProject.getName(),
              "projectproposer": newProject.getProjectProposer(),
              "tag": newProject.getTag(),
              "dateOfCreation": newProject.getDateOfCreation(),
              "dateOfEnd": newProject.getDateOfEnd(),
              "shortDescription": newProject.getShortDescription(),
              "descriptionIsAFile": newProject.getDescriptionIsAFile(),
              "description": newProject.getDescription(),
              "evaluationMode": newProject.getEvaluationMode(),
              "startEvaluation": newProject.getStartEvaluation(),
              "endEvaluation": newProject.getEndEvaluation(),
              "candidacyMode": newProject.getCandidacyMode(),
              "startCandidacy": newProject.getStartCandidacy(),
              "endCandidacy": newProject.getEndCandidacy()
            })))
        .body;
  }

  Future<String> deleteProject(String id) async {
    return (await http.delete(Uri.encodeFull("$_baseUrl/delete/$id"),
            headers: await BasicAuthConfig().getUserHeader()))
        .body;
  }

  Future<String> getAllProject() async {
    return (await http.get(Uri.encodeFull("$_baseUrl/get"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getProjectById(String id) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getById/$id"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getProjectByName(String name) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getByName/$name"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getProjectByUser(String user) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getByUser/$user"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }
}
