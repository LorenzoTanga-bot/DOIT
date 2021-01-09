import 'dart:convert';

import 'package:doit/apicontroller/ProjectApiController.dart';
import 'package:doit/model/Tag.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/services/ProjectService.dart';

class BackEndProjectService implements ProjectService {
  ProjectApiController _controller;

  BackEndProjectService(String ip) {
    _controller = new ProjectApiController(ip);
  }

  Project _newProject(var project) {
    var parseJson = project["tag"];
    List<String> skills = new List<String>();
    for (String skill in parseJson) skills.add(skill);
    return new Project.fromJson(
        project["id"],
        project["name"],
        project["projectProposer"],
        skills,
        project["dateOfCreation"],
        project["dateOfStart"],
        project["dateOfEnd"],
        project["shortDescription"],
        project["descriptionIsAFile"],
        project["description"],
        project["evaluationMode"],
        project["startEvaluation"],
        project["endEvaluation"],
        project["candidacyMode"],
        project["startCandidacy"],
        project["endCandidacy"]);
  }

  Project _createProject(String controllerJson) {
    if (controllerJson == "") return null;
    return _newProject(json.decode(controllerJson));
  }

  List<Project> _createListProject(String controllerJson) {
    if (controllerJson == "") return null;
    var listProject = json.decode(controllerJson);
    List<Project> projects = new List<Project>();
    for (var project in listProject) {
      projects.add(_newProject(project));
    }
    return listProject;
  }

  @override
  Future<Project> addProject(Project newProject) async {
    return _createProject(await _controller.addProject(newProject));
  }

  @override
  Future<bool> deleteProject(String id) async {
    return (await _controller.deleteProject(id)) == "true";
  }

  @override
  Future<Project> findById(String id) async {
    return _createProject(await _controller.getProjectById(id));
  }

  @override
  Future<List<Project>> findByName(String name) async {
    return _createListProject(await _controller.getProjectByName(name));
  }

  @override
  Future<List<Project>> findByProjectProposer(String id) async {
    return _createListProject(await _controller.getProjectByUser(id));
  }

  @override
  Future<List<Project>> findByTag(List<String> tags) async {
    // TODO: implement findByTag  ProjectApiController implementare getProjectByTag
    throw UnimplementedError();
  }

  @override
  Future<List<Project>> getAllProject() async {
    return _createListProject(await _controller.getAllProject());
  }

  @override
  Future<Project> updateProject(Project newProject) async {
    return _createProject(await _controller.updateProject(newProject));
  }
}
