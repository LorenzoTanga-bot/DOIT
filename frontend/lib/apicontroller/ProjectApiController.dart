import 'dart:convert';

import 'package:doit/apicontroller/BasicAuthConfig.dart';
import 'package:doit/exception/BackendException.dart';
import 'package:doit/model/Project.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ProjectApiController {
  String _ip;
  String _baseUrl;

  ProjectApiController(String ip) {
    _ip = ip;
    _baseUrl = "http://$_ip:8080/doit/api/project";
  }

  String _getBodyResponse(Response response) {
    if (response.statusCode == 200)
      return response.body;
    else {
      throw (BackendException(json.decode(response.body)["message"]));
    }
  }

  Future<String> addProject(Project newProject) async {
    return _getBodyResponse(await http.post(Uri.encodeFull("$_baseUrl/new"),
        headers: BasicAuthConfig().getUserHeader(),
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
          "endCandidacy": newProject.getEndCandidacy(),
          "designers": newProject.getDesigners(),
        })));
  }

  Future<String> updateProject(Project modifiedProject) async {
    return _getBodyResponse(await http.put(Uri.encodeFull("$_baseUrl/update"),
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
          "endCandidacy": modifiedProject.getEndCandidacy(),
          "designers": modifiedProject.getDesigners(),
        })));
  }

  Future<String> deleteProject(String id) async {
    return _getBodyResponse(await http.delete(
        Uri.encodeFull("$_baseUrl/delete/$id"),
        headers: BasicAuthConfig().getUserHeader()));
  }

  Future<String> getProjectsPage(int index) async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull("$_baseUrl/public/getPage/$index/15"),
        headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> getAllProjects() async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull("$_baseUrl/public/get"),
        headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> getProjectById(String id) async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull("$_baseUrl/public/getById/$id"),
        headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> getProjectsByIds(List<String> ids) async {
    return _getBodyResponse(await http.put(
        Uri.encodeFull("$_baseUrl/public/getByIds"),
        headers: BasicAuthConfig().getBaseHeader(),
        body: json.encode(ids)));
  }

  Future<String> getProjectsByName(String name) async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull("$_baseUrl/public/getByName/$name"),
        headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> getProjectsByTags(List<String> tags) async {
    return _getBodyResponse(await http.put(
        Uri.encodeFull("$_baseUrl/public/getByTags"),
        headers: BasicAuthConfig().getBaseHeader(),
        body: json.encode(tags)));
  }

  Future<String> getProjectsByDesigner(String designer) async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull("$_baseUrl/public/getByDesigner/$designer"),
        headers: BasicAuthConfig().getBaseHeader()));
  }

  Future<String> getProjectsByProjectProposer(String projectProposer) async {
    return _getBodyResponse(await http.get(
        Uri.encodeFull(
            "$_baseUrl/public/getByProjectProposer/$projectProposer"),
        headers: BasicAuthConfig().getBaseHeader()));
  }
}
