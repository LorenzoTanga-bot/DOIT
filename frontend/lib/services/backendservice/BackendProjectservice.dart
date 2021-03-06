import 'dart:convert';

import 'package:doit/apicontroller/ProjectApiController.dart';
import 'package:doit/model/Project.dart';
import 'package:doit/services/ProjectService.dart';

class BackendProjectService implements ProjectService {
  ProjectApiController _controller;

  BackendProjectService(String ip) {
    _controller = new ProjectApiController(ip);
  }

  Project _newProject(var project) {
    List<String> tags = [];
    List<String> designers = [];
    for (String tag in project["tag"]) tags.add(tag);
    if (project["designers"] != null)
      for (String designer in project["designers"]) designers.add(designer);
    return new Project.fromJson(
      project["id"],
      project["projectProposer"],
      tags,
      project["dateOfCreation"],
      project["dateOfStart"],
      project["dateOfEnd"],
      project["name"],
      project["shortDescription"],
      project["description"],
      project["evaluationMode"],
      project["startCandidacy"],
      project["endCandidacy"],
      designers,
    );
  }

  Project _createProject(String controllerJson) {
    if (controllerJson == "") return null;
    return _newProject(json.decode(controllerJson));
  }

  List<Project> _createListProject(String controllerJson) {
    if (controllerJson == "") return null;
    var listProject = json.decode(controllerJson);
    List<Project> projects = [];
    for (var project in listProject) {
      projects.add(_newProject(project));
    }
    return projects;
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
    return _createListProject(await _controller.getProjectsByName(name));
  }

  @override
  Future<List<Project>> findByTags(List<String> tags) async {
    return _createListProject(await _controller.getProjectsByTags(tags));
  }

  @override
  Future<List<Project>> findAll() async {
    return _createListProject(await _controller.getAllProjects());
  }

  @override
  Future<Project> updateProject(Project modifiedProject) async {
    return _createProject(await _controller.updateProject(modifiedProject));
  }

  @override
  Future<List<Project>> findByIds(List<String> ids) async {
    return _createListProject(await _controller.getProjectsByIds(ids));
  }

  @override
  Future<ProjectsPage> getProjectsPage(int index) async {
    var page = json.decode(await _controller.getProjectsPage(index));
    ProjectsPage pPage = new ProjectsPage(
        _createListProject(json.encode(page["content"])),
        page["totalPages"],
        page["totalElements"],
        page["last"],
        page["first"],
        page["size"],
        page["numberOfElements"],
        page["number"]);
    return pPage;
  }

  @override
  Future<List<Project>> findByDesigner(String designer) async {
    return _createListProject(
        await _controller.getProjectsByDesigner(designer));
  }

  @override
  Future<List<Project>> findByProjectProposer(String projectProposer)async {
   return _createListProject(
        await _controller.getProjectsByProjectProposer(projectProposer));
 }
}
