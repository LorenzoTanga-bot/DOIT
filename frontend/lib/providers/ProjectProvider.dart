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
    _listProjects.addAll(page.getListProject());
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
      if (!_listProjects.contains(project)) {
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
    for (Project oldProject in _listProjects)
      if (oldProject.getId() == project.getId()) {
        _listProjects.remove(oldProject);
        break;
      }
    _listProjects.add(updateProject);
    notifyListeners();
    return updateProject;
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
    _listProjects.remove(reloadedProject);
    _listProjects.add(reloadedProject);
    notifyListeners();
  }
}
