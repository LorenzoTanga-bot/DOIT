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
            headers: await BasicAuthConfig().getHeader(),
            body: json.encode({
              "id": newProject.getId(),
              "name": newProject.getName(),
              "projectproposer": newProject.getProjectProposer(),
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
            headers: await BasicAuthConfig().getHeader(),
            body: json.encode({
              "id": modifiedProject.getId(),
              "name": modifiedProject.getName(),
              "projectproposer": modifiedProject.getProjectProposer(),
              "tag": modifiedProject.getTag(),
              "dateOfCreation": modifiedProject.getDateOfCreation(),
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
            headers: await BasicAuthConfig().getHeader()))
        .body;
  }

  Future<String> getAllProject() async {
    return (await http.get(Uri.encodeFull("$_baseUrl/get"))).body;
  }

  Future<String> getProjectById(String id) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getById/$id"))).body;
  }

  Future<String> getProjectsByIds(List<String> ids) async {
    return (await http.put(Uri.encodeFull("$_baseUrl/getByIds"),
            headers: await BasicAuthConfig().getHeader(),
            body: json.encode({ids})))
        .body;
  }

  Future<String> getProjectsByTags(List<String> tags) async {
    return (await http.put(Uri.encodeFull("$_baseUrl/getByTags"),
            headers: await BasicAuthConfig().getHeader(),
            body: json.encode({tags})))
        .body;
  }

  Future<String> getProjectByName(String name) async {
    return (await http.get(Uri.encodeFull("$_baseUrl/getByName/$name"))).body;
  }
}
