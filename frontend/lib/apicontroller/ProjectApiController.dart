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
            headers: BasicAuthConfig()
                .getUserHeader(), 
            body: json.encode({
              "id": newProject.getId(),
              "name": newProject.getName(),
              "projectProposer": newProject.getProjectProposer(),
              "tag": newProject.getTag(),
              "dateOfCreation": newProject.getDateOfCreation(),
              "dateOfStart": newProject.getDateOfStart(),
              "dateOfEnd": newProject.getDateOfEnd(),
              "shortDescription": newProject.getShortDescription(),
              "description": newProject.getDescription(),
              "evaluationMode": newProject.getEvaluationMode(),
              "startCandidacy": newProject.getStartCandidacy(),
              "endCandidacy": newProject.getEndCandidacy()
            })))
        .body;
  }

  Future<String> updateProject(Project modifiedProject) async {
    return (await http.put(Uri.encodeFull("$_baseUrl/update"),
            headers: BasicAuthConfig().getUserHeader(),
            body: json.encode({
              "id": modifiedProject.getId(),
              "name": modifiedProject.getName(),
              "projectProposer": modifiedProject.getProjectProposer(),
              "tag": modifiedProject.getTag(),
              "dateOfCreation": modifiedProject.getDateOfCreation(),
              "dateOfStart": modifiedProject.getDateOfStart(),
              "dateOfEnd": modifiedProject.getDateOfEnd(),
              "shortDescription": modifiedProject.getShortDescription(),
              "description": modifiedProject.getDescription(),
              "evaluationMode": modifiedProject.getEvaluationMode(),
              "startCandidacy": modifiedProject.getStartCandidacy(),
              "endCandidacy": modifiedProject.getEndCandidacy()
            })))
        .body;
  }

  Future<String> deleteProject(String id) async {
    return (await http.delete(Uri.encodeFull("$_baseUrl/delete/$id"),
            headers: BasicAuthConfig().getUserHeader()))
        .body;
  }

  Future<String> getProjectsPage(int index) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getPage/$index/15"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getAllProjects() async {
    return (await http.get(Uri.encodeFull("$_baseUrl/get"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getProjectById(String id) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getById/$id"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getProjectsByIds(List<String> ids) async {
    return (await http.put(Uri.encodeFull("$_baseUrl/getByIds"),
            headers: BasicAuthConfig().getBaseHeader(),
            body: json.encode({ids})))
        .body;
  }

  Future<String> getProjectsByName(String name) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getByName/$name"),
            headers: BasicAuthConfig().getBaseHeader()))
        .body;
  }

  Future<String> getProjectsByTags(List<String> tags) async {
    return (await http.put(Uri.encodeFull("$_baseUrl/getByTags"),
            headers: BasicAuthConfig().getBaseHeader(),
            body: json.encode({tags})))
        .body;
  }
}
