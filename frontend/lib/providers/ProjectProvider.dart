
import 'package:doit/model/Project.dart';
import 'package:doit/services/ProjectService.dart';
import 'package:flutter/foundation.dart';

class ProjectProvider with ChangeNotifier {
  ProjectService _service;

  List<Project> _listProjects = [];

  ProjectProvider(ProjectService service) {
    _service = service;
  }

  Future<ProjectsPage> pageListUser(int index) async {
    ProjectsPage page = await _service.getProjectsPage(index);
    updateListProjectsLocal(page.getListProject());
    return page;
  }

  List<Project> getListProject() {
    return _listProjects;
  }

  Future updateListProject(List<String> ids) async {
    List<String> notFound = [];
    for (String id in ids) {
      if (_listProjects.where((element) => element.getId() == id).isEmpty)
        notFound.add(id);
    }
    if (notFound.isNotEmpty)
      _listProjects.addAll(await _service.findByIds(notFound));
    notifyListeners();
  }

  Project findById(String id) {
    return _listProjects.firstWhere((element) => element.getId() == id);
  }

  List<Project> findByIds(List<String> ids) {
    List<Project> found = [];
    for (String id in ids) {
      found.add(findById(id));
    }
    return found;
  }

  void updateListProjectsLocal(List<Project> projects) {
    for (Project project in projects) {
      if (_listProjects
          .where((element) => element.getId() == project.getId())
          .isEmpty) {
        _listProjects.add(project);
      }
    }
    notifyListeners();
  }

  Future<List<Project>> findByTags(List<String> tags) async {
    List<Project> projects = await _service.findByTags(tags);
    updateListProjectsLocal(projects);
    return projects;
  }

  Future addProject(Project newProject) async {
    Project project = await _service.addProject(newProject);
    _listProjects.add(project);

    notifyListeners();
    return true;
  }

  Future<Project> updateProject(Project project) async {
    Project updateProject = await _service.updateProject(project);
    _listProjects
        .removeWhere((element) => element.getId() == updateProject.getId());
    _listProjects.add(updateProject);
    notifyListeners();
    return updateProject;
  }

  Future<List<Project>> findByProjectProposer(String projectProposer) async {
    List<Project> projects =
        await _service.findByProjectProposer(projectProposer);
    updateListProjectsLocal(projects);
    return projects;
  }

  Future<List<Project>> findByDesigner(String designer) async {
    List<Project> projects = await _service.findByDesigner(designer);
    updateListProjectsLocal(projects);
    return projects;
  }

  List<Project> findByName(String name) {
    List<Project> found = [];
    for (Project project in _listProjects) {
      if (project.getName().contains(name)) {
        found.add(project);
      }
    }
    return found;
  }

  Future reloadProject(String id) async {
    Project reloadedProject = await _service.findById(id);
    _listProjects
        .removeWhere((element) => element.getId() == reloadedProject.getId());
    _listProjects.add(reloadedProject);
    notifyListeners();
  }

  List<Project> findByUser(String user, bool isAprojectProposer) {
    List<Project> found = [];
    if (isAprojectProposer) {
      for (Project project in _listProjects) {
        if (project.getProjectProposer() == user) found.add(project);
      }
    } else {
      for (Project project in _listProjects) {
        if (project.getDesigners().contains(user)) found.add(project);
      }
    }
    return found;
  }
}
